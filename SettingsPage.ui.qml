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

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Constants.padding
                anchors.topMargin: Constants.padding + settingsText.implicitHeight + Constants.spacing
                spacing: Constants.spacing

                Text {
                    font.family: Constants.fontFamily
                    id: appearanceText
                    text: qsTr("Appearance")
                    color: Constants.foreground
                    font.pixelSize: Constants.bodySize
                    Layout.fillWidth: true
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Constants.border
                }

                GridLayout {
                    columns: 3
                    rowSpacing: Constants.spacing
                    columnSpacing: Constants.spacing
                    Layout.fillWidth: true

                    ButtonGroup { id: themeGroup }

                    ThemeButton {themeIndex:0; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                    ThemeButton {themeIndex:1; Layout.fillWidth: true; ButtonGroup.group: themeGroup }
                    ThemeButton {themeIndex:2; Layout.fillWidth: true; ButtonGroup.group: themeGroup  }
                    ThemeButton {themeIndex:3; Layout.fillWidth: true; ButtonGroup.group: themeGroup  }
                    ThemeButton {themeIndex:4; Layout.fillWidth: true; ButtonGroup.group: themeGroup  }
                    ThemeButton {themeIndex:5; Layout.fillWidth: true; ButtonGroup.group: themeGroup  }
                }

                Text {
                    font.family: Constants.fontFamily
                    id: languageText
                    text: qsTr("Language")
                    color: Constants.foreground
                    font.pixelSize: Constants.bodySize
                    Layout.fillWidth: true
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Constants.border
                }

                ButtonGroup { id: languageGroup }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Constants.spacing
                    LanguageButton { languageIndex: 0; Layout.fillWidth: true; ButtonGroup.group: languageGroup }
                    LanguageButton { languageIndex: 1; Layout.fillWidth: true; ButtonGroup.group: languageGroup }
                }

                Item { Layout.fillHeight: true }
            }
        }

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
