import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    width: Constants.width
    height: Constants.height

    // Public aliases for Main.qml wiring
    property alias cancelButton: cancelButton
    property alias saveButton: saveButton

    // ── Drag Handle (Pinned at Top) ──
    Item {
        id: sheetHandle
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 100
        height: 28
        z: 10

        Rectangle {
            anchors.centerIn: parent
            width: 38
            height: 5
            radius: 2.5
            color: Constants.mutedForeground
            opacity: 0.35
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.cancelButton.clicked()
        }
    }

    // ── Scrollable Sheet Body ──
    Flickable {
        id: scrollArea
        anchors.top: sheetHandle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomActionBar.top
        anchors.topMargin: 4
        anchors.bottomMargin: 8
        contentWidth: width
        contentHeight: formContent.implicitHeight + 20
        clip: true
        interactive: contentHeight > height
        boundsBehavior: interactive ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds

        ColumnLayout {
            id: formContent
            width: parent.width - Constants.padding * 2
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            // ── Header Title ──
            Text {
                text: qsTr("New Assignment")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize + 4
                font.family: Constants.fontFamily
                font.weight: Font.Bold
                Layout.topMargin: 4
                Layout.bottomMargin: 2
            }

            // ── GROUP 1: Details & Notes (iOS Inset Grouped Card) ──
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: qsTr("TASK INFO")
                    color: Constants.mutedForeground
                    font.pixelSize: Constants.captionSize - 1
                    font.family: Constants.fontFamily
                    font.weight: Font.DemiBold
                    Layout.leftMargin: 6
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: detailsColumn.implicitHeight
                    radius: 16
                    color: Constants.card
                    opacity: 0.88
                    border.width: 1
                    border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08)

                    ColumnLayout {
                        id: detailsColumn
                        anchors.fill: parent
                        spacing: 0

                        // Title Field
                        TextField {
                            id: nameField
                            Layout.fillWidth: true
                            implicitHeight: 50
                            leftPadding: 16
                            rightPadding: 16
                            placeholderText: qsTr("Assignment Title")
                            color: Constants.foreground
                            placeholderTextColor: Constants.mutedForeground
                            font.pixelSize: Constants.bodySize
                            font.family: Constants.fontFamily
                            font.weight: Font.Medium
                            background: null
                        }

                        // Hairline Divider
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.leftMargin: 16
                            Layout.rightMargin: 16
                            implicitHeight: 1
                            color: Constants.border
                            opacity: 0.60
                        }

                        // Description / Notes Field
                        TextArea {
                            id: descriptionArea
                            Layout.fillWidth: true
                            implicitHeight: 80
                            leftPadding: 16
                            rightPadding: 16
                            topPadding: 12
                            bottomPadding: 12
                            placeholderText: qsTr("Notes or instructions...")
                            wrapMode: TextArea.Wrap
                            color: Constants.foreground
                            placeholderTextColor: Constants.mutedForeground
                            font.pixelSize: Constants.bodySize - 1
                            font.family: Constants.fontFamily
                            background: null
                        }
                    }
                }
            }

            // ── GROUP 2: Course / Subject Tag ──
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: qsTr("COURSE / SUBJECT")
                    color: Constants.mutedForeground
                    font.pixelSize: Constants.captionSize - 1
                    font.family: Constants.fontFamily
                    font.weight: Font.DemiBold
                    Layout.leftMargin: 6
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 52
                    radius: 16
                    color: Constants.card
                    opacity: 0.88
                    border.width: 1
                    border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08)

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 10

                        Text {
                            text: "\uD83D\uDCDA"  // Book emoji / icon
                            font.pixelSize: 16
                        }

                        TextField {
                            id: courseField
                            Layout.fillWidth: true
                            placeholderText: qsTr("e.g. Signals and Systems")
                            color: Constants.foreground
                            placeholderTextColor: Constants.mutedForeground
                            font.pixelSize: Constants.bodySize
                            font.family: Constants.fontFamily
                            background: null
                        }
                    }
                }
            }

            // ── GROUP 3: Deadline & Time ──
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: qsTr("DEADLINE & TIME")
                    color: Constants.mutedForeground
                    font.pixelSize: Constants.captionSize - 1
                    font.family: Constants.fontFamily
                    font.weight: Font.DemiBold
                    Layout.leftMargin: 6
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 14

                    GlassDatePicker { id: datePicker }
                    GlassTimePicker { id: timePicker }
                }
            }
        }
    }

    // ── Bottom Action Bar (Apple Docked Liquid Glass Bar) ──
    Rectangle {
        id: bottomActionBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 76
        color: Constants.background
        opacity: 0.95

        // Top hairline separator
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Constants.border
            opacity: 0.50
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Constants.padding
            anchors.rightMargin: Constants.padding
            spacing: 12

            GlassButton {
                id: cancelButton
                Layout.fillWidth: true
                text: qsTr("Cancel")
                primary: false
            }

            GlassButton {
                id: saveButton
                Layout.fillWidth: true
                text: qsTr("Save")
                primary: true
            }
        }
    }
}
