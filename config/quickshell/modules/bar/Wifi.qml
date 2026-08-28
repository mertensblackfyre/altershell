import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../widgets" as Widgets
import "../../services" as Services
import "../wifi" as Wifi
import "../../config" as Config

Item {
    id: root

    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var wifi: wifiDevice as WifiDevice
    property int strength: wifi?.activeAccessPoint?.strength ?? 0
    property bool secured: wifi?.activeAccessPoint?.secured ?? false
    property bool connected: wifiDevice?.connected ?? false

    width: icon.width - Config.Appearance.padding.large
    height: icon.height - Config.Appearance.padding.large

    Layout.alignment: Qt.AlignHCenter

    Widgets.IconButton {
        id: icon
        anchors.centerIn: parent

        iconText: Services.Icons.getNetworkIcon(root.strength, root.secured)
        pixelSize: Config.Appearance.font.size.extraLarge - 8
        customRadius: Config.Appearance.rounding.normal

        rectColor:"transparent"
        rectFallbackColor: rectColor

        iconColor: Config.Theme.primaryOn
        iconFallbackColor: iconColor

        onClicked: {
            Services.ShellState._show("wifi", 450, 520,"bottom left");
        }
    }
}
