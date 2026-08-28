pragma ComponentBehavior: Bound
import Quickshell
import "modules/bar"
import "modules/popup"
import "modules/popup/components"
import "modules/wifi"
import "modules/battery"
import "services" as Services
import Quickshell.Io
import "widgets"
import QtQuick

ShellRoot {
    PanelWindow {
        anchors {
            left: true
            bottom: true
            right: true
            top: true
        }
        color: "transparent"
        exclusiveZone: -1
        mask: Region {}
        Border {}
    }

    Bar {
        id: bar
    }
    // Popup { id: pop }

    PopupWindow {
        id: globalPopup
        useCorners: true
        useHoverClose: Services.ShellState.active !== "launcher"

        _visible: Services.ShellState.visible
        _width: Services.ShellState.panelWidth
        _height: Services.ShellState.panelHeight

        anchorBottom: Services.ShellState.anchor.includes("bottom")
        anchorTop: Services.ShellState.anchor.includes("top")
        anchorLeft: Services.ShellState.anchor.includes("left")
        anchorRight: Services.ShellState.anchor.includes("right")

        onRequestClose: Services.ShellState._hide()

        _component: {
            switch (Services.ShellState.active) {
            case "launcher":
                return launcherComp;
            case "wifi":
                return wifiComp;
            case "battery":
                return battComp;
            default:
                return null;
            }
        }

        Component {
            id: launcherComp
            AppLauncher {}
        }
        Component {
            id: wifiComp
            NetworkPanel {}
        }
        Component {
            id: battComp
            BatteryPanel {}
        }
    }

    IpcHandler {
        target: "win"
        function toggle(w: string, h: string, anchor: string) {
            if (Services.ShellState.active === "launcher" && Services.ShellState.visible) {
                Services.ShellState._hide();
            } else {
                Services.ShellState._show("launcher", parseInt(w) || 450, parseInt(h) || 520, anchor || "bottom left");
            }
        }
    }
    /*
    PopupWindow {
        id: ipcPopup
        useIpc: false
        useHoverClose: true
        useCorners: true
        anchorBottom:true

        Component { id: launcherComp; AppLauncher { onCloseRequested: ipcPopup.closePanel() } }

        IpcHandler {
            target: "win"
            function toggle(w: string, h: string, anchor: string) {
                ipcPopup._component = launcherComp
                if (ipcPopup._visible) ipcPopup.closePanel()
                else ipcPopup.openPanel(w, h, anchor || "bottom")
            }
        }
    }

       PopupWindow {
          id: barPopup
          useHoverClose: true
          useIpc: false
          useCorners: true
          anchorBottom:true
          anchorLeft:true

          _visible: Services.ShellState.visible
          _width: Services.ShellState.panelWidth
          _height: Services.ShellState.panelHeight

          _component: {
              switch (Services.ShellState.active) {
                  case "wifi":    return wifiComp
                  case "battery": return battComp
                  default:        return null
              }
          }

          Component { id: wifiComp;    NetworkPanel {}  }
          Component { id: battComp;    BatteryPanel {}  }
      }

      */
}
