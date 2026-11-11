import QtQuick
import QtCore

Window {
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
}
