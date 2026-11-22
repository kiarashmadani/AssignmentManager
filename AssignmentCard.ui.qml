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
    property bool isCompleted: false
    property bool isOverdue: false
    readonly property bool isWarningOverdue: isOverdue && !isCompleted
    readonly property bool isWarningUrgent: isUrgent && !isCompleted && !isOverdue
    readonly property bool showWarning: isWarningOverdue || isWarningUrgent
    signal toggleRequested()
    signal deleteRequested()
    property alias doneBox: doneBox
    property alias deleteButton: deleteBtn

    implicitHeight: row.implicitHeight + 28 + 14
    implicitWidth: 360
    z: (cardHover.hovered || cardTap.pressed) ? 5 : 1

    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

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
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        anchors.topMargin: 3
        anchors.bottomMargin: 11
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

        // Subtle warning glaze: Red for Overdue, Flame Orange for Urgent
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: assignmentCard.isWarningOverdue
                   ? Constants.destructive
                   : (assignmentCard.isWarningUrgent ? Constants.urgent : "transparent")
            opacity: assignmentCard.showWarning ? (Constants.isDark ? 0.12 : 0.06) : 0.0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Clean hairline perimeter border (glows Red when overdue, Flame Orange when urgent)
        border.width: assignmentCard.showWarning ? 1.5 : 1
        border.color: assignmentCard.isWarningOverdue
            ? Constants.destructive
            : (assignmentCard.isWarningUrgent
               ? Constants.urgent
               : (cardHover.hovered ? Qt.rgba(1, 1, 1, 0.22) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))))
        Behavior on border.color { ColorAnimation { duration: 180 } }

        HoverHandler { id: cardHover }
        TapHandler { id: cardTap }

        // ── Card Content ──
        RowLayout {
            id: row
            anchors.fill: cardSurface
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
                checked: assignmentCard.isCompleted
                onClicked: assignmentCard.toggleRequested()

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

                    // Urgent priority sticker badge (Flame Orange)
                    Rectangle {
                        visible: assignmentCard.isUrgent && !assignmentCard.isCompleted
                        implicitWidth: priorityText.implicitWidth + 14
                        implicitHeight: 22
                        radius: 11
                        color: Qt.rgba(1, 0.55, 0.14, 0.18)
                        border.width: 1
                        border.color: Qt.rgba(1, 0.55, 0.14, 0.45)

                        Text {
                            id: priorityText
                            anchors.centerIn: parent
                            text: "\uD83D\uDD25 " + qsTr("Urgent")
                            font.pixelSize: 11
                            font.bold: true
                            color: Constants.urgent
                            font.family: Constants.fontFamily
                        }
                    }

                    // Delete Button
                    Item {
                        id: deleteBtn
                        implicitWidth: 24
                        implicitHeight: 24
                        Layout.alignment: Qt.AlignVCenter

                        scale: deleteTap.pressed ? 0.88 : (deleteHover.hovered ? 1.12 : 1.0)
                        Behavior on scale { SpringAnimation { spring: 6; damping: 0.35 } }

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: deleteHover.hovered
                                   ? Qt.rgba(1, 0.12, 0.22, 0.22)
                                   : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(0, 0, 0, 0.04))
                            border.width: 1
                            border.color: deleteHover.hovered
                                          ? Constants.overdue
                                          : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06))
                            Behavior on color { ColorAnimation { duration: 150 } }
                            Behavior on border.color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: "\u2715"
                                font.pixelSize: 11
                                font.bold: true
                                color: deleteHover.hovered ? Constants.overdue : Constants.mutedForeground
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }

                        HoverHandler { id: deleteHover; cursorShape: Qt.PointingHandCursor }
                        TapHandler {
                            id: deleteTap
                            onTapped: assignmentCard.deleteRequested()
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
                Flow {
                    id: badgesFlow
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    spacing: 6
                    Layout.preferredHeight: childrenRect.height

                    // 1. Deadline Capsule Chip
                    Rectangle {
                        implicitWidth: Math.min(deadlineRow.implicitWidth + 20, (badgesFlow.width > 0 ? badgesFlow.width : 280))
                        implicitHeight: 26
                        radius: 13
                        color: assignmentCard.isWarningOverdue
                            ? Qt.rgba(1, 0.22, 0.28, 0.18)
                            : (assignmentCard.isWarningUrgent
                               ? Qt.rgba(1, 0.55, 0.14, 0.18)
                               : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)))
                        border.width: 1
                        border.color: assignmentCard.isWarningOverdue
                            ? Qt.rgba(1, 0.22, 0.28, 0.45)
                            : (assignmentCard.isWarningUrgent
                               ? Qt.rgba(1, 0.55, 0.14, 0.45)
                               : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06)))

                        RowLayout {
                            id: deadlineRow
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 5

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: assignmentCard.isOverdue ? "\u26A0\uFE0F" : (assignmentCard.isUrgent ? "\uD83D\uDD25" : "\u23F1")
                                font.pixelSize: 11
                                color: assignmentCard.isWarningOverdue
                                       ? Constants.destructive
                                       : (assignmentCard.isWarningUrgent ? Constants.urgent : Constants.primary)
                            }

                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                font.family: Constants.fontFamily
                                text: (assignmentCard.isOverdue ? qsTr("Overdue ") : qsTr("Due ")) + assignmentCard.day + " " + assignmentCard.deadlineHours + ":" + assignmentCard.deadlineMinutes
                                color: assignmentCard.isWarningOverdue
                                       ? Constants.destructive
                                       : (assignmentCard.isWarningUrgent ? Constants.urgent : Constants.foreground)
                                font.pixelSize: Constants.captionSize - 1
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                            }
                        }
                    }

                    // 2. Course Capsule Chip with Apple Calendar-style Category Dot
                    Rectangle {
                        implicitWidth: Math.min(courseRow.implicitWidth + 20, (badgesFlow.width > 0 ? badgesFlow.width : 280))
                        implicitHeight: 26
                        radius: 13
                        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)
                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.06)

                        RowLayout {
                            id: courseRow
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 6

                            // Category Indicator Dot
                            Rectangle {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: 7
                                radius: 3.5
                                color: assignmentCard.courseColor
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                id: courseTitleText
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                font.family: Constants.fontFamily
                                text: assignmentCard.course
                                color: Constants.foreground
                                font.pixelSize: Constants.captionSize - 1
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
