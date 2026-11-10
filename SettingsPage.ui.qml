import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    width: Constants.width
    height: Constants.height

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Constants.padding
            spacing: Constants.spacing

            Text {
                id: settingsText
                Layout.fillWidth: true
                text: qsTr("Settings")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize
                font.bold: true
            }

            Item { Layout.fillHeight: true }
        }
    }
}
