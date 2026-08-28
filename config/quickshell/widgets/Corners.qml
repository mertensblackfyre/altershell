// widgets/Corners.qml
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import "../config" as Config
import "../widgets" as Widgets

Item {
    id: root
    property bool flip: false
    property bool flipH: false
    width: 50
    height:width

    Behavior on y {
        Widgets.Anim {}
    }
    Behavior on x {
        Widgets.Anim {}
    }

    Rectangle {

        anchors.right: root.flip ? undefined : parent.right
        anchors.left: root.flip ? parent.left : undefined
        anchors.top: root.flipH ? undefined : parent.top
        anchors.bottom: root.flipH ? parent.bottom : undefined

        //color: Config.Theme.background
        color :"red"

        implicitWidth: parent.width / 2
        implicitHeight: parent.height / 2
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        maskSource: mask
        maskEnabled: true
        maskInverted: true
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
    }

    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: 100
        }
    }
}
