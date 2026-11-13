import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Item {
    id: assignmentCard
    property string title: "Assignment"
    property string descriptions: "Descriptions"
    property string deadlineHours: "00"
    property string deadlineMinutes: "00"
    property string course: "Course"
    property string day: "Saturday"
    property string priority: "Normal"
    property color courseColor: Constants.accent
    property bool isUrgent: false
    property alias doneBox: doneBox

    implicitHeight: row.implicitHeight + 28
    implicitWidth: 360

    // ── Entrance animation: smooth fade-in + fluid slide-up ──
    opacity: 0
    transform: Translate { id: cardSlide; y: 20 }
    Component.onCompleted: {
        cardEntrance.start()
    }
    ParallelAnimation {
        id: cardEntrance
        NumberAnimation { target: assignmentCard; property: "opacity"; to: 1.0; duration: 320; easing.type: Easing.OutCubic }
        NumberAnimation { target: cardSlide; property: "y"; to: 0; duration: 320; easing.type: Easing.OutCubic }
    }

    // ── Main Glass Card Surface ──
    Rectangle {
        id: cardSurface
        anchors.fill: parent
        radius: 18

        // Tactile liquid spring physics on hover and press
        scale: cardTap.pressed ? 0.982 : (cardHover.hovered ? 1.012 : 1.0)
        Behavior on scale {
            SpringAnimation { spring: 5.5; damping: 0.38; mass: 0.7 }
        }

        // Translucent Frosted Glass Substrate (Apple visionOS / iOS 18 style)
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Constants.isDark
                       ? Qt.rgba(1, 1, 1, cardTap.pressed ? 0.14 : (cardHover.hovered ? 0.12 : 0.08))
                       : Qt.rgba(1, 1, 1, cardTap.pressed ? 0.96 : (cardHover.hovered ? 0.92 : 0.85))
            }
            GradientStop {
                position: 1.0
                color: Constants.isDark
                       ? Qt.rgba(1, 1, 1, cardTap.pressed ? 0.08 : (cardHover.hovered ? 0.06 : 0.04))
                       : Qt.rgba(1, 1, 1, cardTap.pressed ? 0.88 : (cardHover.hovered ? 0.84 : 0.75))
            }
        }

        // Tint underlay with theme card tone
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Constants.card
            opacity: Constants.isDark ? 0.50 : 0.30
        }

        // Clean hairline perimeter border
        border.width: 1
        border.color: cardHover.hovered
            ? Qt.rgba(1, 1, 1, 0.22)
            : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))

        HoverHandler { id: cardHover }
        TapHandler { id: cardTap }

        // ── Card Content ──
        RowLayout {
            id: row
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            anchors.topMargin: 14
            anchors.bottomMargin: 14
            spacing: 14

            // ── Apple Reminders-Style Circular Checkbox ──
            CheckBox {
                id: doneBox
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 2
                padding: 0

                indicator: Item {
                    implicitWidth: 26
                    implicitHeight: 26

                    // Glowing halo when checked
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: width / 2
                        color: Constants.primary
                        opacity: doneBox.checked ? 0.35 : 0.0
                        scale: doneBox.checked ? 1.15 : 0.8
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        Behavior on scale { SpringAnimation { spring: 6; damping: 0.4 } }
                    }

                    // Circular ring / fill body
                    Rectangle {
                        id: checkCircle
                        anchors.fill: parent
                        radius: width / 2
                        color: doneBox.checked ? Constants.primary : "transparent"
                        border.width: doneBox.checked ? 0 : 1.8
                        border.color: doneBox.checked ? Constants.primary : Constants.mutedForeground

                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        // Tactile spring scale bounce on toggle
                        scale: doneBox.down ? 0.85 : 1.0
                        Behavior on scale { SpringAnimation { spring: 7; damping: 0.35 } }

                        // Crisp vector checkmark symbol
                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -0.5
                            text: "\u2713"
                            color: Constants.primaryForeground
                            font.pixelSize: 15
                            font.bold: true
                            scale: doneBox.checked ? 1.0 : 0.0
                            opacity: doneBox.checked ? 1.0 : 0.0
                            Behavior on scale { SpringAnimation { spring: 7.5; damping: 0.35 } }
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }
                }
            }

            // ── Task Details ──
            ColumnLayout {
                id: content
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        id: cardTitle
                        Layout.fillWidth: true
                        text: assignmentCard.title
                        wrapMode: Text.WordWrap
                        font.family: Constants.fontFamily
                        font.pixelSize: Constants.bodySize + 1
                        font.weight: Font.DemiBold
                        color: Constants.cardForeground
                        opacity: doneBox.checked ? 0.40 : 1.0
                        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }
                    }

                    // Priority micro badge if High or Medium
                    Rectangle {
                        visible: assignmentCard.priority === "High" || assignmentCard.priority === "Urgent"
                        implicitWidth: priorityText.implicitWidth + 12
                        implicitHeight: 20
                        radius: 10
                        color: Qt.rgba(1, 0.25, 0.35, 0.18)
                        border.width: 1
                        border.color: Qt.rgba(1, 0.25, 0.35, 0.35)

                        Text {
                            id: priorityText
                            anchors.centerIn: parent
                            text: "\uD83D\uDD25 High"
                            font.pixelSize: 10
                            font.bold: true
                            color: Constants.destructive
                        }
                    }
                }

                Text {
                    id: cardDescription
                    Layout.fillWidth: true
                    text: assignmentCard.descriptions
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    font.family: Constants.fontFamily
                    font.pixelSize: Constants.captionSize + 1
                    lineHeight: 1.18
                    color: Constants.mutedForeground
                    opacity: doneBox.checked ? 0.35 : 0.88
                    Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }
                }

                // ── Apple-Style Translucent Capsule Badges ──
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    spacing: 8

                    // 1. Deadline Capsule Chip
                    Rectangle {
                        implicitWidth: deadlineRow.implicitWidth + 20
                        implicitHeight: 26
                        radius: 13
                        color: assignmentCard.isUrgent
                            ? Qt.rgba(1, 0.3, 0.2, 0.14)
                            : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04))
                        border.width: 1
                        border.color: assignmentCard.isUrgent
                            ? Qt.rgba(1, 0.3, 0.2, 0.32)
                            : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06))

                        RowLayout {
                            id: deadlineRow
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: assignmentCard.isUrgent ? "\u26A0\uFE0F" : "\u23F1"
                                font.pixelSize: 11
                                color: assignmentCard.isUrgent ? Constants.destructive : Constants.primary
                            }

                            Text {
                                font.family: Constants.fontFamily
                                text: qsTr("Due ") + assignmentCard.day + " " + assignmentCard.deadlineHours + ":" + assignmentCard.deadlineMinutes
                                color: assignmentCard.isUrgent ? Constants.destructive : Constants.foreground
                                font.pixelSize: Constants.captionSize - 1
                                font.weight: Font.Medium
                            }
                        }
                    }

                    // 2. Course Capsule Chip with Apple Calendar-style Category Dot
                    Rectangle {
                        implicitWidth: courseRow.implicitWidth + 20
                        implicitHeight: 26
                        radius: 13
                        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)
                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06)

                        RowLayout {
                            id: courseRow
                            anchors.centerIn: parent
                            spacing: 6

                            // Category Indicator Dot
                            Rectangle {
                                width: 7
                                height: 7
                                radius: 3.5
                                color: assignmentCard.courseColor
                            }

                            Text {
                                font.family: Constants.fontFamily
                                text: assignmentCard.course
                                color: Constants.foreground
                                font.pixelSize: Constants.captionSize - 1
                                font.weight: Font.DemiBold
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }
}
