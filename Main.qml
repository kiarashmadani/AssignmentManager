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

    Connections {
        target: mainScreen.addButton
        function onClicked() { addSheet.open() }
    }
    Connections {
        target: addPage.cancelButton
        function onClicked() { addSheet.close() }
    }
    Connections {
        target: addPage.saveButton
        function onClicked() {
            var year   = addPage.datePicker.yearWheel.currentIndex + addPage.datePicker.firstYear
            var month  = addPage.datePicker.monthWheel.currentIndex + addPage.datePicker.monthWheel.offset
            var day    = addPage.datePicker.dayWheel.currentIndex + addPage.datePicker.dayWheel.offset
            var hour   = addPage.timePicker.hourWheel.currentIndex
            var minute = addPage.timePicker.minuteWheel.currentIndex

            engine.addAssignment(
                addPage.titleText,
                addPage.descriptionText,
                addPage.courseText,
                year, month, day,
                hour, minute
            )

            addPage.titleText = ""
            addPage.descriptionText = ""
            addPage.courseText = ""
            addSheet.close()
        }
    }
}
