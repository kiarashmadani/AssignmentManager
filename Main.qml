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
        Constants.themeIndex = appSettings.themeIndex
        Qt.uiLanguage = appSettings.languageCode
        mainScreen.assignmentsPage.assignmentList.model = engine
    }

    Settings {
        id: appSettings
        property int themeIndex: 0
        property string languageCode: "en"
    }

    MainScreen {
        id: mainScreen
        anchors.fill: parent
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
            appSettings.themeIndex = button.themeIndex
        }
    }
    Connections {
        target: mainScreen.settingsPage.languageGroup
        function onClicked(button) {
            Qt.uiLanguage = button.languageCode
            appSettings.languageCode = button.languageCode
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
            addSheet.open()
        }
    }
    Connections {
        target: addPage.cancelButton
        function onClicked() {
            addPage.titleError = false
            addPage.courseError = false
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
                hour, minute
            )

            if (ok) {
                addPage.titleText = ""
                addPage.descriptionText = ""
                addPage.courseText = ""
                addPage.titleError = false
                addPage.courseError = false
                addSheet.close()
            }
        }
    }
}
