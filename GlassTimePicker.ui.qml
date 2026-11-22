import QtQuick
import QtQuick.Layouts

Item {
    id: picker

    // ── Public API (Drop-in backward compatibility) ──
    property alias hourWheel: hourWheel
    property alias minuteWheel: minuteWheel

    implicitWidth: 140
    implicitHeight: 130
    clip: true

    // ── 1. Apple Selection Capsule (Center Active Row) ──
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        height: 36
        radius: 9
        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06)
    }

    // ── 2. Drum Wheels & Colon Delimiter (Filling Width) ──
    RowLayout {
        id: timeRow
        anchors.fill: parent
        spacing: 0

        TimeWheel {
            id: hourWheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: 24
            currentIndex: 12
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.bottomMargin: 1
            text: ":"
            color: Constants.foreground
            font.pixelSize: Constants.bodySize + 4
            font.family: Constants.fontFamily
            font.weight: Font.Bold
            opacity: 0.65
        }

        TimeWheel {
            id: minuteWheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: 60
            currentIndex: 0
        }
    }
}
