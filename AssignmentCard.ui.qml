import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: assignmentCard
    property string title: "Assignment"
    property string descriptions: "Descriptions"
    property string deadlineHours: "00"
    property string deadlineMinutes: "00"
    property string course: "Course"
    property string day: "Saturday"
    property alias doneBox: doneBox

    implicitHeight: row.implicitHeight + 2 * Constants.padding
    color: Constants.card
    radius: Constants.radius
    border.width: 1
    border.color: Constants.border

    // ── Entrance animation: fade-in + slide-up when delegate is created ──
    opacity: 0
    transform: Translate { id: cardSlide; y: 18 }
    Component.onCompleted: {
        cardEntrance.start()
    }
    ParallelAnimation {
        id: cardEntrance
        NumberAnimation { target: assignmentCard; property: "opacity"; to: 1.0; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: cardSlide; property: "y"; to: 0; duration: 300; easing.type: Easing.OutCubic }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: Constants.padding
        spacing: Constants.spacing

        CheckBox {
            id: doneBox
            Layout.alignment: Qt.AlignTop
            padding: 0

            indicator: Rectangle {
                implicitWidth: 24
                implicitHeight: 24
                radius: width / 2
                color: doneBox.checked ? Constants.primary : "transparent"
                border.width: 2
                border.color: doneBox.checked ? Constants.primary : Constants.mutedForeground

                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                // Scale-pop on toggle
                scale: 1.0
                Behavior on scale { SpringAnimation { spring: 6; damping: 0.4 } }

                Text {
                    font.family: Constants.fontFamily
                    anchors.centerIn: parent
                    text: ""
                    visible: doneBox.checked
                    color: Constants.primaryForeground
                    font.pixelSize: 14
                    font.bold: true
                    // Checkmark pops in with a spring
                    scale: doneBox.checked ? 1.0 : 0.0
                    opacity: doneBox.checked ? 1.0 : 0.0
                    Behavior on scale { SpringAnimation { spring: 8; damping: 0.35 } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
        }

        ColumnLayout {
            id: content
            Layout.fillWidth: true
            spacing: Constants.spacing / 2

            Text {
                font.family: Constants.fontFamily
                id: cardTitle
                Layout.fillWidth: true
                text: assignmentCard.title
                wrapMode: Text.WordWrap
                font.pixelSize: Constants.bodySize + 2
                font.weight: Font.DemiBold
                color: Constants.cardForeground
                opacity: doneBox.checked ? 0.45 : 1.0
                Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }
            }
            Text {
                font.family: Constants.fontFamily
                id: cardDescription
                Layout.fillWidth: true
                text: assignmentCard.descriptions
                wrapMode: Text.WordWrap
                font.pixelSize: Constants.bodySize - 2
                color: Constants.mutedForeground
                opacity: doneBox.checked ? 0.40 : 1.0
                Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Constants.spacing

                // ── 1. Deadline Liquid Glass Sticker ──
                Item {
                    implicitWidth: cardDeadline.implicitWidth + 2 * Constants.padding
                    implicitHeight: cardDeadline.implicitHeight + Constants.spacing + 4

                    // Translucent liquid gel base
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: Constants.secondary
                        opacity: Constants.isDark ? 0.50 : 0.65
                    }

                    // 3D cylindrical glass volume sheen
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        opacity: 0.80
                        gradient: Gradient {
                            GradientStop { position: 0.00; color: Constants.glassEdge }
                            GradientStop { position: 0.28; color: Constants.glassShine }
                            GradientStop { position: 0.55; color: "transparent" }
                            GradientStop { position: 1.00; color: Constants.glassShine }
                        }
                    }

                    // Concentric curved inner top/bottom reflection
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: height / 2
                        opacity: 0.55
                        gradient: Gradient {
                            GradientStop { position: 0.00; color: Constants.glassEdge }
                            GradientStop { position: 0.30; color: Constants.glassShine }
                            GradientStop { position: 0.55; color: "transparent" }
                            GradientStop { position: 0.82; color: "transparent" }
                            GradientStop { position: 1.00; color: Constants.glassShine }
                        }
                    }

                    // Outer specular glass rim
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: "transparent"
                        border.width: 1
                        border.color: Constants.glassEdge
                        opacity: 0.85
                    }

                    // Inner refractive ring
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1.2
                        radius: height / 2
                        color: "transparent"
                        border.width: 0.7
                        border.color: Constants.glassShine
                        opacity: 0.65
                    }

                    Text {
                        font.family: Constants.fontFamily
                        id: cardDeadline
                        anchors.centerIn: parent
                        text: qsTr("Due to ") + assignmentCard.deadlineHours + ":" + assignmentCard.deadlineMinutes + ", " + assignmentCard.day
                        color: Constants.foreground
                        font.pixelSize: Constants.bodySize - 4
                        font.weight: Font.Medium
                    }
                }

                // ── 2. Course Name Liquid Glass Sticker ──
                Item {
                    implicitWidth: cardCoursename.implicitWidth + 2 * Constants.padding
                    implicitHeight: cardCoursename.implicitHeight + Constants.spacing + 4

                    // Translucent liquid gel base
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: Constants.accent
                        opacity: Constants.isDark ? 0.55 : 0.70
                    }

                    // 3D cylindrical glass volume sheen
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        opacity: 0.80
                        gradient: Gradient {
                            GradientStop { position: 0.00; color: Constants.glassEdge }
                            GradientStop { position: 0.28; color: Constants.glassShine }
                            GradientStop { position: 0.55; color: "transparent" }
                            GradientStop { position: 1.00; color: Constants.glassShine }
                        }
                    }

                    // Concentric curved inner top/bottom reflection
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: height / 2
                        opacity: 0.55
                        gradient: Gradient {
                            GradientStop { position: 0.00; color: Constants.glassEdge }
                            GradientStop { position: 0.30; color: Constants.glassShine }
                            GradientStop { position: 0.55; color: "transparent" }
                            GradientStop { position: 0.82; color: "transparent" }
                            GradientStop { position: 1.00; color: Constants.glassShine }
                        }
                    }

                    // Outer specular glass rim
                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: "transparent"
                        border.width: 1
                        border.color: Constants.glassEdge
                        opacity: 0.85
                    }

                    // Inner refractive ring
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1.2
                        radius: height / 2
                        color: "transparent"
                        border.width: 0.7
                        border.color: Constants.glassShine
                        opacity: 0.65
                    }

                    Text {
                        font.family: Constants.fontFamily
                        id: cardCoursename
                        anchors.centerIn: parent
                        text: assignmentCard.course
                        color: Constants.foreground
                        font.pixelSize: Constants.bodySize - 4
                        font.weight: Font.DemiBold
                    }
                }

                Item { Layout.fillWidth: true }     // keeps the stickers on the left
            }
        }
    }
}
