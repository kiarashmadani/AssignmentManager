import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root

    width: Constants.width
    height: Constants.height

    color: Constants.windowColor

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.margins: Constants.padding
        spacing: Constants.spacing

        Text {
            id: assignmentText
            Layout.fillWidth: true

            text: qsTr("Assignments")
            color: Constants.textColor
            font.pixelSize: Constants.titleSize
            font.bold: true

            anchors.top: parent.top
        }
    }
    Button {
        id: addButton
        width: 56
        height: 56
        padding: 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Constants.padding * 2

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
}
