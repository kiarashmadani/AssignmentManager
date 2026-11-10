import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    width: Constants.width
    height: Constants.height

    property alias pages: pages
    property alias navBar: navBar
    property alias addButton: addButton

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        SwipeView {
            id: pages
            anchors.fill: parent
            currentIndex: navBar.currentIndex

            AssignmentsPage {}
            SettingsPage {}
        }
    }

    Button {
        id: addButton
        width: 56
        height: 56
        padding: 0
        visible: navBar.currentIndex === 0
        anchors.right: parent.right
        anchors.bottom: navBar.top
        anchors.margins: Constants.padding
        text: "+"

        background: Rectangle {
            radius: Constants.radius
            color: Constants.primary
            opacity: addButton.down ? 0.85 : 1.0
        }
        contentItem: Item {
            Rectangle {
                anchors.centerIn: parent
                width: 22; height: 3; radius: 1.5
                color: Constants.primaryForeground
            }
            Rectangle {
                anchors.centerIn: parent
                width: 3; height: 22; radius: 1.5
                color: Constants.primaryForeground
            }
        }
    }

    Item {
            id: navBarBlurStrip
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: navBar.height + Constants.padding * 2

            ShaderEffectSource {
                id: bottomStripSource
                anchors.fill: parent
                sourceItem: page
                sourceRect: Qt.rect(0, root.height - parent.height, root.width, parent.height)
                live: true
                visible: false
            }

            Rectangle {
                id: bottomStripMask
                anchors.fill: parent
                layer.enabled: true
                visible: false
                gradient: Gradient {
                    // Smoothly fades from 0% at the top edge down to 100% at the bottom
                    GradientStop { position: 0.00; color: "#00FFFFFF" }
                    GradientStop { position: 0.30; color: "#26FFFFFF" }
                    GradientStop { position: 0.65; color: "#99FFFFFF" }
                    GradientStop { position: 1.00; color: "#FFFFFFFF" }
                }
            }

            MultiEffect {
                anchors.fill: parent
                source: bottomStripSource
                autoPaddingEnabled: false
                blurEnabled: true
                blur: 0.45                 // Subtle blur intensity
                blurMax: 22                // Gentle radius (like iOS Photos bar)
                saturation: 0.15
                maskEnabled: true
                maskSource: bottomStripMask
                maskThresholdMin: 0.5      // Required so MultiEffect respects the smooth gradient alpha
                maskSpreadAtMin: 1.0       // Maps alpha 0.0 -> 1.0 smoothly instead of a hard cut
            }
        }

    NavBar {
        id: navBar
        blurSource: page
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Constants.padding
    }
}
