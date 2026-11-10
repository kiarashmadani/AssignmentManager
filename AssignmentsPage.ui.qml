import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    width: Constants.width
    height: Constants.height

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Constants.padding
            spacing: Constants.spacing

            Text {
                id: assignmentText
                Layout.fillWidth: true
                text: qsTr("Assignments")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize + 6
                font.bold: true
            }

            ListView {
                        id: assignmentList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: Constants.spacing
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
    }
}
