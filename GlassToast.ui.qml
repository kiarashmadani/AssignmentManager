import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root

    // ── Public API ───────────────────────────────────────────
    property string message: ""
    property bool showing: false
    property bool isError: true
    property real topMargin: 20

    readonly property color accentColor: isError ? Constants.destructive : Constants.primary
    readonly property real maxPillWidth: parent ? Math.min(parent.width - 32, 360) : 340

    implicitWidth: Math.min(maxPillWidth, Math.max(180, contentRow.implicitWidth + 36))
    implicitHeight: Math.max(48, contentRow.implicitHeight + 22)

    width: implicitWidth
    height: implicitHeight

    // Dynamic Island / Liquid Glass spring drop-in from top
    y: showing ? topMargin : -height - 28
    opacity: showing ? 1.0 : 0.0
    scale: showing ? 1.0 : 0.90
    visible: opacity > 0.01

    Behavior on y {
        SpringAnimation {
            spring: 5.0
            damping: 0.42
            mass: 0.85
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        SpringAnimation {
            spring: 5.5
            damping: 0.40
            mass: 0.8
        }
    }

    // ── 1. Dual Elevation Shadow (Ambient Depth + Soft Accent Glow) ──
    Rectangle {
        id: shadowCaster
        anchors.fill: parent
        radius: height / 2
        color: Constants.shadowColor
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: shadowCaster
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Constants.shadowColor
        shadowOpacity: Constants.isDark ? 0.55 : 0.22
        shadowBlur: 0.95
        shadowVerticalOffset: 10
        shadowHorizontalOffset: 0
    }

    // Subtle colored ambient aura under the pill
    Rectangle {
        id: accentGlowCaster
        anchors.fill: parent
        radius: height / 2
        color: root.accentColor
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: accentGlowCaster
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: root.accentColor
        shadowOpacity: Constants.isDark ? 0.38 : 0.22
        shadowBlur: 0.85
        shadowVerticalOffset: 4
        shadowHorizontalOffset: 0
    }

    // ── 2. Liquid Glass Capsule Surface ──
    Rectangle {
        id: pillSurface
        anchors.fill: parent
        radius: height / 2
        color: Constants.card
        opacity: Constants.isDark ? 0.92 : 0.96

        // Subtle error/primary glass tint glaze
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.accentColor
            opacity: Constants.isDark ? 0.16 : 0.10
        }

        // 3D cylindrical glass volume sheen
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.00; color: Constants.glassShine }
                GradientStop { position: 0.28; color: "#14FFFFFF" }
                GradientStop { position: 0.65; color: "#00FFFFFF" }
                GradientStop { position: 1.00; color: Constants.isDark ? "#22000000" : "#08000000" }
            }
        }

        // Top meniscus catchlight reflection strip
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.max(24, parent.width - parent.height * 0.85)
            height: 2
            radius: 1
            opacity: Constants.isDark ? 0.65 : 0.90
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.00; color: "#00FFFFFF" }
                GradientStop { position: 0.25; color: Constants.glassEdge }
                GradientStop { position: 0.50; color: "#FFFFFFFF" }
                GradientStop { position: 0.75; color: Constants.glassEdge }
                GradientStop { position: 1.00; color: "#00FFFFFF" }
            }
        }

        // Outer specular accent rim
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1.2
            border.color: root.accentColor
            opacity: Constants.isDark ? 0.65 : 0.55
        }

        // Inner hairline glass bevel
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1.4
            radius: height / 2
            color: "transparent"
            border.width: 0.8
            border.color: Constants.glassEdge
            opacity: Constants.isDark ? 0.35 : 0.65
        }
    }

    // ── 3. Content: Glowing Status Orb + Message Text ──
    RowLayout {
        id: contentRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 14
        anchors.rightMargin: 18
        spacing: 11

        // Glowing circular status badge
        Item {
            implicitWidth: 26
            implicitHeight: 26
            Layout.alignment: Qt.AlignVCenter

            // Soft outer halo
            Rectangle {
                anchors.fill: parent
                anchors.margins: -3
                radius: width / 2
                color: root.accentColor
                opacity: 0.22
            }

            // Solid badge orb
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: root.accentColor

                Text {
                    anchors.centerIn: parent
                    text: root.isError ? "!" : "\u2713"
                    color: root.isError ? Constants.destructiveForeground : Constants.primaryForeground
                    font.pixelSize: 14
                    font.bold: true
                    font.family: Constants.fontFamily
                }
            }
        }

        // Notification message
        Text {
            id: messageLabel
            Layout.fillWidth: true
            Layout.maximumWidth: root.maxPillWidth - 76
            text: root.message
            color: Constants.foreground
            font.family: Constants.fontFamily
            font.pixelSize: Constants.captionSize + 1
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }
}
