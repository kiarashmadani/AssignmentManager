pragma Singleton
import QtQuick

QtObject {
    property int width: 400
    property int height: 720

    property bool isDark: false

    property color windowColor: isDark ? "#121212" : "#F5F5F5"
    property color textColor:   isDark ? "#FFFFFF" : "#202124"
    property color accentColor: isDark ? "#8AB4F8" : "#1A73E8"

    property int radius: 12
    property int spacing: 8
    property int padding: 16
}
