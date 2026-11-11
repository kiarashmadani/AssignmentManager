import QtQuick
import QtQuick.Controls.Basic

TextField {
    id: field
    implicitHeight: 48
    leftPadding: Constants.padding
    rightPadding: Constants.padding

    color: Constants.foreground
    placeholderTextColor: Constants.mutedForeground
    selectionColor: Constants.primary
    selectedTextColor: Constants.primaryForeground
    font.pixelSize: Constants.bodySize
    font.family: Constants.fontFamily

    background: Item {
        // 1. Frosted base: a bit stronger while typing
        Rectangle {
            anchors.fill: parent
            radius: Constants.radius
            color: Constants.card
            opacity: field.activeFocus ? 0.85 : (Constants.isDark ? 0.45 : 0.6)
            Behavior on opacity {
                NumberAnimation {
                    duration: 180
                }
            }
        }
        // 2. Glass shine from the top edge
        Rectangle {
            anchors.fill: parent
            radius: Constants.radius
            opacity: 0.6
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Constants.glassShine
                }
                GradientStop {
                    position: 0.5
                    color: "transparent"
                }
            }
        }
        // 3. Rim: glass edge, theme ring color while typing
        Rectangle {
            anchors.fill: parent
            radius: Constants.radius
            color: "transparent"
            border.width: field.activeFocus ? 2 : 1
            border.color: field.activeFocus ? Constants.ring : Constants.glassEdge
            Behavior on border.color {
                ColorAnimation {
                    duration: 180
                }
            }
        }
    }
}
