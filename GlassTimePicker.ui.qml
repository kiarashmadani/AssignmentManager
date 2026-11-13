import QtQuick

Item {
    id: picker
    property alias hourWheel: hourWheel
    property alias minuteWheel: minuteWheel

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

    // 3. Wheels & Colon Delimiter
    Row {
        id: timeRow
        anchors.centerIn: parent
        spacing: 6

        TimeWheel { id: hourWheel; model: 24; currentIndex: 23; implicitWidth: 46 }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1
            text: ":"
            color: Constants.foreground
            font.pixelSize: Constants.bodySize + 6
            font.family: Constants.fontFamily
            font.weight: Font.Bold
            opacity: 0.75
        }

        TimeWheel { id: minuteWheel; model: 60; currentIndex: 59; implicitWidth: 46 }
    }
}
