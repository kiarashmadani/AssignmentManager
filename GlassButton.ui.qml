import QtQuick
import QtQuick.Controls.Basic

Button {
    id: glassButton
    // true = main action (Save): filled with the theme's primary color
    // false = secondary action (Cancel): see-through glass
    property bool primary: false

    implicitHeight: 52
    implicitWidth: 120

    // Tactile liquid spring on press and hover (Apple fluid physics)
    scale: glassButton.down ? 0.95 : (glassButton.hovered ? 1.025 : 1.0)
    Behavior on scale {
        SpringAnimation {
            spring: 5.5
            damping: 0.38
            mass: 0.75
        }
    }

    hoverEnabled: true

    background: Item {
        id: bgRoot
        readonly property real pillRadius: Math.min(width, height) / 2

        // Translucent Glass Body
        Rectangle {
            anchors.fill: parent
            radius: bgRoot.pillRadius
            gradient: glassButton.primary ? primaryGrad : glassGrad

            Gradient {
                id: primaryGrad
                GradientStop { position: 0.0; color: Qt.lighter(Constants.primary, 1.10) }
                GradientStop { position: 1.0; color: Qt.darker(Constants.primary, 1.05) }
            }

            Gradient {
                id: glassGrad
                GradientStop {
                    position: 0.0
                    color: Constants.isDark
                           ? Qt.rgba(1, 1, 1, glassButton.down ? 0.16 : 0.10)
                           : Qt.rgba(1, 1, 1, glassButton.down ? 0.95 : 0.85)
                }
                GradientStop {
                    position: 1.0
                    color: Constants.isDark
                           ? Qt.rgba(1, 1, 1, glassButton.down ? 0.08 : 0.05)
                           : Qt.rgba(1, 1, 1, glassButton.down ? 0.80 : 0.70)
                }
            }

            opacity: glassButton.down ? 0.88 : 1.0
            Behavior on opacity { NumberAnimation { duration: 150 } }

            // Clean Hairline Perimeter Border
            border.width: 1
            border.color: glassButton.primary
                ? Qt.rgba(1, 1, 1, 0.30)
                : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.10))
        }
    }

    contentItem: Item {
        Text {
            font.family: Constants.fontFamily
            anchors.centerIn: parent
            text: glassButton.text
            color: glassButton.primary ? Constants.primaryForeground : Constants.foreground
            font.pixelSize: Constants.bodySize
            font.weight: glassButton.primary ? Font.Bold : Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            scale: glassButton.down ? 0.96 : 1.0
            Behavior on scale {
                SpringAnimation { spring: 6.0; damping: 0.4 }
            }
            Behavior on color {
                ColorAnimation { duration: 180 }
            }
        }
    }
}
