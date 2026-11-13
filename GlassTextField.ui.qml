import QtQuick
import QtQuick.Controls.Basic

TextField {
    id: field
    implicitHeight: 52
    leftPadding: 16
    rightPadding: 16

    color: Constants.foreground
    placeholderTextColor: Constants.mutedForeground
    selectionColor: Constants.primary
    selectedTextColor: Constants.primaryForeground
    font.pixelSize: Constants.bodySize
    font.family: Constants.fontFamily

    background: Item {
        // 1. Soft Glowing Focus Halo
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: Constants.radius + 2
            color: Constants.ring
            opacity: field.activeFocus ? (Constants.isDark ? 0.35 : 0.22) : 0.0
            scale: field.activeFocus ? 1.0 : 0.98
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on scale { SpringAnimation { spring: 6; damping: 0.4 } }
        }

        // 2. Translucent Frosted Glass Base
        Rectangle {
            anchors.fill: parent
            radius: Constants.radius
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Constants.isDark
                           ? Qt.rgba(1, 1, 1, field.activeFocus ? 0.12 : 0.07)
                           : Qt.rgba(1, 1, 1, field.activeFocus ? 0.95 : 0.85)
                }
                GradientStop {
                    position: 1.0
                    color: Constants.isDark
                           ? Qt.rgba(1, 1, 1, field.activeFocus ? 0.07 : 0.04)
                           : Qt.rgba(1, 1, 1, field.activeFocus ? 0.85 : 0.75)
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: Constants.radius
                color: Constants.card
                opacity: Constants.isDark ? 0.35 : 0.20
            }

            // Perimeter Border (Smooth highlight on focus)
            border.width: field.activeFocus ? 1.5 : 1
            border.color: field.activeFocus
                ? Constants.ring
                : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))
            Behavior on border.color { ColorAnimation { duration: 200 } }
            Behavior on border.width { NumberAnimation { duration: 180 } }
        }
    }
}
