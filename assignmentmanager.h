#ifndef ASSIGNMENTMANAGER_H
#define ASSIGNMENTMANAGER_H

#include <QAbstractListModel>
#include <qqml.h>
#include <vector>
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

class AssignmentManager : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        DescriptionRole,
        CourseRole,
        DayRole,
        DeadlineHoursRole,
        DeadlineMinutesRole,
        IsCompletedRole
    };

    explicit AssignmentManager(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

public slots:
    bool addAssignment(
        const QString &title,
        const QString &description,
        const QString &course,
        int year, int month, int day,
        int hour, int minute);


private:
    std::vector<Assignment> m_assignments;

    void reloadAssignments();

signals:
    void validationError(const QString& msg);
};

#endif // ASSIGNMENTMANAGER_H
