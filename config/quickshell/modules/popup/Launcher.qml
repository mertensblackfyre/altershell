pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config
import "components" as Components
import Quickshell.Wayland

PanelWindow {
    id: win

    property bool _visible: false
    property bool _expand: false
    property int _width: 0
    property int _height: 0

    anchors {
        bottom: true
    }
    exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    aboveWindows: true
    color: "transparent"
    implicitWidth: _width + 50
    implicitHeight: _height
    visible: _visible
    margins.bottom: 8

    Timer {
        id: hideTimer
        interval: 200

        repeat: false
        onTriggered: win.closePanel()
    }

    PopupLayer {
        id: root
        anchors.centerIn: parent
        baseWidth: 0
        baseHeight: 20
        expandHeight: win._height
        expandWidth: win._width

        topRightRadius: Config.Appearance.rounding.normal
        topLeftRadius: Config.Appearance.rounding.normal

        expand: true
        Behavior on implicitHeight {
            SpringAnimation {
                spring: 3
                damping: 0.3
            }
        }
        Behavior on implicitWidth {
            SpringAnimation {
                spring: 3
                damping: 0.3
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
            flipH: true
            flip: true
            anchors.bottom: parent.bottom
            anchors.left: parent.right
        }
        Widgets.Corners {
            flipH: true
            anchors.bottom: parent.bottom
            anchors.right: parent.left
        }

        Loader {
            anchors.fill: parent
            sourceComponent: Component {
                Components.AppLauncher {
                    onCloseRequested: win.closePanel()
                }
            }
        }
    }
    function closePanel() {
        win._expand = false;
        win._width = 0;
        win._height = 0;
    }
    function openPanel(w: string, h: string) {
        hideTimer.stop();
        win._width = parseInt(w) || 450;
        win._height = parseInt(h) || 520;
        win._visible = true;
        win._expand = true;
    }

    IpcHandler {
        target: "win"
        function toggle(w: string, h: string) {
            if (win._visible && win._expand) {
                win.closePanel();
            } else {
                win.openPanel(w, h);
            }
        }
    }
}
