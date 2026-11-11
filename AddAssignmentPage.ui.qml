import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    width: Constants.width
    height: Constants.height

    // what Main.qml can reach from outside
    property alias cancelButton: cancelButton
    property alias saveButton: saveButton

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Constants.padding
        spacing: Constants.spacing

        Text {
            id: setAssignmentText
            Layout.fillWidth: true
            text: qsTr("New assignment")
            color: Constants.foreground
            font.pixelSize: Constants.titleSize
            font.family: Constants.fontFamily
            font.bold: true
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Constants.border
        }

        Text {
            id: assignmentNameText
            Layout.fillWidth: true
            text: qsTr("Assignment Name")
            color: Constants.foreground
            font.pixelSize: Constants.bodySize
            font.family: Constants.fontFamily
        }
        GlassTextField { id: nameField; Layout.fillWidth: true; placeholderText: qsTr("Page 31 and 32") }

        Text {
            id: courseNameText
            Layout.fillWidth: true
            text: qsTr("Course name")
            color: Constants.foreground
            font.pixelSize: Constants.bodySize
            font.family: Constants.fontFamily
        }
        GlassTextField { id: courseField; Layout.fillWidth: true; placeholderText: qsTr("Signals and Systems") }

        Text {
            Layout.fillWidth: true
            text: qsTr("Deadline")
            color: Constants.foreground
            font.pixelSize: Constants.bodySize
            font.family: Constants.fontFamily
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Constants.spacing
            GlassDatePicker { id: datePicker }
            GlassTimePicker { id: timePicker }
        }

        Text {
            id: descriptionText
            Layout.fillWidth: true
            text: qsTr("Description")
            color: Constants.foreground
            font.pixelSize: Constants.bodySize
            font.family: Constants.fontFamily
        }
        TextArea {
            id: descriptionArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            placeholderText: qsTr("What do you have to do?")
            wrapMode: TextArea.Wrap
            padding: Constants.padding
            color: Constants.foreground
            placeholderTextColor: Constants.mutedForeground
            selectionColor: Constants.primary
            selectedTextColor: Constants.primaryForeground
            font.pixelSize: Constants.bodySize
            font.family: Constants.fontFamily

            background: Rectangle {
                radius: Constants.radius
                color: Constants.card
                opacity: descriptionArea.activeFocus ? 0.85 : (Constants.isDark ? 0.45 : 0.6)
                border.width: descriptionArea.activeFocus ? 2 : 1
                border.color: descriptionArea.activeFocus ? Constants.ring : Constants.glassEdge
            }
        }

        RowLayout {
            id: rowLayout
            Layout.fillWidth: true
            spacing: Constants.spacing

            GlassButton { id: cancelButton; Layout.fillWidth: true; text: qsTr("Cancel") }
            GlassButton { id: saveButton; Layout.fillWidth: true; text: qsTr("Save"); primary: true }
        }
    }
}
