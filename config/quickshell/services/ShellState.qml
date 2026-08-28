// services/ShellState.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property bool visible: false

    property real panelWidth: 0
    property real panelHeight: 0
    property string active: ""
    property string anchor: "bottom left"

    Timer {
        id: destroyTimer
        interval: 250
        repeat: false
        onTriggered: {
            root.visible = false;
            root.active = "";
        }
    }

    function _show(name, w, h, anch) {
        destroyTimer.stop();
        active = name;
        panelWidth = w;
        panelHeight = h;
        if (anch) anchor = anch;
        visible = true;
    }

    function _hide() {
        panelWidth = 0;
        panelHeight = 0;
        destroyTimer.restart();
    }
}
