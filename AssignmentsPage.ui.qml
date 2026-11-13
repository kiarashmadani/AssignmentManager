import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property int activeFilter: 0 // 0: All, 1: Today, 2: Pending, 3: Done

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        // 1. Content layer that extends all the way to the top of the screen
        Rectangle {
            id: contentArea
            anchors.fill: parent
            color: Constants.background

            ListView {
                id: assignmentList
                anchors.fill: parent
                anchors.leftMargin: Constants.padding
                anchors.rightMargin: Constants.padding
                clip: true
                spacing: 12
                topMargin: topBlurStrip.height + 8
                bottomMargin: 96 // Ensures cards scroll comfortably above the floating NavBar

                // Smooth momentum scrolling
                flickDeceleration: 1800
                maximumFlickVelocity: 3500
                boundsBehavior: Flickable.DragAndOvershootBounds
                boundsMovement: Flickable.FollowBoundsBehavior

                // ── Header: Apple Liquid Glass Hero Activity & Filter Bar ──
                header: ColumnLayout {
                    width: assignmentList.width
                    spacing: 14

                    // ── Hero Liquid Glass Progress Widget ──
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: heroContent.implicitHeight + 28
                        radius: 20

                        // Translucent frosted gradient base
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(1, 1, 1, 0.92)
                            }
                            GradientStop {
                                position: 1.0
                                color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(1, 1, 1, 0.80)
                            }
                        }

                        // Theme underlay
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: Constants.card
                            opacity: Constants.isDark ? 0.45 : 0.25
                        }

                        // Hairline border
                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.08)

                        RowLayout {
                            id: heroContent
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16

                            // Circular Progress Ring Graphic
                            Item {
                                implicitWidth: 64
                                implicitHeight: 64

                                // Background track circle
                                Rectangle {
                                    anchors.fill: parent
                                    radius: width / 2
                                    color: "transparent"
                                    border.width: 6
                                    border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.06)
                                }

                                // Active progress indicator
                                Rectangle {
                                    anchors.fill: parent
                                    radius: width / 2
                                    color: "transparent"
                                    border.width: 6
                                    border.color: Constants.primary
                                    opacity: 0.85
                                }

                                // Centered percentage text
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 0
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "60%"
                                        color: Constants.foreground
                                        font.pixelSize: 13
                                        font.bold: true
                                        font.family: Constants.fontFamily
                                    }
                                }
                            }

                            // Motivation & Stats Column
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: qsTr("Weekly Momentum")
                                    color: Constants.mutedForeground
                                    font.pixelSize: Constants.captionSize
                                    font.weight: Font.DemiBold
                                    font.family: Constants.fontFamily
                                }

                                Text {
                                    text: qsTr("3 of 5 Completed")
                                    color: Constants.foreground
                                    font.pixelSize: Constants.titleSize - 4
                                    font.bold: true
                                    font.family: Constants.fontFamily
                                }

                                // Mini Metric Badges Row
                                RowLayout {
                                    spacing: 8
                                    Layout.topMargin: 4

                                    // Streak badge
                                    Rectangle {
                                        implicitWidth: streakText.implicitWidth + 14
                                        implicitHeight: 22
                                        radius: 11
                                        color: Qt.rgba(1, 0.5, 0.2, 0.14)
                                        border.width: 1
                                        border.color: Qt.rgba(1, 0.5, 0.2, 0.30)
                                        Text {
                                            id: streakText
                                            anchors.centerIn: parent
                                            text: "\uD83D\uDD25 5-Day Streak"
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: Constants.isDark ? "#FFA066" : "#D45010"
                                            font.family: Constants.fontFamily
                                        }
                                    }

                                    // Due Today badge
                                    Rectangle {
                                        implicitWidth: dueTodayText.implicitWidth + 14
                                        implicitHeight: 22
                                        radius: 11
                                        color: Qt.rgba(0.2, 0.6, 1, 0.14)
                                        border.width: 1
                                        border.color: Qt.rgba(0.2, 0.6, 1, 0.30)
                                        Text {
                                            id: dueTodayText
                                            anchors.centerIn: parent
                                            text: "\u23F3 2 Due Today"
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: Constants.isDark ? "#70B8FF" : "#1A70D0"
                                            font.family: Constants.fontFamily
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ── Segmented Liquid Glass Filter Bar ──
                    Rectangle {
                        id: filterBar
                        Layout.fillWidth: true
                        implicitHeight: 44
                        radius: 22
                        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(0, 0, 0, 0.04)
                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.06)

                        // Sliding Droplet Indicator
                        Rectangle {
                            id: filterDroplet
                            width: (filterBar.width - 8) / 4
                            height: parent.height - 8
                            y: 4
                            x: 4 + root.activeFilter * width
                            radius: 18
                            color: Constants.primary
                            opacity: 0.88
                            Behavior on x {
                                SpringAnimation { spring: 5.5; damping: 0.40 }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 0

                            Repeater {
                                model: [qsTr("All"), qsTr("Today"), qsTr("Pending"), qsTr("Done")]

                                Item {
                                    required property int index
                                    required property string modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text {
                                        anchors.centerIn: parent
                                        text: parent.modelData
                                        color: root.activeFilter === parent.index
                                            ? Constants.primaryForeground
                                            : Constants.mutedForeground
                                        font.pixelSize: 13
                                        font.weight: root.activeFilter === parent.index ? Font.Bold : Font.Medium
                                        font.family: Constants.fontFamily
                                        Behavior on color { ColorAnimation { duration: 150 } }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: root.activeFilter = parent.index
                                    }
                                }
                            }
                        }
                    }

                    Item { implicitHeight: 4 }
                }

                // ── Animated Card Insert/Remove Transitions ──
                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 250; easing.type: Easing.OutCubic }
                }
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 280; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "scale"; from: 0.92; to: 1.0; duration: 280; easing.type: Easing.OutCubic }
                }
                remove: Transition {
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220; easing.type: Easing.InCubic }
                }

                // ── Rich Academic Sample Model ──
                model: ListModel {
                    ListElement {
                        title: "Signals and Systems"
                        descriptions: "Provide complete solutions for Problem Set 4 on Fourier transforms shared in LMS"
                        course: "Electrical Eng"
                        day: "Today"
                        deadlineHours: "18"
                        deadlineMinutes: "00"
                        priority: "High"
                        courseColor: "#7655D9"
                        isUrgent: true
                    }
                    ListElement {
                        title: "Linear Algebra"
                        descriptions: "Exercises 3.1 to 3.4 on Eigenvalues and diagonalization, hand in as a single PDF"
                        course: "Mathematics"
                        day: "Tomorrow"
                        deadlineHours: "23"
                        deadlineMinutes: "59"
                        priority: "Normal"
                        courseColor: "#00BFA5"
                        isUrgent: false
                    }
                    ListElement {
                        title: "Operating Systems"
                        descriptions: "Project phase 2: implement a round-robin scheduler and write a short benchmark report"
                        course: "Computer Science"
                        day: "Friday"
                        deadlineHours: "14"
                        deadlineMinutes: "00"
                        priority: "High"
                        courseColor: "#FF806B"
                        isUrgent: false
                    }
                    ListElement {
                        title: "Electronics 1"
                        descriptions: "Simulate the BJT common-emitter amplifier stage in LTspice and export waveforms"
                        course: "Circuits"
                        day: "Today"
                        deadlineHours: "21"
                        deadlineMinutes: "30"
                        priority: "High"
                        courseColor: "#F05270"
                        isUrgent: true
                    }
                    ListElement {
                        title: "Physics 2"
                        descriptions: "Submit the laboratory report on RC and RLC resonance circuits with measured scope data"
                        course: "Physics"
                        day: "Thursday"
                        deadlineHours: "12"
                        deadlineMinutes: "00"
                        priority: "Normal"
                        courseColor: "#35F5D0"
                        isUrgent: false
                    }
                    ListElement {
                        title: "Probability & Statistics"
                        descriptions: "Homework 5: Markov chains and stationary distribution derivations"
                        course: "Mathematics"
                        day: "Monday"
                        deadlineHours: "10"
                        deadlineMinutes: "00"
                        priority: "Normal"
                        courseColor: "#00BFA5"
                        isUrgent: false
                    }
                }

                delegate: AssignmentCard {
                    required property var model
                    width: ListView.view.width
                    title: model.title
                    descriptions: model.descriptions
                    course: model.course
                    day: model.day
                    deadlineHours: model.deadlineHours
                    deadlineMinutes: model.deadlineMinutes
                    priority: model.priority
                    courseColor: model.courseColor
                    isUrgent: model.isUrgent

                    // Dynamic Filter visibility
                    visible: {
                        if (root.activeFilter === 1) return model.day === "Today"
                        if (root.activeFilter === 2) return !doneBox.checked
                        if (root.activeFilter === 3) return doneBox.checked
                        return true
                    }
                }
            }
        }

        // 2. Top progressive blur strip with the Assignments title placed directly ON it
        Item {
            id: topBlurStrip
            z: 10
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: assignmentText.implicitHeight + Constants.padding * 2.5

            ShaderEffectSource {
                id: topStripSource
                anchors.fill: parent
                sourceItem: contentArea
                sourceRect: Qt.rect(0, 0, topBlurStrip.width, topBlurStrip.height)
                live: true
                visible: false
            }

            Rectangle {
                id: topStripMask
                anchors.fill: parent
                layer.enabled: true
                visible: false
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FFFFFFFF" }
                    GradientStop { position: 1.0; color: "#00FFFFFF" }
                }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Constants.background }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
                opacity: 0.55
            }

            MultiEffect {
                anchors.fill: parent
                source: topStripSource
                autoPaddingEnabled: false
                blurEnabled: true
                blur: 0.7
                blurMax: 50
                saturation: 0.15
                maskEnabled: true
                maskSource: topStripMask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }

            Text {
                font.family: Constants.fontFamily
                id: assignmentText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Constants.padding
                text: qsTr("Assignments")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize + 16
                font.bold: true
            }
        }
    }
}
