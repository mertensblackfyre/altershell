pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config
import Quickshell.Wayland

PanelWindow {
    id: win

    property int _width: 0
    property int _height: 0
    property bool _visible: false
    property Component _component: null
    property string ipcTarget: "win"
    property bool useHoverClose: false
    property bool useCorners: false
    property int cornerAnchor: Qt.BottomEdge
    property bool anchorBottom: false
    property bool anchorTop: false
    property bool anchorLeft: false
    property bool anchorRight: false

    anchors.bottom: anchorBottom
    anchors.top: anchorTop
    anchors.left: anchorLeft
    anchors.right: anchorRight

    exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    aboveWindows: true
    color: "transparent"
    implicitWidth: _width
    implicitHeight: _height
    visible: _visible

    margins.bottom: anchorBottom ? 8 : 0
    margins.top: anchorTop ? 8 : 0
    margins.left: anchorLeft?35:0
    margins.right: anchorRight ? 8 : 0

    signal requestClose()

    Timer {
        id: hideTimer
        interval: 200
        repeat: false
        onTriggered: win.requestClose()
    }

    PopupLayer {
        id: popupLayer
        anchors.centerIn: parent
        baseWidth: 0
        baseHeight: 20
        expandHeight: win._height
        expandWidth: win._width
        expand: win._visible
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top


        topRightRadius: (win.anchorBottom) ? Config.Appearance.rounding.normal : 0
        topLeftRadius: (win.anchorBottom) ? Config.Appearance.rounding.normal : 0
        bottomRightRadius: (win.anchorTop) ? Config.Appearance.rounding.normal : 0
        bottomLeftRadius: (win.anchorTop) ? Config.Appearance.rounding.normal : 0

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
                if (!hovered)
                    hideTimer.start();
                else
                    hideTimer.stop();
            }
        }
                Widgets.Corners {
                    z: 999
                             visible: true 
                    flip: true
                    flipH: true 
                    anchors.bottom: popupLayer.top
                    anchors.left: popupLayer.left
                }

                Widgets.Corners {
                    flip: true
                    flipH: true
                    anchors.top: popupLayer.bottom
                    anchors.left: popupLayer.left
                }
        Loader {
            anchors.fill: parent
            sourceComponent: win._component
            onLoaded: {
                            if (item.closeRequested)
                                item.closeRequested.connect(win.requestClose)
                        }
        }
    }


}
