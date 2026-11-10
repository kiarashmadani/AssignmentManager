import QtQuick

Window {
    width: Constants.width
    height: Constants.height

    minimumWidth: 320
    minimumHeight: 480

    visible: true
    title: "Assignment Manager"

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
}
