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

        // Content layer that extends all the way to the top of the screen
        Rectangle {
            id: contentArea
            anchors.fill: parent
            color: Constants.background

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Constants.padding
                anchors.topMargin: Constants.padding + settingsText.implicitHeight + Constants.spacing
                spacing: Constants.spacing

                Item { Layout.fillHeight: true }
            }
        }

        // Top progressive blur strip behind the Settings title
        Item {
            id: topBlurStrip
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
                    // 100% blur at the top edge, fading smoothly to 0% transparent at the bottom
                    GradientStop { position: 0.00; color: "#FFFFFFFF" }
                    GradientStop { position: 0.35; color: "#99FFFFFF" }
                    GradientStop { position: 0.70; color: "#26FFFFFF" }
                    GradientStop { position: 1.00; color: "#00FFFFFF" }
                }
            }

            MultiEffect {
                anchors.fill: parent
                source: topStripSource
                autoPaddingEnabled: false
                blurEnabled: true
                blur: 0.45
                blurMax: 22
                saturation: 0.15
                maskEnabled: true
                maskSource: topStripMask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }

        // Floating title on top of the blur strip
        Text {
            id: settingsText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Constants.padding
            text: qsTr("Settings")
            color: Constants.foreground
            font.pixelSize: Constants.titleSize
            font.bold: true
        }
    }
}
