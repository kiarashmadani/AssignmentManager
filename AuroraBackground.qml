import QtQuick
import QtQuick.Shapes

// ═══════════════════════════════════════════════════════════════════
// AuroraBackground.qml
// Lightweight, 100% pure-QML animated Aurora / Mesh Gradient effect
// (inspired by reactbits.dev "Aurora")
//
// Zero custom GLSL shaders, zero .qsb compilation, zero per-pixel
// noise overhead. Uses GPU-cached low-res Gaussian radial textures
// animated via hardware transforms for rock-solid 60–120 FPS on
// Android and Desktop.
// ═══════════════════════════════════════════════════════════════════
Item {
    id: aurora
    clip: true

    // ── Public tuning knobs ─────────────────────────────────────────
    property color color1: Constants.primary
    property color color2: Constants.accent
    property color color3: Constants.secondary
    property real speed: 1.0         // 1.0 = smooth ambient flow; higher = faster
    property real intensity: Constants.isDark ? 0.78 : 0.48

    readonly property real durScale: 1.0 / Math.max(0.1, speed)
    readonly property real baseSize: Math.max(width, height * 0.65)

    // Helper component: a velvety Gaussian radial light orb cached into a
    // tiny 128x128 GPU texture. Because the item is always square and the
    // radius stops at 0.48, it reaches 0% alpha before any edge (no hard
    // clipping lines) and animates purely on the GPU vertex pipeline.
    component AuroraOrb: Shape {
        id: orb
        property color orbColor: "#FFFFFF"
        property real peakAlpha: 0.80
        property real stretchX: 1.25
        property real stretchY: 0.85

        preferredRendererType: Shape.GeometryRenderer
        layer.enabled: true
        layer.smooth: true
        layer.textureSize: Qt.size(128, 128)

        transform: Scale {
            origin.x: orb.width * 0.5
            origin.y: orb.height * 0.5
            xScale: orb.stretchX
            yScale: orb.stretchY
        }

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0; startY: 0
            PathRectangle {
                x: 0; y: 0
                width: orb.width
                height: orb.height
            }
            fillGradient: RadialGradient {
                centerX: orb.width * 0.5
                centerY: orb.height * 0.5
                centerRadius: orb.width * 0.48
                focalX: centerX
                focalY: centerY

                // Smooth Gaussian bell-curve falloff (creamy center, seamless edges)
                GradientStop { position: 0.00; color: Qt.alpha(orb.orbColor, orb.peakAlpha) }
                GradientStop { position: 0.22; color: Qt.alpha(orb.orbColor, orb.peakAlpha * 0.86) }
                GradientStop { position: 0.48; color: Qt.alpha(orb.orbColor, orb.peakAlpha * 0.48) }
                GradientStop { position: 0.74; color: Qt.alpha(orb.orbColor, orb.peakAlpha * 0.14) }
                GradientStop { position: 0.92; color: Qt.alpha(orb.orbColor, orb.peakAlpha * 0.02) }
                GradientStop { position: 1.00; color: "transparent" }
            }
        }
    }

    // ── 1. Primary Aurora Curtain (Top-Left sweeping right & back) ──
    AuroraOrb {
        id: orbPrimary
        orbColor: aurora.color1
        peakAlpha: aurora.intensity
        width: aurora.baseSize * 1.1
        height: width
        stretchX: 1.3
        stretchY: 0.85

        x: -width * 0.30
        y: -height * 0.35

        SequentialAnimation on x {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -orbPrimary.width * 0.40
                to: aurora.width * 0.22
                duration: 5400 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: aurora.width * 0.22
                to: -orbPrimary.width * 0.40
                duration: 6000 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on y {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -orbPrimary.height * 0.42
                to: -orbPrimary.height * 0.14
                duration: 4400 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: -orbPrimary.height * 0.14
                to: -orbPrimary.height * 0.42
                duration: 4900 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: 0.92; to: 1.22
                duration: 5100 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: 1.22; to: 0.92
                duration: 4700 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on rotation {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -16; to: 18
                duration: 6800 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: 18; to: -16
                duration: 6400 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }
    }

    // ── 2. Accent Aurora Ribbon (Top-Right counter-flowing) ─────────
    AuroraOrb {
        id: orbAccent
        orbColor: aurora.color2
        peakAlpha: aurora.intensity * 0.92
        width: aurora.baseSize * 1.0
        height: width
        stretchX: 1.25
        stretchY: 0.82

        x: aurora.width * 0.20
        y: -height * 0.26

        SequentialAnimation on x {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: aurora.width * 0.30
                to: -orbAccent.width * 0.30
                duration: 6300 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: -orbAccent.width * 0.30
                to: aurora.width * 0.30
                duration: 5800 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on y {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -orbAccent.height * 0.24
                to: aurora.height * 0.04
                duration: 5200 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: aurora.height * 0.04
                to: -orbAccent.height * 0.24
                duration: 4600 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: 1.18; to: 0.88
                duration: 5700 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: 0.88; to: 1.18
                duration: 5300 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }
    }

    // ── 3. Secondary Shimmer Veil (Upper-Mid weaving pulse) ─────────
    AuroraOrb {
        id: orbSecondary
        orbColor: aurora.color3
        peakAlpha: aurora.intensity * 0.80
        width: aurora.baseSize * 0.95
        height: width
        stretchX: 1.35
        stretchY: 0.80

        x: aurora.width * 0.05
        y: aurora.height * 0.02

        SequentialAnimation on x {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -orbSecondary.width * 0.24
                to: aurora.width * 0.26
                duration: 7200 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: aurora.width * 0.26
                to: -orbSecondary.width * 0.24
                duration: 6700 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on y {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: -orbSecondary.height * 0.10
                to: aurora.height * 0.16
                duration: 5900 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: aurora.height * 0.16
                to: -orbSecondary.height * 0.10
                duration: 5500 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: aurora.visible
            NumberAnimation {
                from: 0.50; to: 1.00
                duration: 4200 * aurora.durScale
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: 1.00; to: 0.50
                duration: 4600 * aurora.durScale
                easing.type: Easing.InOutSine
            }
        }
    }
}
