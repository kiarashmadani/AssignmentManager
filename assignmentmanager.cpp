#include "assignmentmanager.h"

AssignmentManager::AssignmentManager(QObject *parent)
    : QAbstractListModel{parent}
{
    loadFromFiles();
    m_netManager = new QNetworkAccessManager(this);
}

int AssignmentManager::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return static_cast<int>(m_assignments.size());
}

QHash<int, QByteArray> AssignmentManager::roleNames() const
{
    return {
        { TitleRole,           "title" },
        { DescriptionRole,     "descriptions" },
        { CourseRole,          "course" },
        { DayRole,             "day" },
        { DeadlineHoursRole,   "deadlineHours" },
        { DeadlineMinutesRole, "deadlineMinutes" },
        { IsCompletedRole,     "isCompleted" },
        { IsOverdueRole,       "isOverdue" },
        { IsUrgentRole,        "isUrgent" }
    };
}

QVariant AssignmentManager::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (!index.isValid() || row < 0 || row >= static_cast<int>(m_assignments.size()))
        return QVariant();

    const Assignment &item = m_assignments[row];

    switch (role) {
    case TitleRole:
        return item.title;
    case DescriptionRole:
        return item.description;
    case CourseRole:
        return item.course;
    case IsCompletedRole:
        return item.isCompleted;
    case IsUrgentRole:
        return item.isUrgent;
    case IsOverdueRole: {
        if (item.isCompleted)
            return false;
        QDateTime deadline(item.dueDate, item.dueTime);
        return deadline < QDateTime::currentDateTime();
    }
    case DayRole:
        if (item.dueDate == QDate::currentDate())
            return tr("Today");
        if (item.dueDate == QDate::currentDate().addDays(1))
            return tr("Tomorrow");
        return item.dueDate.toString("MMM d");
    case DeadlineHoursRole:
        return item.dueTime.toString("HH");
    case DeadlineMinutesRole:
        return item.dueTime.toString("mm");
    default:
        return QVariant();
    }
}

bool AssignmentManager::addAssignment(
    const QString &title,
    const QString &description,
    const QString &course,
    int year, int month, int day,
    int hour, int minute,
    bool isUrgent)
{
    if (title.trimmed().isEmpty() || course.trimmed().isEmpty())
    {
        emit validationError(tr("Please fill at least Title and Course!"));
        return false;
    }

    QDate dueDate(year, month, day);
    if (!dueDate.isValid())
    {
        emit validationError(tr("Please select a valid date!"));
        return false;
    }

    Assignment addedAssignment;
    addedAssignment.title = title.trimmed();
    addedAssignment.description = description.trimmed();
    addedAssignment.course = course.trimmed();
    addedAssignment.dueTime = QTime(hour, minute);
    addedAssignment.dueDate = dueDate;
    addedAssignment.isCompleted = false;
    addedAssignment.isUrgent = isUrgent;

    int newRow = static_cast<int>(m_assignments.size());
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_assignments.push_back(addedAssignment);
    saveToFiles();
    endInsertRows();
    emit statesChanged();
    return true;
}



void AssignmentManager::getCalendarOnline()
{
    QDate currentDate = QDate::currentDate();
    QTime currentTime = QTime::currentTime();

    int year = currentDate.year();
    int month = currentDate.month();
    int day = currentDate.day();
    int hour = currentTime.hour();
    int minute = currentTime.minute();

    emit onlineCalendarReady(year, month, day, hour, minute);
}

void AssignmentManager::saveToFiles()
{
    QString folderPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(folderPath);
    if (!dir.exists())
        dir.mkpath(".");
    QString filePath = dir.filePath("assignments.json");

    QJsonArray array;
    foreach (const auto& item, m_assignments)
    {
        QJsonObject obj;
        obj["title"]       = item.title;
        obj["description"] = item.description;
        obj["course"]      = item.course;
        obj["dueDate"]     = item.dueDate.toString(Qt::ISODate);
        obj["dueTime"]     = item.dueTime.toString("HH:mm");
        obj["isCompleted"] = item.isCompleted;
        obj["isUrgent"]    = item.isUrgent;

        array.append(obj);
    }

    QJsonDocument doc(array);
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly))
    {
        file.write(doc.toJson());
        file.close();
    }
}

