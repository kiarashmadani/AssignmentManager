import QtQuick
import QtCore

Window {
    Component.onCompleted: Constants.themeIndex = appSettings.themeIndex
    width: Constants.width
    height: Constants.height

    minimumWidth: 320
    minimumHeight: 480

    visible: true
    title: "Assignment Manager"


    Settings {
        id: appSettings
        property int themeIndex: 0
    }

    MainScreen {
        id: mainScreen
        anchors.fill: parent
    }

    Connections {
        target: mainScreen.pages
        function onCurrentIndexChanged () {
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
}
