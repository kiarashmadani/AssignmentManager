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
    property alias settingsPage: settingsPage

    Rectangle {
        id: page
        anchors.fill: parent
        color: Constants.background

        SwipeView {
            id: pages
            anchors.fill: parent
            currentIndex: navBar.currentIndex

            AssignmentsPage {}
            SettingsPage {id: settingsPage}
        }
    }

    Button {
            id: addButton
            z: 2
            width: 58
            height: 58
            padding: 0
            visible: navBar.currentIndex === 0
            hoverEnabled: true
            anchors.right: parent.right
            anchors.bottom: navBar.top
            anchors.margins: Constants.padding
            text: "+"

            // Tactile liquid spring bounce when pressed or hovered
            scale: addButton.down ? 0.92 : (addButton.hovered ? 1.05 : 1.0)
            Behavior on scale {
                SpringAnimation {
                    spring: 5.2
                    damping: 0.35
                    mass: 0.8
                }
            }

            background: Item {
                // 1. Live background sample directly behind the button
                ShaderEffectSource {
                    id: addBtnBehind
                    anchors.fill: parent
                    sourceItem: page
                    sourceRect: Qt.rect(addButton.x, addButton.y, addButton.width, addButton.height)
                    live: true
                    visible: false
                }

                // Circular mask for the glass orb
                Rectangle {
                    id: addBtnMask
                    anchors.fill: parent
                    radius: height / 2
                    color: "#FFFFFF"
                    layer.enabled: true
                    layer.smooth: true
                    visible: false
                }

                // 2. Frosted refractive backdrop inside the orb
                MultiEffect {
                    anchors.fill: parent
                    source: addBtnBehind
                    autoPaddingEnabled: false
                    blurEnabled: true
                    blur: addButton.down ? 0.40 : 0.60
                    blurMax: 50
                    saturation: 0.7
                    contrast: 0.22
                    brightness: Constants.isDark ? 0.08 : 0.12
                    maskEnabled: true
                    maskSource: addBtnMask
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }

                // 3. Translucent liquid primary gel core (matches the NavBar lens)
                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Constants.primary
                    opacity: addButton.down ? 0.52 : 0.72
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // 4. 3D convex liquid volume shading
                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    opacity: addButton.down ? 0.95 : 0.80
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: Constants.glassEdge }
                        GradientStop { position: 0.25; color: Constants.glassShine }
                        GradientStop { position: 0.55; color: "#00FFFFFF" }
                        GradientStop { position: 1.00; color: Constants.glassShine }
                    }
                }
                // 5 & 6. Concentric circular top & bottom light reflection
                // (Uses anchors.fill + margins so its curve is 100% parallel to the outer circle)
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3.5
                    radius: width / 2
                    opacity: addButton.down ? 0.85 : 0.60
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    gradient: Gradient {
                        // Top curved highlight fading into the center, plus a soft bottom rim glow
                        GradientStop { position: 0.00; color: "#D9FFFFFF" }
                        GradientStop { position: 0.28; color: Constants.glassShine }
                        GradientStop { position: 0.50; color: "#00FFFFFF" }
                        GradientStop { position: 0.82; color: "#00FFFFFF" }
                        GradientStop { position: 1.00; color: Constants.glassShine }
                    }
                }

                // 7. Outer specular fresnel rim
                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: "transparent"
                    border.width: addButton.down ? 1.6 : 1.2
                    border.color: Constants.glassEdge
                    opacity: addButton.down ? 1.0 : 0.85
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // 8. Inner refractive glass ring
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1.5
                    radius: height / 2
                    color: "transparent"
                    border.width: 0.8
                    border.color: Constants.isDark ? "#40FFFFFF" : "#66FFFFFF"
                    opacity: 0.70
                }
            }

            contentItem: Item {
                scale: addButton.down ? 1.12 : 1.0
                Behavior on scale {
                    SpringAnimation { spring: 5.5; damping: 0.4 }
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 22
                    height: 3
                    radius: 1.5
                    color: Constants.primaryForeground
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 3
                    height: 22
                    radius: 1.5
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
                blur: 0.7              // Subtle blur intensity
                blurMax: 50                // Gentle radius (like iOS Photos bar)
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
