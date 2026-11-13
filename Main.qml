import QtQuick
import QtCore
import QtQuick.Controls.Basic

Window {
    property alias addSheet: addSheet
    property alias addPage: addPage

    width: Constants.width
    height: Constants.height

    minimumWidth: 320
    minimumHeight: 480

    visible: true
    title: "Assignment Manager"

    // On startup: apply the saved theme and language
    Component.onCompleted: {
        Constants.themeIndex = appSettings.themeIndex
        Qt.uiLanguage = appSettings.languageCode
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

    Drawer {
        id: addSheet
        edge: Qt.BottomEdge
        width: mainScreen.width
        height: mainScreen.height * 0.92
        modal: true
        interactive: true

        // Smooth slide-up entrance
        enter: Transition {
            NumberAnimation { property: "position"; from: 0.0; to: 1.0; duration: 320; easing.type: Easing.OutCubic }
        }
        // Smooth slide-down exit
        exit: Transition {
            NumberAnimation { property: "position"; from: 1.0; to: 0.0; duration: 280; easing.type: Easing.InCubic }
        }

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
}
