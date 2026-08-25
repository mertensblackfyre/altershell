pragma ComponentBehavior: Bound
import Quickshell
import "modules/bar"
import "modules/popup"

import "modules/popup/components"
import "modules/launcher"
import Quickshell.Io
import "modules/wifi"
import "modules/battery"
import "widgets"
import QtQuick

ShellRoot {
    PanelWindow {
        anchors { left: true; bottom: true; right: true; top: true }
        color: "transparent"
        exclusiveZone: -1
        mask: Region {}
        Border {}
    }

    Bar { id: bar }

    Popup { id: pop }

    // IPC-driven popup — launcher, opened via keybind
    PopupWindow {
        id: ipcPopup
        useIpc: true
        ipcTarget: "win"
        useHoverClose: false
        useCorners: true
        _anchor: "bottom"

        Component { id: launcherComp; AppLauncher { onCloseRequested: ipcPopup.closePanel() } }

        IpcHandler {
            target: "win"
            function toggle(w: string, h: string, anchor: string) {
                  ipcPopup._component = launcherComp
                if (ipcPopup._visible) ipcPopup.closePanel()
                else ipcPopup.openPanel(w, h, anchor)
            }
        }
    }

}
