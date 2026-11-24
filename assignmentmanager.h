#ifndef ASSIGNMENTMANAGER_H
#define ASSIGNMENTMANAGER_H

#include <QAbstractListModel>
#include <qqml.h>
#include <vector>
#include <QDate>
#include <QTime>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QByteArray>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>

struct Assignment {
    QString title;
    QString description;
    QString course;
    QDate dueDate;
    QTime dueTime;
    bool isCompleted = false;
    bool isUrgent = false;
};

class AssignmentManager : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int      totalCount              READ totalCount             NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      totalCompleted          READ totalCompleted         NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      dueCompleteToday        READ dueCompleteToday       NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      overdueCount            READ overdueCount           NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      urgentCount             READ urgentCount            NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      urgentPendingCount      READ urgentPendingCount     NOTIFY statesChanged FINAL)
    Q_PROPERTY(int      completionPercentage    READ completionPercentage   NOTIFY statesChanged FINAL)
    Q_PROPERTY(qreal    completionRatio         READ completionRatio        NOTIFY statesChanged FINAL)
    Q_PROPERTY(qreal    overdueRatio            READ overdueRatio           NOTIFY statesChanged FINAL)
    Q_PROPERTY(qreal    urgentRatio             READ urgentRatio            NOTIFY statesChanged FINAL)
    Q_PROPERTY(qreal    urgentPendingRatio      READ urgentPendingRatio     NOTIFY statesChanged FINAL)

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        DescriptionRole,
        CourseRole,
        DayRole,
        DeadlineHoursRole,
        DeadlineMinutesRole,
        IsCompletedRole,
        IsOverdueRole,
        IsUrgentRole
    };

    explicit AssignmentManager(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    int totalCount() const;
    int totalCompleted() const;
    int dueCompleteToday() const;
    int overdueCount() const;
    int urgentCount() const;
    int urgentPendingCount() const;
    int completionPercentage() const;
    qreal completionRatio() const;
    qreal overdueRatio() const;
    qreal urgentRatio() const;
    qreal urgentPendingRatio() const;

public slots:
    bool addAssignment(
        const QString &title,
        const QString &description,
        const QString &course,
        int year, int month, int day,
        int hour, int minute,
        bool isUrgent = false);

    void toggleCompleted(int row);
    bool deleteAssignment(int row);
    void getCalendarOnline();
    void saveToFiles();
    void loadFromFiles();
    void syncThemeToWeb(const QString &bg, const QString &primary, const QString &accent, const QString &secondary, bool isDark);

private:
    std::vector<Assignment> m_assignments;
    QNetworkAccessManager *m_netManager = nullptr;

signals:
    void validationError(const QString& msg);
    void onlineCalendarReady(int year, int month, int day, int hour, int minute);
    void statesChanged();
    void assignmentToggled(const QString &title, bool isCompleted);
    void assignmentDeleted(const QString &title);
};

#endif // ASSIGNMENTMANAGER_H
