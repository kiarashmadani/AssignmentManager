import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    width: Constants.width
    height: Constants.height
    property alias themeGroup: themeGroup
    property alias languageGroup: languageGroup

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        Rectangle {
            id: contentArea
            anchors.fill: parent
            color: Constants.background

            Flickable {
                anchors.fill: parent
                anchors.leftMargin: Constants.padding
                anchors.rightMargin: Constants.padding
                topMargin: topBlurStrip.height + 8
                bottomMargin: 96
                contentWidth: width
                contentHeight: settingsLayout.implicitHeight + 20
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds

                ColumnLayout {
                    id: settingsLayout
                    width: parent.width
                    spacing: 18

                    // ── Scholar Profile Liquid Glass Card ──
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: profileRow.implicitHeight + 28
                        radius: 20

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

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: Constants.card
                            opacity: Constants.isDark ? 0.45 : 0.25
                        }

                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.08)

                        RowLayout {
                            id: profileRow
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 14

                            // Student Avatar Orb
                            Rectangle {
                                width: 54
                                height: 54
                                radius: 27
                                color: Constants.primary
                                opacity: 0.88

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uD83C\uDF93" // Graduation cap
                                    font.pixelSize: 24
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    text: qsTr("Academic Scholar")
                                    color: Constants.foreground
                                    font.pixelSize: Constants.titleSize - 4
                                    font.bold: true
                                    font.family: Constants.fontFamily
                                }

                                Text {
                                    text: qsTr("Assignment Manager Pro • Level 4")
                                    color: Constants.mutedForeground
                                    font.pixelSize: Constants.captionSize
                                    font.family: Constants.fontFamily
                                }
                            }
                        }
                    }

                    // ── SECTION 1: Appearance & Themes ──
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            font.family: Constants.fontFamily
                            text: qsTr("APPEARANCE & THEMES")
                            color: Constants.mutedForeground
                            font.pixelSize: Constants.captionSize - 1
                            font.weight: Font.DemiBold
                            Layout.leftMargin: 6
                        }

                        ButtonGroup { id: themeGroup }

                        GridLayout {
                            columns: 3
                            rowSpacing: Constants.spacing
                            columnSpacing: Constants.spacing
                            Layout.fillWidth: true

                            ThemeButton { themeIndex: 0; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 1; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 2; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 3; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 4; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 5; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                            ThemeButton { themeIndex: 6; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                        }
                    }

                    // ── SECTION 2: Language & Region ──
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            font.family: Constants.fontFamily
                            text: qsTr("LANGUAGE & REGION")
                            color: Constants.mutedForeground
                            font.pixelSize: Constants.captionSize - 1
                            font.weight: Font.DemiBold
                            Layout.leftMargin: 6
                        }

                        ButtonGroup { id: languageGroup }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Constants.spacing
                            LanguageButton { languageIndex: 0; Layout.fillWidth: true; ButtonGroup.group: languageGroup }
                            LanguageButton { languageIndex: 1; Layout.fillWidth: true; ButtonGroup.group: languageGroup }
                        }
                    }

                    // ── SECTION 3: App Info & Version ──
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        radius: 14
                        color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.03)
                        border.width: 1
                        border.color: Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.05)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            Text {
                                text: qsTr("Assignment Manager Liquid Glass Edition")
                                color: Constants.mutedForeground
                                font.pixelSize: Constants.captionSize - 1
                                font.family: Constants.fontFamily
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "v2.0"
                                color: Constants.primary
                                font.pixelSize: Constants.captionSize - 1
                                font.bold: true
                                font.family: Constants.fontFamily
                            }
                        }
                    }

                    Item { implicitHeight: 12 }
                }
            }
        }

        // Top progressive blur strip with Settings title
        Item {
            id: topBlurStrip
            z: 10
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: settingsText.implicitHeight + Constants.padding * 2.5

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
                id: settingsText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Constants.padding
                text: qsTr("Settings")
                color: Constants.foreground
                font.pixelSize: Constants.titleSize + 16
                font.bold: true
            }
        }
    }
}
