import QtQuick
import QtQuick.Layouts

Item {
    id: picker

    // ── Public API (Drop-in backward compatibility) ──
    property alias dayWheel: dayWheel
    property alias monthWheel: monthWheel
    property alias yearWheel: yearWheel
    property int firstYear: 2026

    implicitWidth: 200
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

    // ── 2. Drum Wheels & Delimiters (Filling Width: Year / Month / Day) ──
    RowLayout {
        id: timeRow
        anchors.fill: parent
        spacing: 0

        TimeWheel {
            id: yearWheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 68
            model: 20
            wrap: false
            offset: picker.firstYear
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 2
            font.family: Constants.fontFamily
            opacity: 0.40
        }

        TimeWheel {
            id: monthWheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: 12
            offset: 1
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 2
            font.family: Constants.fontFamily
            opacity: 0.40
        }

        TimeWheel {
            id: dayWheel
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: 31
            offset: 1
        }
    }
}
