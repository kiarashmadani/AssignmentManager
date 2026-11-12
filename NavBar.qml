pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

// Apple-style "Liquid Glass" floating navigation bar for Qt 6 (QtQuick + QtQuick.Effects).
// Engineered for high visual detail & optical clarity:
//  - High-clarity frosted vibrancy (preserves background detail & color definition while blurring)
//  - Real-time optical magnification & refraction inside the sliding liquid droplet
//  - Velocity-reactive liquid physics (stretches, squashes, and tilts specular highlights with motion)
//  - Multi-layer 3D glass detailing: top meniscus arc, bottom caustic bounce, fresnel rim bevels,
//    etched glass micro-dividers, and interactive touch/hover specular light tracking
//  - Dual-stenciled label clipping with optical lens magnification
Item {
    id: bar

    // ── Public API (drop-in compatible) ─────────────────────────────────
    property Item blurSource                                  // The page/content item behind the bar
    property var tabs: [qsTr("Assignments"), qsTr("Settings")]
    property int currentIndex: 0

    // Optical & detail tuning properties
    property real barBlurIntensity: 0.78                      // Frosted diffusion (lower = more background detail visible)
    property int barBlurMax: 64                               // Blur kernel radius for the main pill
    property real lensBlurIntensity: 0.38                     // Clearer refractive center inside the liquid droplet
    property real lensMagnification: 1.14                     // Optical zoom factor inside the liquid lens (>1.0 magnifies)
    property real glassSaturation: 0.75                       // Vibrant color transmission through glass
    property real glassContrast: 0.18                         // Crispness of shapes seen through the glass
    property real surfaceTintOpacity: Constants.isDark ? 0.22 : 0.16 // Low tint so background details shine through
    property real lensTintOpacity: bar.dragging ? 0.34 : 0.68 // Translucent liquid gel tint on the active tab
    property real lensStretchFactor: 0.036                    // Velocity-based horizontal liquid stretch

    // ── Internal geometry & state helpers ───────────────────────────────
    readonly property int tabCount: Math.max(1, tabs ? tabs.length : 1)
    readonly property real pad: 5
    readonly property real tabWidth: (width - 2 * pad) / tabCount
    readonly property bool dragging: touch.pressed
    readonly property int lensIndex: indexAt(lens.center)

    // Null-safe mapping from bar coordinates into blurSource coordinates
    readonly property real sourceOffsetX: blurSource ? (bar.x - blurSource.x) : 0
    readonly property real sourceOffsetY: blurSource ? (bar.y - blurSource.y) : 0

    function indexAt(xPos: real): int {
        return Math.max(0, Math.min(tabCount - 1, Math.floor((xPos - pad) / tabWidth)))
    }

    implicitWidth: 280
    implicitHeight: 62

    // Tactile whole-bar lift when pressed
    scale: bar.dragging ? 1.028 : 1.0
    Behavior on scale {
        SpringAnimation {
            spring: 4.5
            damping: 0.32
            mass: 0.85
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // 1. DUAL ELEVATION SHADOWS (Ambient Depth + Crisp Contact Rim)
    // ════════════════════════════════════════════════════════════════════
    Rectangle {
        id: shadowCaster
        anchors.fill: parent
        radius: height / 2
        color: Constants.shadowColor
        visible: false
        layer.enabled: true
    }

    // Deep ambient elevation shadow
    MultiEffect {
        anchors.fill: parent
        source: shadowCaster
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Constants.shadowColor
        shadowOpacity: Constants.shadowOpacity
        shadowBlur: 1.0
        shadowVerticalOffset: bar.dragging ? 15 : 10
        shadowHorizontalOffset: 0
        shadowScale: bar.dragging ? 1.03 : 0.99
        Behavior on shadowVerticalOffset { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on shadowScale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    }

    // Sharp contact shadow directly under the bottom glass edge
    MultiEffect {
        anchors.fill: parent
        source: shadowCaster
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Constants.shadowColor
        shadowOpacity: Constants.shadowOpacity * 0.65
        shadowBlur: 0.28
        shadowVerticalOffset: 2.5
        shadowHorizontalOffset: 0
    }

    // ════════════════════════════════════════════════════════════════════
    // 2. HIGH-DETAIL TRANSLUCENT GLASS PILL BACKDROP
    // ════════════════════════════════════════════════════════════════════
    ShaderEffectSource {
        id: behind
        anchors.fill: parent
        sourceItem: bar.blurSource
        sourceRect: Qt.rect(bar.sourceOffsetX, bar.sourceOffsetY, bar.width, bar.height)
        live: true
        hideSource: false
        visible: false
    }

    Rectangle {
        id: pillMask
        anchors.fill: parent
        radius: height / 2
        color: "#FFFFFF"
        layer.enabled: true
        layer.smooth: true
        visible: false
    }

    // High-definition frosted backdrop: preserves underlying contours & colors
    MultiEffect {
        id: frostedBackdrop
        anchors.fill: parent
        source: behind
        autoPaddingEnabled: false
        blurEnabled: true
        blur: bar.barBlurIntensity
        blurMax: bar.barBlurMax
        saturation: bar.glassSaturation
        contrast: bar.glassContrast
        brightness: Constants.isDark ? 0.03 : 0.06
        maskEnabled: true
        maskSource: pillMask
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }

    // Ultra-light theme surface glaze (kept transparent enough to show rich background detail)
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Constants.card
        opacity: bar.surfaceTintOpacity
    }

    // Top-to-bottom 3D cylindrical glass shading (top specular sheen + bottom internal caustic bounce)
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        gradient: Gradient {
            GradientStop { position: 0.00; color: Constants.glassShine }
            GradientStop { position: 0.18; color: "#18FFFFFF" }
            GradientStop { position: 0.52; color: "#00FFFFFF" }
            GradientStop { position: 0.85; color: Constants.isDark ? "#18000000" : "#08000000" }
            GradientStop { position: 1.00; color: Constants.glassShine }
        }
    }

    // Interactive pointer/finger light reflection across the glass bar surface
    // Rectangle {
    //     anchors.fill: parent
    //     radius: height / 2
    //     clip: true
    //     color: "transparent"

    //     Rectangle {
    //         width: bar.width * 0.55
    //         height: bar.height * 2.2
    //         radius: width / 2
    //         x: (touch.containsMouse || bar.dragging ? touch.mouseX : lens.center) - width / 2
    //         y: (touch.containsMouse || bar.dragging ? touch.mouseY : bar.height * 0.3) - height / 2
    //         opacity: (touch.containsMouse || bar.dragging) ? 0.42 : 0.18
    //         Behavior on opacity { NumberAnimation { duration: 200 } }
    //         Behavior on x { SmoothedAnimation { velocity: 900 } }
    //         gradient: Gradient {
    //             GradientStop { position: 0.0; color: Constants.glassEdge }
    //             GradientStop { position: 0.5; color: Constants.glassShine }
    //             GradientStop { position: 1.0; color: "#00FFFFFF" }
    //         }
    //     }
    // }

    // Top meniscus catchlight strip (thin intense reflection along the upper curvature)
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - parent.height * 0.48
        height: 2.5
        radius: 1.25
        opacity: 0.85
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: "#00FFFFFF" }
            GradientStop { position: 0.20; color: Constants.glassEdge }
            GradientStop { position: 0.50; color: "#FFFFFFFF" }
            GradientStop { position: 0.80; color: Constants.glassEdge }
            GradientStop { position: 1.00; color: "#00FFFFFF" }
        }
    }

    // Bottom internal caustic rim highlight (light refracting at the lower edge of the glass tube)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - parent.height * 0.52
        height: 1.5
        radius: 0.75
        opacity: 0.65
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: "#00FFFFFF" }
            GradientStop { position: 0.25; color: Constants.glassShine }
            GradientStop { position: 0.50; color: Constants.glassEdge }
            GradientStop { position: 0.75; color: Constants.glassShine }
            GradientStop { position: 1.00; color: "#00FFFFFF" }
        }
    }

    // Etched glass micro-dividers between tabs (fade out smoothly when the liquid lens overlaps them)
    Repeater {
        model: Math.max(0, bar.tabCount - 1)

        Rectangle {
            required property int index
            readonly property real dividerX: bar.pad + (index + 1) * bar.tabWidth
            readonly property real distFromLens: Math.abs(dividerX - lens.center)
            readonly property real fadeThreshold: lens.width * 0.62

            x: dividerX - width / 2
            y: bar.height * 0.26
            width: 1
            height: bar.height * 0.48
            radius: 0.5
            color: Constants.glassEdge
            opacity: Math.max(0.0, Math.min(0.45, (distFromLens - lens.width * 0.35) / Math.max(1, fadeThreshold) * 0.45))
        }
    }

    // Outer primary glass fresnel border
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "transparent"
        border.width: 1.25
        border.color: Constants.glassEdge
        opacity: 0.95
    }

    // Inner recessed bevel ring (gives visible thickness to the glass wall)
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1.5
        radius: height / 2
        color: "transparent"
        border.width: 1.0
        border.color: Constants.isDark ? "#28000000" : "#40FFFFFF"
        opacity: 0.75
    }

    // ════════════════════════════════════════════════════════════════════
    // 3. THE LIQUID LENS (Optical Magnifier, Gel Refraction & Caustics)
    // ════════════════════════════════════════════════════════════════════
    Item {
        id: lens

        readonly property real minCenter: bar.pad + bar.tabWidth / 2
        readonly property real maxCenter: bar.width - bar.pad - bar.tabWidth / 2
        property real targetCenter: bar.dragging
            ? Math.max(minCenter, Math.min(maxCenter, touch.mouseX))
            : bar.pad + (bar.currentIndex + 0.5) * bar.tabWidth

        // Spring-driven center coordinate for fluid inertia
        property real center: targetCenter
        Behavior on center {
            SpringAnimation {
                spring: bar.dragging ? 17.0 : 9.0
                damping: bar.dragging ? 0.75 : 0.78
                mass: 0.85
            }
        }

        // Instantaneous velocity tracker for liquid stretching & specular tilt
        property real prevCenter: center
        property real velocity: 0.0

        FrameAnimation {
            running: bar.dragging || Math.abs(lens.velocity) > 0.01
            onTriggered: {
                if (frameTime > 0) {
                    const instVel = (lens.center - lens.prevCenter) / (frameTime * 60.0)
                    lens.velocity = lens.velocity * 0.70 + instVel * 0.30
                    lens.prevCenter = lens.center
                }
            }
        }

        // Droplet inflation when pressed/dragged
        property real grow: bar.dragging ? 5.5 : 0.0
        Behavior on grow {
            SpringAnimation {
                spring: 4.8
                damping: 0.32
            }
        }

        // Dynamic velocity deformation (stretches horizontally, squashes vertically)
        readonly property real speedStretch: Math.min(20.0, Math.abs(velocity) * bar.lensStretchFactor * bar.tabWidth)
        readonly property real speedSquash: Math.min(5.0, speedStretch * 0.25)
        readonly property real velocityTiltOffset: Math.max(-10.0, Math.min(10.0, -velocity * 1.4))

        width: bar.tabWidth + 2 * grow + speedStretch
        height: (bar.height - 2 * bar.pad) + 2 * grow - speedSquash
        x: Math.max(bar.pad - grow, Math.min(bar.width - bar.pad + grow - width, center - width / 2))
        y: (bar.height - height) / 2

        // Colored liquid caustic glow cast onto the glass bar underneath the droplet
        // Rectangle {
        //     id: lensGlowCaster
        //     anchors.fill: parent
        //     radius: height / 2
        //     color: Constants.primary
        //     visible: false
        //     layer.enabled: true
        // }

        // MultiEffect {
        //     anchors.fill: parent
        //     source: lensGlowCaster
        //     autoPaddingEnabled: true
        //     shadowEnabled: true
        //     shadowColor: Constants.primary
        //     shadowOpacity: bar.dragging ? 0.42 : 0.55
        //     shadowBlur: 0.9
        //     shadowVerticalOffset: bar.dragging ? 5 : 2
        //     shadowHorizontalOffset: lens.velocityTiltOffset * 0.4
        //     Behavior on shadowOpacity { NumberAnimation { duration: 180 } }
        // }

        // Mask for the droplet's optical layers
        Rectangle {
            id: lensMask
            anchors.fill: parent
            radius: height / 2
            color: "#FFFFFF"
            layer.enabled: true
            layer.smooth: true
            visible: false
        }

        // Magnified direct background sample (real optical refraction of the scene behind the lens)
        ShaderEffectSource {
            id: lensMagnifiedBehind
            anchors.fill: parent
            sourceItem: bar.blurSource
            readonly property real zoom: bar.dragging ? (bar.lensMagnification * 1.05) : bar.lensMagnification
            readonly property real sampleW: lens.width / zoom
            readonly property real sampleH: lens.height / zoom
            readonly property real sampleX: bar.sourceOffsetX + lens.center - sampleW / 2
            readonly property real sampleY: bar.sourceOffsetY + (bar.height - sampleH) / 2
            sourceRect: Qt.rect(sampleX, sampleY, sampleW, sampleH)
            live: true
            hideSource: false
            visible: false
        }

        // Clearer, high-vibrancy refractive pass inside the droplet so background details pop through
        MultiEffect {
            anchors.fill: parent
            source: lensMagnifiedBehind
            autoPaddingEnabled: false
            blurEnabled: true
            blur: bar.dragging ? (bar.lensBlurIntensity * 0.75) : bar.lensBlurIntensity
            blurMax: 32
            saturation: 0.95
            contrast: 0.24
            brightness: Constants.isDark ? 0.08 : 0.12
            maskEnabled: true
            maskSource: lensMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        // Translucent liquid gel selection body (lets refracted details shine through the primary color)
        Rectangle {
            id: lensBody
            anchors.fill: parent
            radius: height / 2
            color: Constants.primary
            opacity: bar.lensTintOpacity
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        }

        // 3D convex liquid volume shading (bright upper dome + rich lower depth)
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            gradient: Gradient {
                GradientStop { position: 0.00; color: Constants.glassEdge }
                GradientStop { position: 0.22; color: Constants.glassShine }
                GradientStop { position: 0.55; color: "#00FFFFFF" }
                GradientStop { position: 0.82; color: Constants.isDark ? "#38000000" : "#18000000" }
                GradientStop { position: 1.00; color: Constants.glassShine }
            }
            opacity: bar.dragging ? 0.95 : 0.80
            Behavior on opacity { NumberAnimation { duration: 180 } }
        }

        // Upper liquid meniscus arc (shifts with droplet velocity like a real fluid bubble)
        Rectangle {
            id: lensMeniscus
            anchors.top: parent.top
            anchors.topMargin: 2.0
            x: (parent.width - width) / 2 + lens.velocityTiltOffset * 0.5
            width: Math.max(16, parent.width - parent.height * 0.45)
            height: parent.height * 0.36
            radius: height / 2
            opacity: bar.dragging ? 0.82 : 0.55
            Behavior on opacity { NumberAnimation { duration: 180 } }
            gradient: Gradient {
                GradientStop { position: 0.00; color: "#FFFFFFFF" }
                GradientStop { position: 0.45; color: Constants.glassShine }
                GradientStop { position: 1.00; color: "#00FFFFFF" }
            }
        }

        // Lower internal caustic reflection arc (light focused at the bottom of the droplet)
        Rectangle {
            id: lensCaustic
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2.0
            x: (parent.width - width) / 2 - lens.velocityTiltOffset * 0.5
            width: Math.max(14, parent.width - parent.height * 0.52)
            height: parent.height * 0.22
            radius: height / 2
            opacity: bar.dragging ? 0.70 : 0.42
            Behavior on opacity { NumberAnimation { duration: 180 } }
            gradient: Gradient {
                GradientStop { position: 0.00; color: "#00FFFFFF" }
                GradientStop { position: 0.65; color: Constants.glassShine }
                GradientStop { position: 1.00; color: Constants.glassEdge }
            }
        }

        // Outer specular droplet rim (bright fresnel boundary)
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: "transparent"
            border.width: bar.dragging ? 1.6 : 1.2
            border.color: Constants.glassEdge
            opacity: bar.dragging ? 1.0 : 0.82
            Behavior on opacity { NumberAnimation { duration: 180 } }
            Behavior on border.width { NumberAnimation { duration: 180 } }
        }

        // Inner dark/light refractive ring for sharp optical separation
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1.4
            radius: height / 2
            color: "transparent"
            border.width: 0.8
            border.color: Constants.isDark ? "#40FFFFFF" : "#66FFFFFF"
            opacity: 0.7
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // 4. DUAL-STENCILED LABELS WITH SUBTLE ETCHED TEXT SHADOW
    // ════════════════════════════════════════════════════════════════════
    // Base label layer (unselected state outside the liquid lens)
    Row {
        id: baseLabelsRow
        x: bar.pad
        y: bar.pad
        height: bar.height - 2 * bar.pad

        Repeater {
            model: bar.tabs

            Item {
                required property int index
                required property string modelData

                width: bar.tabWidth
                height: parent.height

                // Subtle etched glass drop-shadow behind unselected labels for legibility over detailed backgrounds
                Text {
                    font.family: Constants.fontFamily
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 0.8
                    text: parent.modelData
                    color: Constants.shadowColor
                    opacity: index === bar.lensIndex ? 0.0 : (Constants.isDark ? 0.45 : 0.18)
                    font.pixelSize: Constants.bodySize
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on opacity { NumberAnimation { duration: 140 } }
                }

                Text {
                    font.family: Constants.fontFamily
                    anchors.centerIn: parent
                    text: parent.modelData
                    color: Constants.foreground
                    opacity: index === bar.lensIndex ? 0.12 : 0.88
                    font.pixelSize: Constants.bodySize
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on opacity { NumberAnimation { duration: 140 } }
                }
            }
        }
    }

    // Stenciled active label layer inside the liquid droplet
    Item {
        id: activeLabelsClipContainer
        anchors.fill: parent
        clip: true

        Item {
            id: lensClipWindow
            x: lens.x
            y: lens.y
            width: lens.width
            height: lens.height
            clip: true

            Row {
                x: bar.pad - lens.x
                y: bar.pad - lens.y
                height: bar.height - 2 * bar.pad

                Repeater {
                    model: bar.tabs

                    Item {
                        required property int index
                        required property string modelData

                        width: bar.tabWidth
                        height: parent.height

                        // Subtle depth shadow behind active lens text
                        Text {
                            font.family: Constants.fontFamily
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 1.0
                            text: parent.modelData
                            color: Constants.shadowColor
                            opacity: Constants.isDark ? 0.40 : 0.22
                            font.pixelSize: Constants.bodySize
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            scale: (bar.dragging && index === bar.lensIndex) ? 1.06 : 1.02
                        }

                        Text {
                            font.family: Constants.fontFamily
                            anchors.centerIn: parent
                            text: parent.modelData
                            color: Constants.primaryForeground
                            font.pixelSize: Constants.bodySize
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            // Optical magnification of the label inside the convex droplet
                            scale: (bar.dragging && index === bar.lensIndex) ? 1.06 : 1.02
                            Behavior on scale {
                                SpringAnimation { spring: 5.2; damping: 0.38 }
                            }
                        }
                    }
                }
            }
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // 5. TOUCH, DRAG & HOVER TRACKING
    // ════════════════════════════════════════════════════════════════════
    MouseArea {
        id: touch
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true

        onPressed: (mouse) => {
            bar.currentIndex = bar.indexAt(mouse.x)
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                bar.currentIndex = bar.indexAt(mouse.x)
            }
        }
        onReleased: (mouse) => {
            bar.currentIndex = bar.indexAt(mouse.x)
        }
    }
}
