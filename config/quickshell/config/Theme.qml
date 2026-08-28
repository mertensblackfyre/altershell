// config/Theme.qml
pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property color background: "#191113"
    property color backgroundOn: "#efdfe1"
    property color error: "#ffb4ab"
    property color errorContainer: "#93000a"
    property color inverseOnSurface: "#372e30"
    property color inversePrimary: "#8b4a61"
    property color inverseSurface: "#efdfe1"
    property color errorOn: "#690005"
    property color errorContainerOn: "#ffdad6"
    property color primaryOn: "#541d33"
    property color primaryContainer: "#6f3349"
    property color primaryContainerOn: "#ffd9e3"
    property color secondaryOn: "#422931"
    property color secondaryContainerOn: "#ffd9e3"
    property color surface: "#191113"
    property color surfaceOn: "#efdfe1"
    property color surfaceVariantOn: "#d5c2c6"
    property color tertiaryOn: "#48290c"
    property color tertiaryContainerOn: "#ffdcc2"
    property color outline: "#9e8c90"
    property color outlineVariant: "#514347"
    property color primary: "#ffb0c9"
    property color primaryFixed: "#ffd9e3"
    property color secondary: "#e2bdc7"
    property color secondaryContainer: "#5a3f48"
    property color surfaceBright: "#403739"
    property color surfaceContainer: "#261d20"
    property color surfaceContainerHigh: "#31282a"
    property color surfaceContainerHighest: "#3c3235"
    property color surfaceContainerLow: "#22191c"
    property color surfaceContainerLowest: "#140c0e"
    property color surfaceDim: "#191113"
    property color surfaceVariant: "#514347"
    property color tertiary: "#efbc94"
    property color tertiaryContainer: "#623f20"

    property bool isLightMode: false
    property real wallLuminance: 0.5

    property bool transparencyEnabled: true
    property real rawTransparencyBase: 0.85
    property real transparencyLayers: 0.95

    readonly property real transparencyBase: Math.max(0, Math.min(1, root.rawTransparencyBase - (root.isLightMode ? 0.1 : 0)))
    FileView {
        id: colorFile
        path: "/home/mertens/.cache/wal/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            colorFile.reload();
            root._apply();
        }
    }

    function _apply() {
        try {
            const c = JSON.parse(colorFile.text());
            if (!c)
                return;
            root.primary = c.primary ?? root.primary;
            root.background = c.background ?? root.background;
            root.backgroundOn = c.on_background ?? root.backgroundOn;
            root.error = c.error ?? root.error;
            root.errorContainer = c.error_container ?? root.errorContainer;
            root.inverseOnSurface = c.inverse_on_surface ?? root.inverseOnSurface;
            root.inversePrimary = c.inverse_primary ?? root.inversePrimary;
            root.inverseSurface = c.inverse_surface ?? root.inverseSurface;
            root.errorOn = c.on_error ?? root.errorOn;
            root.errorContainerOn = c.on_error_container ?? root.errorContainerOn;
            root.primaryOn = c.on_primary ?? root.primaryOn;
            root.primaryContainer = c.primary_container ?? root.primaryContainer;
            root.primaryContainerOn = c.on_primary_container ?? root.primaryContainerOn;
            root.secondaryOn = c.on_secondary ?? root.secondaryOn;
            root.secondaryContainerOn = c.on_secondary_container ?? root.secondaryContainerOn;
            root.surface = c.surface ?? root.surface;
            root.surfaceOn = c.on_surface ?? root.surfaceOn;
            root.surfaceVariantOn = c.on_surface_variant ?? root.surfaceVariantOn;
            root.tertiaryOn = c.on_tertiary ?? root.tertiaryOn;
            root.tertiaryContainerOn = c.on_tertiary_container ?? root.tertiaryContainerOn;
            root.outline = c.outline ?? root.outline;
            root.outlineVariant = c.outline_variant ?? root.outlineVariant;
            root.primaryFixed = c.primary_fixed ?? root.primaryFixed;
            root.secondary = c.secondary ?? root.secondary;
            root.secondaryContainer = c.secondary_container ?? root.secondaryContainer;
            root.surfaceBright = c.surface_bright ?? root.surfaceBright;
            root.surfaceContainer = c.surface_container ?? root.surfaceContainer;
            root.surfaceContainerHigh = c.surface_container_high ?? root.surfaceContainerHigh;
            root.surfaceContainerHighest = c.surface_container_highest ?? root.surfaceContainerHighest;
            root.surfaceContainerLow = c.surface_container_low ?? root.surfaceContainerLow;
            root.surfaceContainerLowest = c.surface_container_lowest ?? root.surfaceContainerLowest;
            root.surfaceDim = c.surface_dim ?? root.surfaceDim;
            root.surfaceVariant = c.surface_variant ?? root.surfaceVariant;
            root.tertiary = c.tertiary ?? root.tertiary;
            root.tertiaryContainer = c.tertiary_container ?? root.tertiaryContainer;
        } catch (e) {
            console.warn("Theme parse error:", e);
        }
    }

    Component.onCompleted: _apply()
    function getLuminance(c: color): real {
        if (c.r === 0 && c.g === 0 && c.b === 0)
            return 0;
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    function alterColour(c: color, a: real, layerIndex: int): color {
        const luminance = root.getLuminance(c);
        if (luminance === 0)
            return Qt.rgba(c.r, c.g, c.b, a);

        const offset = (!root.isLightMode || layerIndex === 1 ? 1 : -layerIndex / 2) * (root.isLightMode ? 0.2 : 0.3) * (1 - root.transparencyBase) * (1 + root.wallLuminance * (root.isLightMode ? (layerIndex === 1 ? 3 : 1) : 2.5));

        const scale = (luminance + offset) / luminance;

        return Qt.rgba(Math.max(0, Math.min(1, c.r * scale)), Math.max(0, Math.min(1, c.g * scale)), Math.max(0, Math.min(1, c.b * scale)), a);
    }

    function surfaceLayer(c: color, layerIndex: var): color {
        if (!root.transparencyEnabled)
            return c;

        return layerIndex === 0 ? Qt.rgba(c.r, c.g, c.b, root.transparencyBase) : root.alterColour(c, root.transparencyLayers, layerIndex ?? 1);
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }
}
