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
    property real targetWidth: (activeSlot === 0 ? slotA.implicitWidth : slotB.implicitWidth)

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
                text: qsTr("%1 Overdue").arg(dynamicBadge.overdueCount),
                icon: "icons/warning.svg",
                textColor: dynamicBadge.overdueCount > 0 ? Constants.overdue : Constants.mutedForeground,
                bgColor: dynamicBadge.overdueCount > 0 ? Qt.rgba(1, 0.12, 0.22, 0.18) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)),
                borderColor: dynamicBadge.overdueCount > 0 ? Qt.rgba(1, 0.12, 0.22, 0.45) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))
            };
        case 1:
            return {
                text: qsTr("%1 Urgent").arg(dynamicBadge.urgentCount),
                icon: "icons/flame.svg",
                textColor: dynamicBadge.urgentCount > 0 ? Constants.urgent : Constants.mutedForeground,
                bgColor: dynamicBadge.urgentCount > 0 ? Qt.rgba(1, 0.57, 0.0, 0.18) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)),
                borderColor: dynamicBadge.urgentCount > 0 ? Qt.rgba(1, 0.57, 0.0, 0.45) : (Constants.isDark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08))
            };
        case 2:
            return {
                text: qsTr("%1 Pending").arg(dynamicBadge.pendingCount),
                icon: "icons/pin.svg",
                textColor: Constants.isDark ? "#FFA066" : "#D45010",
                bgColor: Qt.rgba(1, 0.5, 0.2, 0.14),
                borderColor: Qt.rgba(1, 0.5, 0.2, 0.30)
            };
        case 3:
            return {
                text: qsTr("%1 Due Today").arg(dynamicBadge.dueTodayCount),
                icon: "icons/hourglass.svg",
                textColor: Constants.isDark ? "#70B8FF" : "#1A70D0",
                bgColor: Qt.rgba(0.2, 0.6, 1, 0.14),
                borderColor: Qt.rgba(0.2, 0.6, 1, 0.30)
            };
        default:
            return {
                text: "",
                icon: "",
                textColor: Constants.foreground,
                bgColor: "transparent",
                borderColor: "transparent"
            };
        }
    }

    function applyStickerToSlot(slot, data) {
        slot.text = data.text;
        slot.icon = data.icon;
        slot.textColor = data.textColor;
        slot.bgColor = data.bgColor;
        slot.borderColor = data.borderColor;
    }

    function refreshActiveSlot() {
        if (slideAnim.running) return;
        var data = getStickerData(dynamicBadge.currentIndex);
        if (dynamicBadge.activeSlot === 0) {
            applyStickerToSlot(slotA, data);
        } else {
            applyStickerToSlot(slotB, data);
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
            outTarget = slotA;
            inTarget = slotB;
            dynamicBadge.activeSlot = 1;
        } else {
            applyStickerToSlot(slotA, nextData);
            slotA.y = dynamicBadge.height + 4;
            slotA.opacity = 0.0;
            outTarget = slotB;
            inTarget = slotA;
            dynamicBadge.activeSlot = 0;
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
    }

    // Slot A Capsule
    Rectangle {
        id: slotA
        property alias text: labelA.text
        property alias icon: iconA.source
        property alias textColor: labelA.color
        property alias bgColor: slotA.color
        property alias borderColor: slotA.border.color

        x: 0
        y: 0
        width: implicitWidth
        height: 22
        radius: 11
        implicitWidth: rowA.implicitWidth + 20
        border.width: 1

        Row {
            id: rowA
            anchors.centerIn: parent
            spacing: 5

            Image {
                id: iconA
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                height: 12
                sourceSize.width: 12
                sourceSize.height: 12
                fillMode: Image.PreserveAspectFit
                visible: source !== ""
            }

            Text {
                id: labelA
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 11
                font.bold: true
                font.family: Constants.fontFamily
            }
        }
    }

    // Slot B Capsule
    Rectangle {
        id: slotB
        property alias text: labelB.text
        property alias icon: iconB.source
        property alias textColor: labelB.color
        property alias bgColor: slotB.color
        property alias borderColor: slotB.border.color

        x: 0
        y: dynamicBadge.height + 4
        width: implicitWidth
        height: 22
        radius: 11
        opacity: 0.0
        implicitWidth: rowB.implicitWidth + 20
        border.width: 1

        Row {
            id: rowB
            anchors.centerIn: parent
            spacing: 5

            Image {
                id: iconB
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                height: 12
                sourceSize.width: 12
                sourceSize.height: 12
                fillMode: Image.PreserveAspectFit
                visible: source !== ""
            }

            Text {
                id: labelB
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 11
                font.bold: true
                font.family: Constants.fontFamily
            }
        }
    }
}
