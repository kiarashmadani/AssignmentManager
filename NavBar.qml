pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

// Floating "liquid glass" tab bar.
// Tap a tab, or press and drag: the lens grows, lifts and follows your finger.
Item {
    id: bar

    // ── Set these where the bar is used ─────────────────────
    property Item blurSource                    // the page that lies behind the bar
    property var tabs: [qsTr("Assignments"), qsTr("Settings")]
    property int currentIndex: 0

    // ── Internal helpers ────────────────────────────────────
    readonly property real pad: 6
    readonly property real tabWidth: (width - 2 * pad) / tabs.length
    readonly property bool dragging: touch.pressed
    // The tab the lens is over right now (used for the label colors)
    readonly property int lensIndex: indexAt(lens.x + lens.width / 2)

    function indexAt(xPos) {
        return Math.max(0, Math.min(tabs.length - 1, Math.floor((xPos - pad) / tabWidth)))
    }

    implicitWidth: 260
    implicitHeight: 60

    // ── The glass pill: 5 layers ────────────────────────────
    // 1. Soft shadow under the pill
    Rectangle {
        id: shadowShape
        anchors.fill: parent
        radius: height / 2
        color: Constants.background
        layer.enabled: true
        visible: false
    }
    MultiEffect {
        anchors.fill: parent
        source: shadowShape
        shadowEnabled: true
        shadowColor: Constants.shadowColor
        shadowOpacity: Constants.shadowOpacity
        shadowBlur: 1.0
        shadowVerticalOffset: 6
    }

    // 2. A blurred copy of whatever is behind the bar
    ShaderEffectSource {
        id: behind
        anchors.fill: parent
        sourceItem: bar.blurSource
        sourceRect: Qt.rect(bar.x - bar.blurSource.x, bar.y - bar.blurSource.y,
                            bar.width, bar.height)
        visible: false
    }
    Rectangle {
        id: pillMask
        anchors.fill: parent
        radius: height / 2
        layer.enabled: true
        visible: false
    }
    MultiEffect {
        anchors.fill: parent
        source: behind
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 1.0
        blurMax: 48
        saturation: 0.4
        maskEnabled: true
        maskSource: pillMask
    }

    // 3. Tint in the theme's color
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Constants.card
        opacity: 0.45
    }

    // 4. Shine: fades from the top edge to the middle
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Constants.glassShine }
            GradientStop { position: 0.5; color: "#00FFFFFF" }
        }
    }

    // 5. Thin bright edge
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: Constants.glassEdge
    }

    // ── The lens: the highlight that slides to the selected tab ──
    Item {
        id: lens
        width: bar.tabWidth
        height: bar.height - 2 * bar.pad

        // Resting: sits on the current tab. Dragging: follows the finger, kept inside the bar.
        x: bar.dragging
           ? Math.max(bar.pad, Math.min(bar.width - bar.pad - width, touch.mouseX - width / 2))
           : bar.pad + bar.currentIndex * bar.tabWidth
        y: bar.pad - (bar.dragging ? 4 : 0)         // lifts a little
        scale: bar.dragging ? 1.18 : 1.0            // grows a little

        Behavior on x { SpringAnimation { spring: 5; damping: 0.5; epsilon: 0.25 } }
        Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 260; easing.type: Easing.OutBack } }

        // Colored body: solid when resting, see-through like glass when dragging
        Rectangle {
            id: lensBody
            anchors.fill: parent
            radius: height / 2
            color: Constants.primary
            opacity: bar.dragging ? 0.55 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Constants.shadowColor
                shadowOpacity: bar.dragging ? 0.35 : 0.0
                shadowBlur: 0.8
                shadowVerticalOffset: 5
            }
        }
        // Shine and bright edge, only visible while dragging
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            opacity: bar.dragging ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            gradient: Gradient {
                GradientStop { position: 0.0; color: Constants.glassShine }
                GradientStop { position: 0.6; color: "#00FFFFFF" }
            }
            border.width: 1
            border.color: Constants.glassEdge
        }
    }

    // ── The labels ──────────────────────────────────────────
    Row {
        x: bar.pad
        y: bar.pad
        height: bar.height - 2 * bar.pad

        Repeater {
            model: bar.tabs

            Text {
                required property int index
                required property string modelData

                width: bar.tabWidth
                height: parent.height
                text: modelData
                color: index === bar.lensIndex ? Constants.primaryForeground : Constants.foreground
                font.pixelSize: Constants.bodySize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }

    // ── Touch: one area for tap and drag ────────────────────
    MouseArea {
        id: touch
        anchors.fill: parent
        onReleased: (mouse) => bar.currentIndex = bar.indexAt(mouse.x)
    }
}