void AssignmentManager::loadFromFiles()
{
    QString folderPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(folderPath);
    if (!dir.exists())
        dir.mkpath(".");
    QString filePath = dir.filePath("assignments.json");

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly))
        return;

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray array = doc.array();
    foreach (const auto& val, array)
    {
        QJsonObject obj = val.toObject();
        Assignment item;

        item.title       = obj["title"].toString();
        item.description = obj["description"].toString();
        item.course      = obj["course"].toString();
        item.dueDate     = QDate::fromString(obj["dueDate"].toString(), Qt::ISODate);
        item.dueTime     = QTime::fromString(obj["dueTime"].toString(), "HH:mm");
        item.isCompleted = obj["isCompleted"].toBool();
        item.isUrgent    = obj["isUrgent"].toBool();

        m_assignments.push_back(item);
    }
    emit statesChanged();
}

void AssignmentManager::toggleCompleted(int row)
{
    if (row < 0 || row >= static_cast<int>(m_assignments.size()))
        return;

    m_assignments[row].isCompleted = !m_assignments[row].isCompleted;
    QModelIndex idx = index(row);
    emit dataChanged(idx, idx, { IsCompletedRole, IsOverdueRole, IsUrgentRole });
    saveToFiles();
    emit statesChanged();
}



int AssignmentManager::totalCount() const
{
    return static_cast<int>(m_assignments.size());
}

int AssignmentManager::totalCompleted() const
{
    int count = 0;
    for (const auto &item : m_assignments) {
        if (item.isCompleted)
            count++;
    }
    return count;
}

int AssignmentManager::dueCompleteToday() const
{
    int count = 0;
    QDate today = QDate::currentDate();
    for (const auto &item : m_assignments) {
        if (item.dueDate == today && !item.isCompleted)
            count++;
    }
    return count;
}

int AssignmentManager::overdueCount() const
{
    int count = 0;
    QDateTime now = QDateTime::currentDateTime();
    for (const auto &item : m_assignments) {
        if (!item.isCompleted && QDateTime(item.dueDate, item.dueTime) < now)
            count++;
    }
    return count;
}

int AssignmentManager::urgentCount() const
{
    int count = 0;
    for (const auto &item : m_assignments) {
        if (item.isUrgent && !item.isCompleted)
            count++;
    }
    return count;
}

int AssignmentManager::urgentPendingCount() const
{
    int count = 0;
    QDateTime now = QDateTime::currentDateTime();
    for (const auto &item : m_assignments) {
        if (item.isUrgent && !item.isCompleted && QDateTime(item.dueDate, item.dueTime) >= now)
            count++;
    }
    return count;
}

int AssignmentManager::completionPercentage() const
{
    if (m_assignments.empty())
        return 0;

    return static_cast<int>((static_cast<double>(totalCompleted()) / m_assignments.size()) * 100.0);
}

qreal AssignmentManager::completionRatio() const
{
    if (m_assignments.empty())
        return 0.0;

    return static_cast<qreal>(totalCompleted()) / static_cast<qreal>(m_assignments.size());
}

qreal AssignmentManager::overdueRatio() const
{
    if (m_assignments.empty())
        return 0.0;

    return static_cast<qreal>(overdueCount()) / static_cast<qreal>(m_assignments.size());
}

qreal AssignmentManager::urgentRatio() const
{
    if (m_assignments.empty())
        return 0.0;

    return static_cast<qreal>(urgentCount()) / static_cast<qreal>(m_assignments.size());
}

qreal AssignmentManager::urgentPendingRatio() const
{
    if (m_assignments.empty())
        return 0.0;

    return static_cast<qreal>(urgentPendingCount()) / static_cast<qreal>(m_assignments.size());
}

