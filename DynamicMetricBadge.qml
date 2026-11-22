import QtQuick

Item {
    id: dynamicBadge

    property int overdueCount: 0
    property int urgentCount: 0
    property int pendingCount: 0
    property int dueTodayCount: 0

    property int currentIndex: 0
    property int interval: 2000 // Display time per sticker in milliseconds (e.g. 3000 = 3s, 5000 = 5s)
    property int animationDuration: 350 // Slide transition speed in milliseconds

    property int activeSlot: 0
    property real targetWidth: slotA.implicitWidth

    implicitHeight: 22
    implicitWidth: targetWidth
    z: (hoverHandler.hovered || tapHandler.pressed) ? 5 : 1
    clip: true

    Behavior on targetWidth {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    scale: tapHandler.pressed ? 0.94 : (hoverHandler.hovered ? 1.05 : 1.0)
    Behavior on scale {
        SpringAnimation { spring: 5.5; damping: 0.38; mass: 0.8 }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: {
            cycleTimer.restart();
            dynamicBadge.advance();
        }
    }

    function getStickerData(idx: int): var {
        var normalized = ((idx % 4) + 4) % 4;
        switch (normalized) {
        case 0:
            return {
                text: qsTr("\u26A0\uFE0F %1 Overdue").arg(dynamicBadge.overdueCount),
                textColor: dynamicBadge.overdueCount > 0 ? Constants.overdue : Constants.mutedForeground,
                bgColor: dynamicBadge.overdueCount > 0 ? Qt.rgba(1, 0.12, 0.22, 0.18) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)),
                borderColor: dynamicBadge.overdueCount > 0 ? Qt.rgba(1, 0.12, 0.22, 0.45) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))
            };
        case 1:
            return {
                text: qsTr("\uD83D\uDD25 %1 Urgent").arg(dynamicBadge.urgentCount),
                textColor: dynamicBadge.urgentCount > 0 ? Constants.urgent : Constants.mutedForeground,
                bgColor: dynamicBadge.urgentCount > 0 ? Qt.rgba(1, 0.57, 0.0, 0.18) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)),
                borderColor: dynamicBadge.urgentCount > 0 ? Qt.rgba(1, 0.57, 0.0, 0.45) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))
            };
        case 2:
            return {
                text: qsTr("\uD83D\uDCCC %1 Pending").arg(dynamicBadge.pendingCount),
                textColor: Constants.isDark ? "#FFA066" : "#D45010",
                bgColor: Qt.rgba(1, 0.5, 0.2, 0.14),
                borderColor: Qt.rgba(1, 0.5, 0.2, 0.30)
            };
        case 3:
            return {
                text: qsTr("\u23F3 %1 Due Today").arg(dynamicBadge.dueTodayCount),
                textColor: Constants.isDark ? "#70B8FF" : "#1A70D0",
                bgColor: Qt.rgba(0.2, 0.6, 1, 0.14),
                borderColor: Qt.rgba(0.2, 0.6, 1, 0.30)
            };
        default:
            return {
                text: "",
                textColor: Constants.foreground,
                bgColor: "transparent",
                borderColor: "transparent"
            };
        }
    }

    function applyStickerToSlot(slot, data) {
        slot.text = data.text;
        slot.textColor = data.textColor;
        slot.bgColor = data.bgColor;
        slot.borderColor = data.borderColor;
    }

    function refreshActiveSlot() {
        if (slideAnim.running) return;
        var data = getStickerData(dynamicBadge.currentIndex);
        if (dynamicBadge.activeSlot === 0) {
            applyStickerToSlot(slotA, data);
            dynamicBadge.targetWidth = slotA.implicitWidth;
        } else {
            applyStickerToSlot(slotB, data);
            dynamicBadge.targetWidth = slotB.implicitWidth;
        }
    }

    onOverdueCountChanged: refreshActiveSlot()
    onUrgentCountChanged: refreshActiveSlot()
    onPendingCountChanged: refreshActiveSlot()
    onDueTodayCountChanged: refreshActiveSlot()

    property Item outTarget: slotA
    property Item inTarget: slotB

    function advance() {
        if (slideAnim.running) return;
        var nextIdx = (dynamicBadge.currentIndex + 1) % 4;
        var nextData = getStickerData(nextIdx);

        if (dynamicBadge.activeSlot === 0) {
            applyStickerToSlot(slotB, nextData);
            slotB.y = dynamicBadge.height + 4;
            slotB.opacity = 0.0;
            dynamicBadge.targetWidth = slotB.implicitWidth;

            outTarget = slotA;
            inTarget = slotB;
        } else {
            applyStickerToSlot(slotA, nextData);
            slotA.y = dynamicBadge.height + 4;
            slotA.opacity = 0.0;
            dynamicBadge.targetWidth = slotA.implicitWidth;

            outTarget = slotB;
            inTarget = slotA;
        }

        slideAnim.start();
    }

    ParallelAnimation {
        id: slideAnim

        // Outgoing sticker slides up and hides
        NumberAnimation {
            target: dynamicBadge.outTarget
            property: "y"
            to: -dynamicBadge.height - 4
            duration: dynamicBadge.animationDuration
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: dynamicBadge.outTarget
            property: "opacity"
            to: 0.0
            duration: Math.round(dynamicBadge.animationDuration * 0.88)
            easing.type: Easing.InOutQuad
        }

        // Incoming sticker slides up from bottom and appears
        NumberAnimation {
            target: dynamicBadge.inTarget
            property: "y"
            to: 0
            duration: Math.round(dynamicBadge.animationDuration * 1.05)
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: dynamicBadge.inTarget
            property: "opacity"
            to: 1.0
            duration: dynamicBadge.animationDuration
            easing.type: Easing.OutCubic
        }

        onFinished: {
            dynamicBadge.activeSlot = (dynamicBadge.activeSlot === 0 ? 1 : 0);
            dynamicBadge.currentIndex = (dynamicBadge.currentIndex + 1) % 4;
            dynamicBadge.outTarget.y = dynamicBadge.height + 4;
            dynamicBadge.outTarget.opacity = 0.0;
        }
    }

    Timer {
        id: cycleTimer
        interval: dynamicBadge.interval
        running: true
        repeat: true
        onTriggered: dynamicBadge.advance()
    }

    Component.onCompleted: {
        var initialData = getStickerData(0);
        applyStickerToSlot(slotA, initialData);
        slotA.y = 0;
        slotA.opacity = 1.0;
        slotB.y = dynamicBadge.height + 4;
        slotB.opacity = 0.0;
        dynamicBadge.targetWidth = slotA.implicitWidth;
    }

    // Slot A Capsule
    Rectangle {
        id: slotA
        property alias text: labelA.text
        property alias textColor: labelA.color
        property alias bgColor: slotA.color
        property alias borderColor: slotA.border.color

        x: 0
        y: 0
        height: 22
        radius: 11
        implicitWidth: labelA.implicitWidth + 14
        border.width: 1

        Text {
            id: labelA
            anchors.centerIn: parent
            font.pixelSize: 11
            font.bold: true
            font.family: Constants.fontFamily
        }
    }

    // Slot B Capsule
    Rectangle {
        id: slotB
        property alias text: labelB.text
        property alias textColor: labelB.color
        property alias bgColor: slotB.color
        property alias borderColor: slotB.border.color

        x: 0
        y: dynamicBadge.height + 4
        height: 22
        radius: 11
        opacity: 0.0
        implicitWidth: labelB.implicitWidth + 14
        border.width: 1

        Text {
            id: labelB
            anchors.centerIn: parent
            font.pixelSize: 11
            font.bold: true
            font.family: Constants.fontFamily
        }
    }
}
