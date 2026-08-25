pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config
import "./components" as Components

import "../wifi"
import Quickshell.Wayland

PanelWindow {
    id: win

    // public API
    property int _width: 0
    property int _height: 0
    property bool _visible: false
    property string _anchor: "bottom"
    property Component _component: null
    property bool useIpc: false
    property string ipcTarget: "win"
    property bool useHoverClose: false
    property bool useCorners: false
    property int cornerAnchor: Qt.BottomEdge

    // anchor config
    anchors.bottom: _anchor === "bottom" || _anchor === "center"
    anchors.top:    _anchor === "top"    || _anchor === "center"
    anchors.left:   _anchor === "left"   || _anchor === "center"
    anchors.right:  _anchor === "right"  || _anchor === "center"

    exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    aboveWindows: true
    color: "transparent"
    implicitWidth: _width + 50
    implicitHeight: _height
    visible: _visible

    margins.bottom: _anchor === "bottom" ? 8 : 0
    margins.top:    _anchor === "top"    ? 8 : 0
    margins.left:   _anchor === "left"   ? 8 : 0
    margins.right:  _anchor === "right"  ? 8 : 0

    Timer {
        id: hideTimer
        interval: 200
        repeat: false
        onTriggered: win.closePanel()
    }

    PopupLayer {
        id: popupLayer
        anchors.centerIn: parent
        baseWidth: 0
        baseHeight: 20
        expandHeight: win._height
        expandWidth: win._width
        expand: win._visible

        topRightRadius:    (win._anchor === "bottom") ? Config.Appearance.rounding.normal : 0
        topLeftRadius:     (win._anchor === "bottom") ? Config.Appearance.rounding.normal : 0
        bottomRightRadius: (win._anchor === "top")    ? Config.Appearance.rounding.normal : 0
        bottomLeftRadius:  (win._anchor === "top")    ? Config.Appearance.rounding.normal : 0

        Behavior on implicitHeight {
            Widgets.Anim {
                duration: Config.Appearance.anim.durations.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.Appearance.anim.curves.expressiveFastSpatial
            }
        }
        Behavior on implicitWidth {
            Widgets.Anim {
                duration: Config.Appearance.anim.durations.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.Appearance.anim.curves.expressiveFastSpatial
            }
        }

        HoverHandler {
            enabled: win.useHoverClose
            onHoveredChanged: {
                if (!hovered) hideTimer.start()
                else hideTimer.stop()
            }
        }

        // corners — only shown when useCorners is true
        Widgets.Corners {
            visible: win.useCorners
            flipH: true
            flip: true
            anchors.bottom: win._anchor === "bottom" ? parent.bottom : undefined
            anchors.top:    win._anchor === "top"    ? parent.top    : undefined
            anchors.left: parent.right
        }

        Widgets.Corners {
            visible: win.useCorners
            flipH: true
            anchors.bottom: win._anchor === "bottom" ? parent.bottom : undefined
            anchors.top:    win._anchor === "top"    ? parent.top    : undefined
            anchors.right: parent.left
        }

        Loader {
            id: loader
            anchors.fill: parent
            sourceComponent: win._component
            onLoaded: {
                if (item.closeRequested)
                    item.closeRequested.connect(win.closePanel)
            }
        }
    }
    

    function openPanel(w, h, anchor) {
        hideTimer.stop()
        win._anchor  = anchor  || "bottom"
        win._width   = parseInt(w) || 450
        win._height  = parseInt(h) || 520
        win._visible = true
    }

    function closePanel() {
        win._visible   = false
        win._width     = 0
        win._height    = 0
        win._component = null
    }

    
}
