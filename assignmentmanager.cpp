#include "assignmentmanager.h"

AssignmentManager::AssignmentManager(QObject *parent)
    : QAbstractListModel{parent}
{}

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
        { IsCompletedRole,     "isCompleted" }
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
    case DayRole:
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
    int hour, int minute)
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

    int newRow = static_cast<int>(m_assignments.size());
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_assignments.push_back(addedAssignment);
    endInsertRows();
    return true;
}

void AssignmentManager::reloadAssignments()
{

}

