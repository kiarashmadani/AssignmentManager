import QtQuick
import QtQuick.Controls.Basic

TabButton {
    id: tab
    implicitHeight: 48
    background: Rectangle {
        radius: height / 2
        color: tab.checked ? Constants.primary : "transparent"
    }
    contentItem: Text {
        text: tab.text
        color: tab.checked ? Constants.primaryForeground : Constants.foreground
        font.pixelSize: Constants.bodySize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
