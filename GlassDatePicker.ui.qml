import QtQuick

Item {
    id: picker
    property alias dayWheel: dayWheel
    property alias monthWheel: monthWheel
    property alias yearWheel: yearWheel
    property int firstYear: 2026     // Main.qml sets this to the current year

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

    // 5. The wheels: day / month / year
    Row {
        id: timeRow
        anchors.centerIn: parent
        spacing: 2

        TimeWheel { id: dayWheel; model: 31; offset: 1 }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 2
        }
        TimeWheel { id: monthWheel; model: 12; offset: 1 }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "/"
            color: Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 2
        }
        TimeWheel { id: yearWheel; model: 5; offset: picker.firstYear; implicitWidth: 56 }
    }
}
