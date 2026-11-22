import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property int activeFilter: 0 // 0: All, 1: Today, 2: Pending, 3: Done
    property alias assignmentList: assignmentList

    // ── Live Model Properties ───────────────────────────
    readonly property var mgr: assignmentList.model
    readonly property int totalCount: mgr ? mgr.totalCount : 0
    readonly property int totalCompleted: mgr ? mgr.totalCompleted : 0
    readonly property int dueCompleteToday: mgr ? mgr.dueCompleteToday : 0
    readonly property int overdueCount: mgr ? mgr.overdueCount : 0
    readonly property int urgentCount: mgr ? mgr.urgentCount : 0
    readonly property int urgentPendingCount: mgr ? mgr.urgentPendingCount : 0
    readonly property int completionPercentage: mgr ? mgr.completionPercentage : 0
    readonly property real completionRatio: mgr ? mgr.completionRatio : 0.0
    readonly property real overdueRatio: mgr ? mgr.overdueRatio : 0.0
    readonly property real urgentPendingRatio: mgr ? mgr.urgentPendingRatio : 0.0

    Rectangle {
        id: page
        anchors.fill: parent
        color: "transparent"

        // 1. Content layer that extends all the way to the top of the screen
        Rectangle {
            id: contentArea
            anchors.fill: parent
            color: "transparent"

            ListView {
                id: assignmentList
                anchors.fill: parent
                anchors.leftMargin: Constants.padding
                anchors.rightMargin: Constants.padding
                clip: true
                spacing: 0
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
                        implicitHeight: heroContent.implicitHeight + 32
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
                                Layout.alignment: Qt.AlignVCenter
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

                                // 1. Active progress arc (Apple Activity Ring style)
                                Shape {
                                    anchors.fill: parent
                                    layer.enabled: true
                                    layer.samples: 4
                                    visible: root.completionRatio > 0.001

                                    ShapePath {
                                        strokeWidth: 6
                                        strokeColor: Constants.primary
                                        capStyle: ShapePath.RoundCap
                                        fillColor: "transparent"

                                        PathAngleArc {
                                            centerX: 32
                                            centerY: 32
                                            radiusX: 29
                                            radiusY: 29
                                            startAngle: -90
                                            sweepAngle: Math.max(0, root.completionRatio * 360 - (root.overdueRatio > 0.001 || root.urgentPendingRatio > 0.001 ? 6 : 0))

                                            Behavior on sweepAngle {
                                                SpringAnimation {
                                                    spring: 3.5
                                                    damping: 0.38
                                                }
                                            }
                                        }
                                    }
                                }

                                // 2. Urgent pending warning arc (sweeps clockwise after Completed)
                                Shape {
                                    anchors.fill: parent
                                    layer.enabled: true
                                    layer.samples: 4
                                    visible: root.urgentPendingRatio > 0.001

                                    ShapePath {
                                        strokeWidth: 6
                                        strokeColor: Constants.urgent
                                        capStyle: ShapePath.RoundCap
                                        fillColor: "transparent"

                                        PathAngleArc {
                                            centerX: 32
                                            centerY: 32
                                            radiusX: 29
                                            radiusY: 29
                                            startAngle: -90 + (root.completionRatio * 360)
                                            sweepAngle: Math.max(0, root.urgentPendingRatio * 360 - (root.overdueRatio > 0.001 ? 6 : 0))

                                            Behavior on sweepAngle {
                                                SpringAnimation {
                                                    spring: 3.5
                                                    damping: 0.38
                                                }
                                            }
                                        }
                                    }
                                }

                                // 3. Overdue warning arc in blazing siren red (sweeps counter-clockwise from 12 o'clock)
                                Shape {
                                    anchors.fill: parent
                                    layer.enabled: true
                                    layer.samples: 4
                                    visible: root.overdueRatio > 0.001

                                    ShapePath {
                                        strokeWidth: 6
                                        strokeColor: Constants.overdue
                                        capStyle: ShapePath.RoundCap
                                        fillColor: "transparent"

                                        PathAngleArc {
                                            centerX: 32
                                            centerY: 32
                                            radiusX: 29
                                            radiusY: 29
                                            startAngle: -90
                                            sweepAngle: -Math.max(0, root.overdueRatio * 360 - (root.completionRatio > 0.001 ? 6 : 0))

                                            Behavior on sweepAngle {
                                                SpringAnimation {
                                                    spring: 3.5
                                                    damping: 0.38
                                                }
                                            }
                                        }
                                    }
                                }

                                // Centered percentage text
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 0
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: root.completionPercentage + "%"
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
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 4

                                Text {
                                    text: qsTr("Weekly Momentum")
                                    color: Constants.mutedForeground
                                    font.pixelSize: Constants.captionSize
                                    font.weight: Font.DemiBold
                                    font.family: Constants.fontFamily
                                }

                                Text {
                                    text: root.totalCount > 0
                                        ? qsTr("%1 of %2 Completed").arg(root.totalCompleted).arg(root.totalCount)
                                        : qsTr("No Assignments Yet")
                                    color: Constants.foreground
                                    font.pixelSize: Constants.titleSize - 4
                                    font.bold: true
                                    font.family: Constants.fontFamily
                                }

                                // Dynamic rolling ticker sticker (cycles Overdue, Urgent, Pending, Due Today)
                                DynamicMetricBadge {
                                    id: dynamicBadge
                                    Layout.topMargin: 4
                                    overdueCount: root.overdueCount
                                    urgentCount: root.urgentCount
                                    pendingCount: Math.max(0, root.totalCount - root.totalCompleted)
                                    dueTodayCount: root.dueCompleteToday
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
                    id: cardItem
                    required property var model
                    required property int index

                    width: ListView.view.width
                    title: model.title
                    descriptions: model.descriptions
                    course: model.course
                    day: model.day
                    deadlineHours: model.deadlineHours
                    deadlineMinutes: model.deadlineMinutes
                    priority: model.priority || "Normal"
                    courseColor: model.courseColor || Constants.accent
                    isUrgent: Boolean(model.isUrgent)
                    isCompleted: Boolean(model.isCompleted)
                    isOverdue: Boolean(model.isOverdue)

                    readonly property bool matchesFilter: {
                        if (root.activeFilter === 1) return model.day === "Today" || model.day === qsTr("Today")
                        if (root.activeFilter === 2) return !model.isCompleted
                        if (root.activeFilter === 3) return Boolean(model.isCompleted)
                        return true
                    }

                    visible: matchesFilter
                    height: matchesFilter ? implicitHeight : 0

                    onToggleRequested: {
                        if (assignmentList.model && typeof assignmentList.model.toggleCompleted === "function") {
                            assignmentList.model.toggleCompleted(index)
                        }
                    }

                    onDeleteRequested: {
                        if (assignmentList.model && typeof assignmentList.model.deleteAssignment === "function") {
                            assignmentList.model.deleteAssignment(index)
                        }
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
                textureSize: Qt.size(Math.max(1, width * 0.5), Math.max(1, height * 0.5))
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
