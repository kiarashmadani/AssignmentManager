import QtQuick
import QtQuick.Controls.Basic

TabBar {
    id: bar
    implicitWidth: 260
    implicitHeight: 60
    padding: 6

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Constants.card
            opacity: 0.7
        }
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: Constants.isDark ? "#33FFFFFF" : "#99FFFFFF"
        }
    }

    NavTab { text: qsTr("Assignments") }
    NavTab { text: qsTr("Settings") }
}
