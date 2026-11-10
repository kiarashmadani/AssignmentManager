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
    property int themeIndex: 6

    readonly property int titleSize: 22
    readonly property int bodySize: 16
    readonly property int captionSize: 13

    readonly property color glassShine: isDark ? "#26FFFFFF" : "#80FFFFFF"
    readonly property color glassEdge: isDark ? "#40FFFFFF" : "#CCFFFFFF"
    readonly property color shadowColor: "#000000"
    readonly property real shadowOpacity: isDark ? 0.5 : 0.18

    readonly property var themes: [
        {
            name: "Crimson Dark",
            dark: true,
            radius: 6,
            background: "#1C1917",
            foreground: "#F5F5F4",
            card: "#292524",
            cardForeground: "#F5F5F4",
            primary: "#B91C1C",
            primaryForeground: "#FAF7F5",
            secondary: "#92400E",
            secondaryForeground: "#FEF3C7",
            muted: "#1F1C1A",
            mutedForeground: "#D6D3D1",
            accent: "#B45309",
            accentForeground: "#FEF3C7",
            destructive: "#EF4444",
            destructiveForeground: "#FFFFFF",
            border: "#44403C",
            ring: "#B91C1C",
            sidebar: "#1C1917",
            sidebarForeground: "#F5F5F4",
            sidebarPrimary: "#B91C1C",
            sidebarPrimaryForeground: "#FAF7F5",
            sidebarAccent: "#B45309",
            sidebarAccentForeground: "#FEF3C7",
            sidebarBorder: "#44403C"
        },
        {
            name: "Violet Light",
            dark: false,
            radius: 8,
            background: "#F5F5FF",
            foreground: "#2A2A4A",
            card: "#FFFFFF",
            cardForeground: "#2A2A4A",
            primary: "#6E56CF",
            primaryForeground: "#FFFFFF",
            secondary: "#E4DFFF",
            secondaryForeground: "#4A4080",
            muted: "#F0F0FA",
            mutedForeground: "#6C6C8A",
            accent: "#D8E6FF",
            accentForeground: "#2A2A4A",
            destructive: "#FF5470",
            destructiveForeground: "#FFFFFF",
            border: "#E0E0F0",
            ring: "#6E56CF",
            sidebar: "#F0F0FA",
            sidebarForeground: "#2A2A4A",
            sidebarPrimary: "#6E56CF",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#D8E6FF",
            sidebarAccentForeground: "#2A2A4A",
            sidebarBorder: "#E0E0F0"
        },
        {
            name: "Violet Dark",
            dark: true,
            radius: 8,
            background: "#0F0F1A",
            foreground: "#E2E2F5",
            card: "#1A1A2E",
            cardForeground: "#E2E2F5",
            primary: "#A48FFF",
            primaryForeground: "#0F0F1A",
            secondary: "#2D2B55",
            secondaryForeground: "#C4C2FF",
            muted: "#222244",
            mutedForeground: "#A0A0C0",
            accent: "#303060",
            accentForeground: "#E2E2F5",
            destructive: "#FF5470",
            destructiveForeground: "#FFFFFF",
            border: "#303052",
            ring: "#A48FFF",
            sidebar: "#1A1A2E",
            sidebarForeground: "#E2E2F5",
            sidebarPrimary: "#A48FFF",
            sidebarPrimaryForeground: "#0F0F1A",
            sidebarAccent: "#303060",
            sidebarAccentForeground: "#E2E2F5",
            sidebarBorder: "#303052"
        },
        {
            name: "Neon Light",
            dark: false,
            radius: 8,
            background: "#F8F9FA",
            foreground: "#0C0C1D",
            card: "#FFFFFF",
            cardForeground: "#0C0C1D",
            primary: "#FF00C8",
            primaryForeground: "#FFFFFF",
            secondary: "#F0F0FF",
            secondaryForeground: "#0C0C1D",
            muted: "#F0F0FF",
            mutedForeground: "#0C0C1D",
            accent: "#00FFCC",
            accentForeground: "#0C0C1D",
            destructive: "#FF3D00",
            destructiveForeground: "#FFFFFF",
            border: "#DFE6E9",
            ring: "#FF00C8",
            sidebar: "#F0F0FF",
            sidebarForeground: "#0C0C1D",
            sidebarPrimary: "#FF00C8",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#00FFCC",
            sidebarAccentForeground: "#0C0C1D",
            sidebarBorder: "#DFE6E9"
        },
        {
            name: "Neon Dark",
            dark: true,
            radius: 8,
            background: "#0C0C1D",
            foreground: "#ECEFF4",
            card: "#1E1E3F",
            cardForeground: "#ECEFF4",
            primary: "#FF00C8",
            primaryForeground: "#FFFFFF",
            secondary: "#1E1E3F",
            secondaryForeground: "#ECEFF4",
            muted: "#151530",
            mutedForeground: "#8085A6",
            accent: "#00FFCC",
            accentForeground: "#0C0C1D",
            destructive: "#FF3D00",
            destructiveForeground: "#FFFFFF",
            border: "#2E2E5E",
            ring: "#FF00C8",
            sidebar: "#0C0C1D",
            sidebarForeground: "#ECEFF4",
            sidebarPrimary: "#FF00C8",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#00FFCC",
            sidebarAccentForeground: "#0C0C1D",
            sidebarBorder: "#2E2E5E"
        },
        {
            name: "Sunset Light",
            dark: false,
            radius: 10,
            background: "#FFF9F5",
            foreground: "#3D3436",
            card: "#FFFFFF",
            cardForeground: "#3D3436",
            primary: "#FF7E5F",
            primaryForeground: "#FFFFFF",
            secondary: "#FFEDEA",
            secondaryForeground: "#B35340",
            muted: "#FFF0EB",
            mutedForeground: "#78716C",
            accent: "#FEB47B",
            accentForeground: "#3D3436",
            destructive: "#E63946",
            destructiveForeground: "#FFFFFF",
            border: "#FFE0D6",
            ring: "#FF7E5F",
            sidebar: "#FFF0EB",
            sidebarForeground: "#3D3436",
            sidebarPrimary: "#FF7E5F",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#FEB47B",
            sidebarAccentForeground: "#3D3436",
            sidebarBorder: "#FFE0D6"
        },
        {
            name: "Sunset Dark",
            dark: true,
            radius: 10,
            background: "#2A2024",
            foreground: "#F2E9E4",
            card: "#392F35",
            cardForeground: "#F2E9E4",
            primary: "#FF7E5F",
            primaryForeground: "#FFFFFF",
            secondary: "#463A41",
            secondaryForeground: "#F2E9E4",
            muted: "#30272C",
            mutedForeground: "#D7C6BC",
            accent: "#FEB47B",
            accentForeground: "#2A2024",
            destructive: "#E63946",
            destructiveForeground: "#FFFFFF",
            border: "#463A41",
            ring: "#FF7E5F",
            sidebar: "#2A2024",
            sidebarForeground: "#F2E9E4",
            sidebarPrimary: "#FF7E5F",
            sidebarPrimaryForeground: "#FFFFFF",
            sidebarAccent: "#FEB47B",
            sidebarAccentForeground: "#2A2024",
            sidebarBorder: "#463A41"
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
