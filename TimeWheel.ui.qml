import QtQuick
import QtQuick.Controls.Basic

Tumbler {
    implicitWidth: 44
    implicitHeight: 120
    visibleItemCount: 3
    property int offset: 0          // shown number = row + offset (days and months start at 1)

    delegate: Text {
        required property int index
        required property var modelData
        readonly property int value: modelData + (Tumbler.tumbler as TimeWheel).offset
        text: (value < 10 ? "0" : "") + value     // 9 -> "09"
        color: Constants.foreground
        font.pixelSize: Constants.bodySize + 6
        font.family: Constants.fontFamily
        font.bold: Tumbler.displacement === 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        // fades out the further it is from the middle row
        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
    }
}
