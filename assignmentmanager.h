#ifndef ASSIGNMENTMANAGER_H
#define ASSIGNMENTMANAGER_H

#include <QObject>
#include <qqml.h>
#include <QDate>
#include <QTime>

struct Assignment {
    QString title;
    QString description;
    QString course;
    QDate dueDate;
    QTime dueTime;
    bool isCompleted = false;
};

class AssignmentManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit AssignmentManager(QObject *parent = nullptr);

public slots:
    void addAssignment(
        const QString &title,
        const QString &description,
        const QString &course,
        int year, int month, int day,
        int hour, int minute);

signals:
};

#endif // ASSIGNMENTMANAGER_H
