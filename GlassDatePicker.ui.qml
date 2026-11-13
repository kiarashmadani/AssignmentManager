import QtQuick

Item {
    id: picker
    property alias dayWheel: dayWheel
    property alias monthWheel: monthWheel
    property alias yearWheel: yearWheel
    property int firstYear: 2026

    implicitWidth: timeRow.implicitWidth + 24
    implicitHeight: 148

    // 1. Frosted Glass Housing
    Rectangle {
        anchors.fill: parent
        radius: 16
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.88)
            }
            GradientStop {
                position: 1.0
                color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(1, 1, 1, 0.78)
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: Constants.card
            opacity: Constants.isDark ? 0.35 : 0.20
        }

        // Perimeter hairline
        border.width: 1
        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.07)
    }

    // 2. Apple Frosted Selection Capsule (Center Active Lens)
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        height: 38
        radius: 10
        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.05)
        border.width: 1
        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, 0.08)
    }

    // 3. Wheels & Delimiters
    Row {
        id: timeRow
        anchors.centerIn: parent
        spacing: 4

        TimeWheel { id: dayWheel; model: 31; offset: 1; implicitWidth: 46 }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 4
            font.family: Constants.fontFamily
            opacity: 0.60
        }

        TimeWheel { id: monthWheel; model: 12; offset: 1; implicitWidth: 46 }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 4
            font.family: Constants.fontFamily
            opacity: 0.60
        }

        TimeWheel { id: yearWheel; model: 5; offset: picker.firstYear; implicitWidth: 64 }
    }
}
