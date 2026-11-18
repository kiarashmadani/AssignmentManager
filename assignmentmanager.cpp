#include "assignmentmanager.h"

AssignmentManager::AssignmentManager(QObject *parent)
    : QObject{parent}
{}

void AssignmentManager::addAssignment(
    const QString &title,
    const QString &description,
    const QString &course,
    int year, int month, int day,
    int hour, int minute)
{
    Q_UNUSED(title);
    Q_UNUSED(description);
    Q_UNUSED(course);
    Q_UNUSED(year);
    Q_UNUSED(month);
    Q_UNUSED(day);
    Q_UNUSED(hour);
    Q_UNUSED(minute);

    qDebug() << "Function is working";
}

