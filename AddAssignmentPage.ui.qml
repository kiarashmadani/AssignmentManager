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

    property alias titleText: nameField.text
    property alias descriptionText: descriptionArea.text
    property alias courseText: courseField.text
    property alias datePicker: datePicker
    property alias timePicker: timePicker

    property bool titleError: false
    property bool courseError: false
    property bool isUrgent: false

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

        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: root.cancelButton.clicked()
        // }
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
                    border.width: root.titleError ? 1.5 : 1
                    border.color: root.titleError
                                  ? Constants.destructive
                                  : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08))
                    Behavior on border.color { ColorAnimation { duration: 180 } }

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
                    border.width: root.courseError ? 1.5 : 1
                    border.color: root.courseError
                                  ? Constants.destructive
                                  : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08))
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 10

                        Image {
                            source: "icons/book.svg"
                            sourceSize.width: 16
                            sourceSize.height: 16
                            fillMode: Image.PreserveAspectFit
                            Layout.alignment: Qt.AlignVCenter
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
                    Layout.fillWidth: true
                    spacing: 12

                    GlassDatePicker {
                        id: datePicker
                        Layout.fillWidth: true
                        Layout.preferredWidth: 58
                    }
                    GlassTimePicker {
                        id: timePicker
                        Layout.fillWidth: true
                        Layout.preferredWidth: 42
                    }
                }
            }

            // ── GROUP 4: Priority & Urgency ──
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: qsTr("PRIORITY & URGENCY")
                    color: Constants.mutedForeground
                    font.pixelSize: Constants.captionSize - 1
                    font.family: Constants.fontFamily
                    font.weight: Font.DemiBold
                    Layout.leftMargin: 6
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 56
                    radius: 16
                    color: Constants.card
                    opacity: 0.88
                    border.width: root.isUrgent ? 1.5 : 1
                    border.color: root.isUrgent
                                  ? Constants.urgent
                                  : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08))
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12

                        Image {
                            source: "icons/flame.svg"
                            sourceSize.width: 18
                            sourceSize.height: 18
                            fillMode: Image.PreserveAspectFit
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                text: qsTr("Mark as Urgent")
                                color: root.isUrgent ? Constants.urgent : Constants.foreground
                                font.pixelSize: Constants.bodySize
                                font.family: Constants.fontFamily
                                font.weight: Font.Medium
                            }

                            Text {
                                text: qsTr("Highlights card and adds warning badge")
                                color: Constants.mutedForeground
                                font.pixelSize: Constants.captionSize - 1
                                font.family: Constants.fontFamily
                            }
                        }

                        // iOS-style liquid toggle switch
                        Rectangle {
                            implicitWidth: 48
                            implicitHeight: 28
                            radius: 14
                            color: root.isUrgent
                                   ? Constants.urgent
                                   : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, 0.14))
                            Behavior on color { ColorAnimation { duration: 200 } }

                            Rectangle {
                                x: root.isUrgent ? parent.width - width - 3 : 3
                                anchors.verticalCenter: parent.verticalCenter
                                width: 22
                                height: 22
                                radius: 11
                                color: "#FFFFFF"
                                Behavior on x {
                                    SpringAnimation { spring: 5.0; damping: 0.40 }
                                }
                            }
                        }
                    }

                    TapHandler {
                        onTapped: root.isUrgent = !root.isUrgent
                    }
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

        Item {
            Layout.fillHeight: true
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
