import QtQuick
import QtQuick.Controls.Basic

Button {
    id: languageButton
    property int languageIndex: 0   // 0 = English, 1 = Persian
    readonly property string languageCode: languageIndex === 0 ? "en" : "fa"
    checkable: true
    hoverEnabled: true

    // selected when it is the app's current language
    checked: Qt.uiLanguage === languageCode

    // each language is written in its own language, so no qsTr here
    text: languageIndex === 0 ? "English" : "فارسی"

    implicitWidth: 120
    implicitHeight: 48

    // Tactile liquid spring physics on press and hover
    scale: languageButton.down ? 0.93 : (languageButton.hovered ? 1.04 : 1.0)
    Behavior on scale {
        SpringAnimation {
            spring: 5.2
            damping: 0.36
            mass: 0.8
        }
    }

    background: Item {
        readonly property real pillRadius: Math.min(width, height) / 2

        // 1. Translucent liquid gel core (glows with primary/accent when checked, frosted card when unchecked)
        Rectangle {
            anchors.fill: parent
            radius: parent.pillRadius
            color: languageButton.checked ? Constants.primary : Constants.card
            opacity: languageButton.down
                ? 0.55
                : (languageButton.checked ? 0.74 : (Constants.isDark ? 0.38 : 0.45))

            Behavior on color { ColorAnimation { duration: 220 } }
            Behavior on opacity { NumberAnimation { duration: 180 } }
        }

        // 2. Subtle secondary accent infusion when checked
        Rectangle {
            anchors.fill: parent
            radius: parent.pillRadius
            color: Constants.accent
            opacity: languageButton.checked ? 0.28 : 0.0
            Behavior on opacity { NumberAnimation { duration: 220 } }
        }

        // 3. 3D convex liquid volume shading
        Rectangle {
            anchors.fill: parent
            radius: parent.pillRadius
            opacity: languageButton.checked ? 0.88 : 0.55
            Behavior on opacity { NumberAnimation { duration: 200 } }
            gradient: Gradient {
                GradientStop { position: 0.00; color: Constants.glassEdge }
                GradientStop { position: 0.26; color: Constants.glassShine }
                GradientStop { position: 0.55; color: "transparent" }
                GradientStop { position: 1.00; color: Constants.glassShine }
            }
        }

        // 4. Concentric curved top & bottom light reflection
        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: Math.max(0, parent.pillRadius - 3)
            opacity: languageButton.down ? 0.85 : (languageButton.checked ? 0.65 : 0.35)
            Behavior on opacity { NumberAnimation { duration: 180 } }
            gradient: Gradient {
                GradientStop { position: 0.00; color: Constants.glassEdge }
                GradientStop { position: 0.28; color: Constants.glassShine }
                GradientStop { position: 0.52; color: "transparent" }
                GradientStop { position: 0.82; color: "transparent" }
                GradientStop { position: 1.00; color: Constants.glassShine }
            }
        }

        // 5. Outer specular fresnel rim
        Rectangle {
            anchors.fill: parent
            radius: parent.pillRadius
            color: "transparent"
            border.width: languageButton.checked ? 1.5 : 1.0
            border.color: languageButton.checked ? Constants.glassEdge : Constants.border
            opacity: languageButton.checked ? 0.95 : 0.70

            Behavior on border.width { NumberAnimation { duration: 180 } }
            Behavior on border.color { ColorAnimation { duration: 200 } }
            Behavior on opacity { NumberAnimation { duration: 180 } }
        }

        // 6. Inner refractive glass ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1.5
            radius: Math.max(0, parent.pillRadius - 1.5)
            color: "transparent"
            border.width: 0.8
            border.color: Constants.glassShine
            opacity: languageButton.checked ? 0.75 : 0.40
            Behavior on opacity { NumberAnimation { duration: 180 } }
        }
    }

    contentItem: Item {
        Text {
            font.family: Constants.fontFamily
            anchors.centerIn: parent
            text: languageButton.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: languageButton.checked ? Constants.primaryForeground : Constants.foreground
            font.pixelSize: Constants.bodySize
            font.weight: languageButton.checked ? Font.DemiBold : Font.Medium

            scale: languageButton.checked ? 1.04 : 1.0
            Behavior on scale {
                SpringAnimation { spring: 5.0; damping: 0.4 }
            }
            Behavior on color {
                ColorAnimation { duration: 180 }
            }
        }
    }
}
