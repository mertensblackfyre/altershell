// modules/battery/BatteryPanel.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../../config" as Config
import "../../widgets" as Widgets

Item {
    id: root
    anchors.fill: parent
    anchors.margins: 20

    property real bat: {
        const p = (UPower.displayDevice?.percentage ?? 0);
        return p <= 0.17 ? 0.17 : p;
    }
    property bool charging: UPower.displayDevice?.state === UPowerDeviceState.Charging
    property int percent: Math.round((UPower.displayDevice?.percentage ?? 0) * 100)
    property int powerProfile: 1

   // opacity: parent.height > 150 ? 1 : 0
    Behavior on opacity {
        Widgets.Anim{}
    }

    RowLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Item {
            width: 48
            height: 48
            Widgets.IconButton {
                active: root.powerProfile === 1
                iconText: "energy_savings_leaf"
                pixelSize: 18
                customRadius: 12
                rectColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.20)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.04)
                iconColor: Config.Theme.primary
                iconFallbackColor: Qt.rgba(1, 1, 1, 0.35)
                borderColor: active ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35) : Qt.rgba(1, 1, 1, 0.08)
                onClicked: root.powerProfile = 1
            }
        }

        Item {
            width: 48
            height: 48
            Widgets.IconButton {
                active: root.powerProfile === 2
                iconText: "balance"
                pixelSize: 18
                customRadius: 12
                rectColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.20)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.04)
                iconColor: Config.Theme.primary
                iconFallbackColor: Qt.rgba(1, 1, 1, 0.35)
                borderColor: active ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35) : Qt.rgba(1, 1, 1, 0.08)
                onClicked: root.powerProfile = 2
            }
        }

        Item {
            width: 48
            height: 48
            Widgets.IconButton {
                active: root.powerProfile === 3
                iconText: "bolt"
                pixelSize: 18
                customRadius: 12
                rectColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.20)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.04)
                iconColor: Config.Theme.primary
                iconFallbackColor: Qt.rgba(1, 1, 1, 0.35)
                borderColor: active ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35) : Qt.rgba(1, 1, 1, 0.08)
                onClicked: root.powerProfile = 3
            }
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        height: 70
        width: parent.width * root.bat - 4
        radius: Config.Appearance.rounding.normal
        color: root.charging ? Config.Theme.tertiary : root.percent <= 25 ? Config.Theme.error : "#a6d189"

        Behavior on width {
            Widgets.Anim {}
        }
        Behavior on color {
            Widgets.ColorAnim {}
        }

        Widgets.StyledText {
            id: percentText
            text: root.percent + "%"
            color: Config.Theme.surfaceContainerLowest
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: Config.Appearance.spacing.small
            anchors.leftMargin: Config.Appearance.spacing.small
            font.pixelSize: Config.Appearance.font.size.extraLarge
            font.bold: true
        }

        Widgets.StyledText {
            text: "BAT" + (root.charging ? " ⚡" : "")
            color: Config.Theme.surfaceContainerLowest
            anchors.left: percentText.left
            anchors.top: percentText.bottom
            anchors.topMargin: -4
            font.pixelSize: Config.Appearance.font.size.normal
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 70
        width: parent.width * (1 - root.bat) - 4
        radius: Config.Appearance.rounding.normal
        color: Config.Theme.surfaceContainerHigh
    }
}
