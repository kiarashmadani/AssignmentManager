import QtQuick

Item {
    id: picker
    property alias hourWheel: hourWheel
    property alias minuteWheel: minuteWheel

    implicitWidth: timeRow.implicitWidth + Constants.padding
    implicitHeight: timeRow.implicitHeight

    // 1. Frosted base
    Rectangle {
        anchors.fill: parent
        radius: Constants.radius
        color: Constants.card
        opacity: Constants.isDark ? 0.45 : 0.6
    }

    // 2. Glass shine from the top edge
    Rectangle {
        anchors.fill: parent
        radius: Constants.radius
        opacity: 0.6
        gradient: Gradient {
            GradientStop { position: 0.0; color: Constants.glassShine }
            GradientStop { position: 0.5; color: "transparent" }
        }
    }

    // 3. Glass lens behind the selected row
    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 6
        height: 40

        Rectangle {                         // tinted gel
            anchors.fill: parent
            radius: height / 2
            color: Constants.primary
            opacity: 0.35
        }
        Rectangle {                         // shine on the lens
            anchors.fill: parent
            radius: height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: Constants.glassEdge }
                GradientStop { position: 0.45; color: "transparent" }
                GradientStop { position: 1.0; color: Constants.glassShine }
            }
            opacity: 0.7
        }
        Rectangle {                         // lens rim
            anchors.fill: parent
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: Constants.glassEdge
        }
    }

    // 4. Outer rim
    Rectangle {
        anchors.fill: parent
        radius: Constants.radius
        color: "transparent"
        border.width: 1
        border.color: Constants.glassEdge
    }

    // 5. The wheels
    Row {
        id: timeRow
        anchors.centerIn: parent

        TimeWheel { id: hourWheel; model: 24; currentIndex: 23 }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ":"
            color: Constants.foreground
            font.pixelSize: Constants.bodySize + 6
            font.bold: true
        }
        TimeWheel { id: minuteWheel; model: 60; currentIndex: 59 }
    }
}
