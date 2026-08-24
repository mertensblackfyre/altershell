import Quickshell
import QtQuick
import "../wifi"
import "../bluetooth"
import "../battery"
import "../../services" as Services
import "../../widgets" as Widgets
import "../../config" as Config
import Quickshell.Wayland

PanelWindow {
    id: win
    anchors {
        left: true
        bottom: true
        right: true
        top: true
    }
    exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    aboveWindows: true
    color: "transparent"
    implicitWidth: Services.ShellState.panelWidth + 50

    visible: Services.ShellState.visible || hideTimer.running
    margins.left: 35

    Timer {
        id: hideTimer
        interval: 200

        repeat: false
        onTriggered: Services.ShellState._hide()
    }

    PopupLayer {
        id: root
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 8
        baseWidth: 0
        baseHeight: 20
        expandHeight: Services.ShellState.panelHeight
        expandWidth: Services.ShellState.panelWidth
        expand: Services.ShellState.visible

        topRightRadius: Config.Appearance.rounding.normal

        Behavior on implicitHeight {
                    Widgets.Anim {
                        duration: Config.Appearance.anim.curves.expressiveFastSpatialDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve:Config.Appearance.anim.curves.expressiveFastSpatial
                    }
                }

                Behavior on implicitWidth {

                    Widgets.Anim {
                        duration: Config.Appearance.anim.curves.expressiveFastSpatialDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve:Config.Appearance.anim.curves.expressiveFastSpatial
                    }
                                    }
              HoverHandler {
            id: winHover
            onHoveredChanged: {
                if (!hovered)
                    hideTimer.start();
                else
                    hideTimer.stop();
            }
        }

        Widgets.Corners {
            flip: true
            flipH: true
            anchors.bottom: parent.top
            anchors.left: parent.left
        }

        Widgets.Corners {
            anchors.left: parent.right
            anchors.bottom: parent.bottom
            flip: true
            flipH: true
        }
        Loader {
            anchors.fill: parent
            sourceComponent: {
                switch (Services.ShellState.active) {
                case "wifi":
                    return wifiComponent;
                case "bt":
                    return bluetoothComponent;
                case "battery":
                    return battComponent;
                default:
                    return null;
                }
            }
        }

        Component {
            id: wifiComponent
            NetworkPanel {}
        }
        Component {
            id: bluetoothComponent
            BluetoothPanel {}
        }
        Component {
            id: battComponent
            BatteryPanel {}
        }
    }
}
