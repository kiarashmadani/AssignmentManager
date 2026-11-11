pragma Singleton
import QtQuick

// App-wide constants: sizes and the color themes.
// Switch themes by changing themeIndex. Never edit the objects inside "themes".
QtObject {
    // ── Window ──────────────────────────────────────────────
    readonly property int width: 400
    readonly property int height: 720

    // ── Spacing (px) ────────────────────────────────────────
    readonly property int spacing: 8
    readonly property int padding: 16

    // ── Themes ──────────────────────────────────────────────
    // Converted from the OKLCH CSS palettes to hex (QML has no oklch()).
    // Every theme must have exactly the same keys.
    property int themeIndex:2

    readonly property int titleSize: 22
    readonly property int bodySize: 16
    readonly property int captionSize: 13

    readonly property color glassShine: isDark ? "#26FFFFFF" : "#80FFFFFF"
    readonly property color glassEdge: isDark ? "#40FFFFFF" : "#CCFFFFFF"
    readonly property color shadowColor: "#000000"
    readonly property real shadowOpacity: isDark ? 0.5 : 0.18

    readonly property FontLoader persianFont: FontLoader {
            source: "fonts/Vazirmatn-Regular.ttf"
    }

    readonly property string fontFamily: Qt.uiLanguage === "fa"
                        ? persianFont.name
                        : Qt.application.font.family

    readonly property color scrim: "#B3000000"   // dark veil behind sheets (70% black)

    readonly property var themes: [

        // 01. CRIMSON DARK
        {
            name: qsTr("Crimson Dark"),
            dark: true,
            radius: 10,

            background: "#181216",
            foreground: "#FFF0F2",
            card: "#2A1C24",
            cardForeground: "#FFF0F2",

            primary: "#F05270",
            primaryForeground: "#FFFFFF",
            secondary: "#452832",
            secondaryForeground: "#FFDCE4",

            muted: "#241A20",
            mutedForeground: "#C4A6B0",

            accent: "#D99A68",
            accentForeground: "#211711",

            destructive: "#FF5364",
            destructiveForeground: "#FFFFFF",

            border: "#51313F",
            ring: "#F05270",

            sidebar: "#120D12",
            sidebarForeground: "#FFF0F2",
            sidebarPrimary: "#F05270",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#34212D",
            sidebarAccentForeground: "#F5B6C5",
            sidebarBorder: "#392630"
        },

        // 02. VIOLET LIGHT
        {
            name: qsTr("Violet Light"),
            dark: false,
            radius: 12,

            background: "#F3F0FA",
            foreground: "#27213D",
            card: "#FFFFFF",
            cardForeground: "#27213D",

            primary: "#7655D9",
            primaryForeground: "#FFFFFF",
            secondary: "#E6DDF8",
            secondaryForeground: "#513B91",

            muted: "#EBE7F4",
            mutedForeground: "#77708D",

            accent: "#C5B5F5",
            accentForeground: "#30204E",

            destructive: "#D94368",
            destructiveForeground: "#FFFFFF",

            border: "#DDD5EC",
            ring: "#8768E8",

            sidebar: "#EAE5F5",
            sidebarForeground: "#27213D",
            sidebarPrimary: "#7655D9",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#DCD3F1",
            sidebarAccentForeground: "#513B91",
            sidebarBorder: "#D8CFE9"
        },

        // 03. VIOLET DARK
        {
            name: qsTr("Violet Dark"),
            dark: true,
            radius: 12,

            background: "#141020",
            foreground: "#F3EEFF",
            card: "#211A33",
            cardForeground: "#F3EEFF",

            primary: "#B58AFF",
            primaryForeground: "#20152F",
            secondary: "#35274D",
            secondaryForeground: "#E7D8FF",

            muted: "#261F38",
            mutedForeground: "#B5A9CF",

            accent: "#7557AD",
            accentForeground: "#FFFFFF",

            destructive: "#FF6385",
            destructiveForeground: "#FFFFFF",

            border: "#443458",
            ring: "#BD91FF",

            sidebar: "#100C1A",
            sidebarForeground: "#F3EEFF",
            sidebarPrimary: "#B58AFF",
            sidebarPrimaryForeground: "#20152F",
            sidebarAccent: "#302441",
            sidebarAccentForeground: "#DCC8FF",
            sidebarBorder: "#382B4B"
        },

        // 04. NEON LIGHT
        {
            name: qsTr("Neon Light"),
            dark: false,
            radius: 10,

            background: "#F3F6FC",
            foreground: "#17182D",
            card: "#FFFFFF",
            cardForeground: "#17182D",

            primary: "#D600A9",
            primaryForeground: "#FFFFFF",
            secondary: "#E8E9F7",
            secondaryForeground: "#39365E",

            muted: "#E9EDF5",
            mutedForeground: "#626B86",

            accent: "#00BFA5",
            accentForeground: "#062D29",

            destructive: "#E83C50",
            destructiveForeground: "#FFFFFF",

            border: "#D6DCEB",
            ring: "#E000B0",

            sidebar: "#E8ECF7",
            sidebarForeground: "#17182D",
            sidebarPrimary: "#D600A9",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#D1F5EC",
            sidebarAccentForeground: "#087968",
            sidebarBorder: "#D4DCEC"
        },

        // 05. NEON DARK
        {
            name: qsTr("Neon Dark"),
            dark: true,
            radius: 10,

            background: "#090D20",
            foreground: "#F0F3FF",
            card: "#171E38",
            cardForeground: "#F0F3FF",

            primary: "#FF3DBB",
            primaryForeground: "#220B25",
            secondary: "#252E50",
            secondaryForeground: "#E0E8FF",

            muted: "#151B32",
            mutedForeground: "#A0AACB",

            accent: "#35F5D0",
            accentForeground: "#06251F",

            destructive: "#FF5265",
            destructiveForeground: "#FFFFFF",

            border: "#344264",
            ring: "#FF3DBB",

            sidebar: "#070A18",
            sidebarForeground: "#F0F3FF",
            sidebarPrimary: "#FF3DBB",
            sidebarPrimaryForeground: "#220B25",
            sidebarAccent: "#153B43",
            sidebarAccentForeground: "#55F5D9",
            sidebarBorder: "#293451"
        },

        // 06. SUNSET LIGHT
        {
            name: qsTr("Sunset Light"),
            dark: false,
            radius: 12,

            background: "#FFF7ED",
            foreground: "#392A28",
            card: "#FFFFFF",
            cardForeground: "#392A28",

            primary: "#E66B4E",
            primaryForeground: "#FFFFFF",
            secondary: "#F9E4D9",
            secondaryForeground: "#934A3B",

            muted: "#F5EAE1",
            mutedForeground: "#88736A",

            accent: "#E8A85F",
            accentForeground: "#382519",

            destructive: "#D93E4D",
            destructiveForeground: "#FFFFFF",

            border: "#EED9C9",
            ring: "#E66B4E",

            sidebar: "#F6EBDD",
            sidebarForeground: "#392A28",
            sidebarPrimary: "#E66B4E",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#F1D8BD",
            sidebarAccentForeground: "#86502F",
            sidebarBorder: "#E9D5C5"
        },

        // 07. SUNSET DARK
        {
            name: qsTr("Sunset Dark"),
            dark: true,
            radius: 12,

            background: "#1C1420",
            foreground: "#FFF0E8",
            card: "#30212D",
            cardForeground: "#FFF0E8",

            primary: "#FF806B",
            primaryForeground: "#28141B",
            secondary: "#49303C",
            secondaryForeground: "#FFE0D5",

            muted: "#29202B",
            mutedForeground: "#C6A9A8",

            accent: "#FFC078",
            accentForeground: "#352116",

            destructive: "#F05262",
            destructiveForeground: "#FFFFFF",

            border: "#533B49",
            ring: "#FF806B",

            sidebar: "#150F19",
            sidebarForeground: "#FFF0E8",
            sidebarPrimary: "#FF806B",
            sidebarPrimaryForeground: "#28141B",
            sidebarAccent: "#3C2934",
            sidebarAccentForeground: "#FFC078",
            sidebarBorder: "#44303E"
        }

    ]
    readonly property var theme: themes[themeIndex]

    // ── Active theme values (use these in the UI) ───────────
    readonly property string themeName: theme.name
    readonly property bool isDark: theme.dark
    readonly property int radius: theme.radius

    readonly property color background: theme.background
    readonly property color foreground: theme.foreground
    readonly property color card: theme.card
    readonly property color cardForeground: theme.cardForeground
    readonly property color primary: theme.primary
    readonly property color primaryForeground: theme.primaryForeground
    readonly property color secondary: theme.secondary
    readonly property color secondaryForeground: theme.secondaryForeground
    readonly property color muted: theme.muted
    readonly property color mutedForeground: theme.mutedForeground
    readonly property color accent: theme.accent
    readonly property color accentForeground: theme.accentForeground
    readonly property color destructive: theme.destructive
    readonly property color destructiveForeground: theme.destructiveForeground
    readonly property color border: theme.border
    readonly property color ring: theme.ring
    readonly property color sidebar: theme.sidebar
    readonly property color sidebarForeground: theme.sidebarForeground
    readonly property color sidebarPrimary: theme.sidebarPrimary
    readonly property color sidebarPrimaryForeground: theme.sidebarPrimaryForeground
    readonly property color sidebarAccent: theme.sidebarAccent
    readonly property color sidebarAccentForeground: theme.sidebarAccentForeground
    readonly property color sidebarBorder: theme.sidebarBorder

    // ── Old names, so existing files keep working ───────────
    readonly property color windowColor: background
    readonly property color textColor: foreground
    readonly property color accentColor: primary
}
