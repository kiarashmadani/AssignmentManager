import QtQuick
import QtQuick.Controls.Basic

Button {
    id: glassButton
    // true = main action (Save): filled with the theme's primary color
    // false = secondary action (Cancel): see-through glass
    property bool primary: false

    implicitHeight: 48
    implicitWidth: 120

    scale: glassButton.down ? 0.95 : 1.0
    Behavior on scale {
        SpringAnimation {
            spring: 5
            damping: 0.4
        }
    }

    background: Item {
        Rectangle {
            // 1. body
            anchors.fill: parent
            radius: height / 2
            color: glassButton.primary ? Constants.primary : Constants.card
            opacity: glassButton.primary ? (glassButton.down ? 0.75 : 0.9) : (glassButton.down ? 0.7 : (Constants.isDark ? 0.4 : 0.55))
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
        Rectangle {
            // 2. glass shine
            anchors.fill: parent
            radius: height / 2
            opacity: glassButton.primary ? 0.8 : 0.6
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Constants.glassEdge
                }
                GradientStop {
                    position: 0.3
                    color: Constants.glassShine
                }
                GradientStop {
                    position: 0.6
                    color: "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: Constants.glassShine
                }
            }
        }
        Rectangle {
            // 3. rim
            anchors.fill: parent
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: glassButton.primary ? Constants.glassEdge : Constants.border
        }
    }

    contentItem: Text {
        text: glassButton.text
        color: glassButton.primary ? Constants.primaryForeground : Constants.foreground
        font.pixelSize: Constants.bodySize
        font.family: Constants.fontFamily
        font.weight: glassButton.primary ? Font.DemiBold : Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
