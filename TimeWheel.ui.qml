pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects

Tumbler {
    id: wheel
    implicitWidth: 50
    implicitHeight: 130
    visibleItemCount: 5
    property int offset: 0          // shown number = row + offset (days and months start at 1)

    wrap: false

    delegate: Item {
        id: delegateItem
        required property int index
        required property var modelData
        readonly property int value: modelData + (Tumbler.tumbler as TimeWheel).offset

        // Safely access attached displacement on the delegate root item
        readonly property real rawDisp: Tumbler.displacement
        readonly property real disp: Math.abs(rawDisp)

        // Drum cylinder angular position in radians (+/-65 deg at displacement +/-2)
        // 65 deg = 1.134 rad -> theta = rawDisp * (1.134 / 2) = rawDisp * 0.567
        readonly property real theta: Math.max(-1.25, Math.min(1.25, rawDisp * 0.567))
        readonly property real cosTheta: Math.max(0.08, Math.cos(theta))
        readonly property real angleDeg: Math.max(-65, Math.min(65, rawDisp * 32.5))

        width: wheel.width
        height: wheel.height / wheel.visibleItemCount

        // 1. Apple Alarm App Opacity Falloff:
        // Center is 1.0 (100%), 1 step away is ~0.42, 2 steps away is 0.0 (fade out smoothly at edge)
        opacity: {
            if (disp <= 0.45) return 1.0
            var factor = Math.max(0.0, 1.0 - (disp - 0.45) / 1.55)
            return Math.pow(factor, 2.0)
        }

        // 2. Physical cylinder foreshortening + 3D drum tilt:
        // Height (Y-scale) compresses drastically as the surface rolls away,
        // while Rotation tilts the numbers along the tangent of the drum cylinder.
        transform: [
            Scale {
                origin.x: delegateItem.width / 2
                origin.y: delegateItem.height / 2
                yScale: Math.max(0.12, Math.pow(delegateItem.cosTheta, 1.4))
                xScale: Math.max(0.85, 1.0 - (1.0 - delegateItem.cosTheta) * 0.14)
            },
            Rotation {
                origin.x: delegateItem.width / 2
                origin.y: delegateItem.height / 2
                axis { x: 1; y: 0; z: 0 }
                angle: -delegateItem.angleDeg
            }
        ]

        // Luminous number glyph with cylindrical Y-offset compression & progressive horizon blur
        Text {
            id: numText
            anchors.centerIn: parent
            // Y-offset compresses item spacing towards the horizon curve:
            anchors.verticalCenterOffset: delegateItem.height * (1.76 * Math.sin(delegateItem.theta) - delegateItem.rawDisp)

            text: (delegateItem.value < 10 ? "0" : "") + delegateItem.value
            color: delegateItem.disp < 0.45 ? Constants.foreground : Constants.mutedForeground
            font.pixelSize: Constants.bodySize + 4
            font.family: Constants.fontFamily
            font.weight: delegateItem.disp < 0.45 ? Font.Bold : Font.Normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // Progressive blur for numbers rolling away to top/bottom horizons (Apple Alarm style)
            layer.enabled: delegateItem.disp > 0.55
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: Math.min(1.0, (delegateItem.disp - 0.55) * 0.65)
                blurMax: 8
            }
        }
    }
}
