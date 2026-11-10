import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property alias pages: pages
    property alias navBar: navBar
    property alias addButton: addButton

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        SwipeView {
            id: pages
            anchors.fill: parent
            currentIndex: navBar.currentIndex

            AssignmentsPage {}
            SettingsPage {}
        }
    }

    Button {
        id: addButton
        width: 56
        height: 56
        padding: 0
        visible: navBar.currentIndex === 0
        anchors.right: parent.right
        anchors.bottom: navBar.top
        anchors.margins: Constants.padding
        text: "+"

        background: Rectangle {
            radius: Constants.radius
            color: Constants.primary
            opacity: addButton.down ? 0.85 : 1.0
        }
        contentItem: Item {
            Rectangle {
                anchors.centerIn: parent
                width: 22; height: 3; radius: 1.5
                color: Constants.primaryForeground
            }
            Rectangle {
                anchors.centerIn: parent
                width: 3; height: 22; radius: 1.5
                color: Constants.primaryForeground
            }
        }
    }

    NavBar {
        id: navBar
        blurSource: page
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Constants.padding
    }
}
