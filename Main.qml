import QtQuick
import QtCore
import QtQuick.Controls.Basic
import AssignmentManager

Window {
    property alias addSheet: addSheet
    property alias addPage: addPage

    width: Constants.width
    height: Constants.height

    minimumWidth: 320
    minimumHeight: 480

    visible: true
    title: "Assignment Manager"

    // On startup: apply the saved theme and language, and hook up the C++ model
    Component.onCompleted: {
        var webTheme = engine.getSavedThemeIndex()
        var webLang = engine.getSavedLanguage()

        if (webTheme >= 0) {
            Constants.themeIndex = webTheme
            appSettings.themeIndex = webTheme
        } else {
            Constants.themeIndex = appSettings.themeIndex
        }

        if (webLang && webLang.length > 0) {
            Qt.uiLanguage = webLang
            appSettings.languageCode = webLang
        } else {
            Qt.uiLanguage = appSettings.languageCode
        }

        mainScreen.assignmentsPage.assignmentList.model = engine

        // Set wheels immediately from saved cache (offline-ready!)
        addPage.datePicker.yearWheel.currentIndex = Math.max(0, appSettings.savedYear - addPage.datePicker.firstYear)
        addPage.datePicker.monthWheel.currentIndex = Math.max(0, appSettings.savedMonth - addPage.datePicker.monthWheel.offset)
        addPage.datePicker.dayWheel.currentIndex = Math.max(0, appSettings.savedDay - addPage.datePicker.dayWheel.offset)
        addPage.timePicker.hourWheel.currentIndex = appSettings.savedHour
        addPage.timePicker.minuteWheel.currentIndex = appSettings.savedMinute

        engine.getCalendarOnline()
        syncCurrentThemeToWeb()
    }

    function syncCurrentThemeToWeb() {
        if (engine && typeof engine.syncThemeToWeb === "function") {
            var t = Constants.theme || (Constants.themes ? Constants.themes[Constants.themeIndex] : null)
            if (t) {
                engine.syncThemeToWeb(
                    Constants.themeIndex,
                    Qt.uiLanguage || "en",
                    t.background.toString(),
                    t.primary.toString(),
                    t.accent.toString(),
                    t.secondary.toString(),
                    Boolean(t.dark)
                );
            }
        }
    }

    Settings {
        id: appSettings
        property int themeIndex: 0
        property string languageCode: "en"
        property int savedYear: 2026
        property int savedMonth: 11
        property int savedDay: 19
        property int savedHour: 12
        property int savedMinute: 0
    }

    MainScreen {
        id: mainScreen
        anchors.fill: parent
    }

    Connections {
        target: Constants
        function onThemeIndexChanged() {
            appSettings.themeIndex = Constants.themeIndex
            syncCurrentThemeToWeb()
        }
    }

    Connections {
        target: mainScreen.pages
        function onCurrentIndexChanged() {
            mainScreen.navBar.currentIndex = mainScreen.pages.currentIndex
        }
    }
    Connections {
        target: mainScreen.settingsPage.themeGroup
        function onClicked(button) {
            Constants.themeIndex = button.themeIndex
        }
    }
    Connections {
        target: mainScreen.settingsPage.languageGroup
        function onClicked(button) {
            Qt.uiLanguage = button.languageCode
            appSettings.languageCode = button.languageCode
            syncCurrentThemeToWeb()
        }
    }

    AssignmentManager {
        id: engine
    }

    Drawer {
        id: addSheet
        edge: Qt.BottomEdge
        width: mainScreen.width
        height: mainScreen.height * 0.92
        modal: true
        interactive: true

        background: Rectangle {
            color: Constants.background
            topLeftRadius: 28
            topRightRadius: 28
            bottomLeftRadius: 0
            bottomRightRadius: 0
            border.width: 1
            border.color: Constants.border
        }

        Overlay.modal: Rectangle {
            color: Constants.scrim
        }

        AddAssignmentPage {
            id: addPage
            anchors.fill: parent
        }
    }

    GlassToast {
        id: toast
        parent: Overlay.overlay
        z: 999
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    }

    Timer {
        id: toastTimer
        interval: 2600
        onTriggered: toast.showing = false
    }

    Connections {
        target: engine
        function onValidationError(msg) {
            toast.message = msg
            toast.isError = true
            toast.showing = true
            toastTimer.restart()
        }
        function onAssignmentToggled(title, isCompleted) {
            toast.isError = false
            toast.message = isCompleted
                ? qsTr("🎉 Completed: %1").arg(title)
                : qsTr("↩️ Restored: %1").arg(title)
            toast.showing = true
            toastTimer.restart()
        }
        function onAssignmentDeleted(title) {
            toast.isError = false
            toast.message = qsTr("🗑️ Deleted: %1").arg(title)
            toast.showing = true
            toastTimer.restart()
        }
        function onOnlineCalendarReady(year, month, day, hour, minute) {
            appSettings.savedYear = year
            appSettings.savedMonth = month
            appSettings.savedDay = day
            appSettings.savedHour = hour
            appSettings.savedMinute = minute

            addPage.datePicker.yearWheel.currentIndex = Math.max(0, year - addPage.datePicker.firstYear)
            addPage.datePicker.monthWheel.currentIndex = Math.max(0, month - addPage.datePicker.monthWheel.offset)
            addPage.datePicker.dayWheel.currentIndex = Math.max(0, day - addPage.datePicker.dayWheel.offset)
            addPage.timePicker.hourWheel.currentIndex = hour
            addPage.timePicker.minuteWheel.currentIndex = minute
        }
    }

    Connections {
        target: addPage
        function onTitleTextChanged() {
            if (addPage.titleText.trim().length > 0)
                addPage.titleError = false
        }
        function onCourseTextChanged() {
            if (addPage.courseText.trim().length > 0)
                addPage.courseError = false
        }
    }

    Connections {
        target: mainScreen.addButton
        function onClicked() {
            addPage.titleError = false
            addPage.courseError = false
            addPage.isUrgent = false
            addSheet.open()
        }
    }
    Connections {
        target: addPage.cancelButton
        function onClicked() {
            addPage.titleError = false
            addPage.courseError = false
            addPage.isUrgent = false
            addSheet.close()
        }
    }
    Connections {
        target: addPage.saveButton
        function onClicked() {
            addPage.titleError  = addPage.titleText.trim().length === 0
            addPage.courseError = addPage.courseText.trim().length === 0

            var year   = addPage.datePicker.yearWheel.currentIndex + addPage.datePicker.firstYear
            var month  = addPage.datePicker.monthWheel.currentIndex + addPage.datePicker.monthWheel.offset
            var day    = addPage.datePicker.dayWheel.currentIndex + addPage.datePicker.dayWheel.offset
            var hour   = addPage.timePicker.hourWheel.currentIndex
            var minute = addPage.timePicker.minuteWheel.currentIndex

            var ok = engine.addAssignment(
                addPage.titleText,
                addPage.descriptionText,
                addPage.courseText,
                year, month, day,
                hour, minute,
                addPage.isUrgent
            )

            if (ok) {
                addPage.titleText = ""
                addPage.descriptionText = ""
                addPage.courseText = ""
                addPage.isUrgent = false
                addPage.titleError = false
                addPage.courseError = false

                // Reset wheels to today's date & time for next time
                addPage.datePicker.yearWheel.currentIndex = Math.max(0, appSettings.savedYear - addPage.datePicker.firstYear)
                addPage.datePicker.monthWheel.currentIndex = Math.max(0, appSettings.savedMonth - addPage.datePicker.monthWheel.offset)
                addPage.datePicker.dayWheel.currentIndex = Math.max(0, appSettings.savedDay - addPage.datePicker.dayWheel.offset)
                addPage.timePicker.hourWheel.currentIndex = appSettings.savedHour
                addPage.timePicker.minuteWheel.currentIndex = appSettings.savedMinute

                addSheet.close()
            }
        }
    }
}
