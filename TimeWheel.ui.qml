import QtQuick
import QtQuick.Controls.Basic

Tumbler {
    id: wheel
    implicitWidth: 50
    implicitHeight: 140
    visibleItemCount: 5
    property int offset: 0          // shown number = row + offset (days and months start at 1)

    wrap: true

    delegate: Item {
        required property int index
        required property var modelData
        readonly property int value: modelData + (Tumbler.tumbler as TimeWheel).offset
        readonly property real disp: Math.abs(Tumbler.displacement)
        readonly property real normalDisp: Math.min(1.0, disp / (Tumbler.tumbler.visibleItemCount / 2))

        width: wheel.width
        height: wheel.height / wheel.visibleItemCount

        // Apple 3D Drum Perspective Falloff
        opacity: Math.max(0.12, 1.0 - Math.pow(normalDisp, 1.2) * 0.82)
        scale: Math.max(0.68, 1.05 - normalDisp * 0.32)

        Text {
            anchors.centerIn: parent
            text: (parent.value < 10 ? "0" : "") + parent.value
            color: parent.disp < 0.5 ? Constants.foreground : Constants.mutedForeground
            font.pixelSize: parent.disp < 0.5 ? Constants.bodySize + 6 : Constants.bodySize + 3
            font.family: Constants.fontFamily
            font.weight: parent.disp < 0.5 ? Font.Bold : Font.Normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
