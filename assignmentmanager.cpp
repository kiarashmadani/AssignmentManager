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

void AssignmentManager::addAssignment(
    const QString &title,
    const QString &description,
    const QString &course,
    int year, int month, int day,
    int hour, int minute)
{
    Assignment addedAssignment;
    addedAssignment.title = title;
    addedAssignment.description = description;
    addedAssignment.course = course;
    addedAssignment.dueTime = QTime(hour, minute);
    addedAssignment.dueDate = QDate(year, month, day);
    addedAssignment.isCompleted = false;

    int newRow = static_cast<int>(m_assignments.size());
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_assignments.push_back(addedAssignment);
    endInsertRows();
}

void AssignmentManager::reloadAssignments()
{

}

