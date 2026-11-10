import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    width: Constants.width
    height: Constants.height

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
                spacing: Constants.spacing
                // Starts the first card below the floating title, while allowing cards to scroll up behind it
                topMargin: Constants.padding + assignmentText.implicitHeight + Constants.spacing
                bottomMargin: 90          // last card can scroll above the nav bar

                model: ListModel {
                    ListElement { title: "Signals and Systems"; descriptions: "Provide solutions for the problems shared in LMS" }
                    ListElement { title: "Linear Algebra"; descriptions: "Exercises 3.1 to 3.4, hand in as a single PDF" }
                    ListElement { title: "Operating Systems"; descriptions: "Project phase 2: implement a round-robin scheduler and write a short report about it" }
                    ListElement { title: "Physics 2"; descriptions: "Lab report on RC circuits" }
                    ListElement { title: "Probability"; descriptions: "Homework 5" }
                    ListElement { title: "Electronics 1"; descriptions: "Simulate the amplifier in LTspice" }
                    ListElement { title: "Signals and Systems"; descriptions: "Provide solutions for the problems shared in LMS" }
                    ListElement { title: "Linear Algebra"; descriptions: "Exercises 3.1 to 3.4, hand in as a single PDF" }
                    ListElement { title: "Operating Systems"; descriptions: "Project phase 2: implement a round-robin scheduler and write a short report about it" }
                    ListElement { title: "Physics 2"; descriptions: "Lab report on RC circuits" }
                    ListElement { title: "Probability"; descriptions: "Homework 5" }
                    ListElement { title: "Electronics 1"; descriptions: "Simulate the amplifier in LTspice" }
                }

                delegate: AssignmentCard {
                    required property var model     // this row of the ListModel
                    width: ListView.view.width
                    title: model.title
                    descriptions: model.descriptions
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
                // EDIT 1: Single continuous gradient from 100% blur at the top to 0% transparent at the bottom
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FFFFFFFF" }
                    GradientStop { position: 1.0; color: "#00FFFFFF" }
                }
            }

            // EDIT 2: Soft background gradient veil so high blurMax values (like 50) don't let
            // sharp unblurred cards bleed through at the very top edge behind the text
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

            // EDIT 3: Moved assignmentText INSIDE topBlurStrip after MultiEffect
            // so the text always sits directly on top of the blur strip
            Text {
                id: assignmentText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Constants.padding
                text: qsTr("Assignments")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize + 6
                font.bold: true
            }
        }
    }
}
