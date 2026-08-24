pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "../../../widgets" as Widgets
import "../../../config" as Config

Item {
    id: root

    property string searchText: ""
    property int selectedIndex: 0
    signal closeRequested

    property var filteredApps: {
        let apps = DesktopEntries.applications.values;
        if (searchText === "")
            return apps;
        const q = searchText.toLowerCase();
        return apps.filter(a => a.name.toLowerCase().includes(q));
    }

    onFilteredAppsChanged: selectedIndex = 0

    Keys.onUpPressed: selectedIndex = Math.max(0, selectedIndex - 1)
    Keys.onDownPressed: selectedIndex = Math.min(filteredApps.length - 1, selectedIndex + 1)
    Keys.onReturnPressed: {
        if (filteredApps[selectedIndex]) {
            filteredApps[selectedIndex].execute();
            searchInput.text = "";
            root.closeRequested();
        }
    }

    Keys.onEscapePressed:{
            root.closeRequested()         }

    Column {
        anchors.fill: parent
        anchors.margins: Config.Appearance.padding.normal
        spacing: Config.Appearance.spacing.normal

        // search bar
        Item {
            id: search
            anchors {
                left: parent.left
                right: parent.right
            }
            implicitHeight: 40

            Rectangle {
                anchors {
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                }
                height: 32
                radius: Config.Appearance.rounding.small
                color: Qt.rgba(1, 1, 1, 0.06)
                border.color: searchInput.activeFocus ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                Behavior on border.color {
                    Widgets.ColorAnim {}
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: searchInput.forceActiveFocus()
                }

                Widgets.StyledText {
                    anchors {
                        left: parent.left
                        leftMargin: Config.Appearance.spacing.small
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Search..."
                    font.pixelSize: Config.Appearance.font.size.normal
                    color: Qt.rgba(1, 1, 1, 0.22)
                    visible: searchInput.text === ""
                }

                TextInput {
                    id: searchInput
                    focus: true
                    activeFocusOnPress: true
                    anchors {
                        left: parent.left
                        leftMargin: Config.Appearance.spacing.small
                        right: parent.right
                        rightMargin: Config.Appearance.spacing.smaller
                        top: parent.top
                        bottom: parent.bottom
                    }
                    verticalAlignment: TextInput.AlignVCenter
                    color: Config.Theme.surfaceOn
                    font.pixelSize: Config.Appearance.font.size.normal
                    selectionColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                    clip: true
                    onTextChanged: root.searchText = text

                    Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                    Keys.onDownPressed: root.selectedIndex = Math.min(root.filteredApps.length - 1, root.selectedIndex + 1)
                    Keys.onReturnPressed: {
                        const app = root.filteredApps[root.selectedIndex];
                        if (app) {
                            app.execute();

                            searchInput.text = "";
                            root.closeRequested();
                        }
                    }
                }
            }
        }

        // app list
        Item {
            width: parent.width
            height: parent.height - search.height - parent.spacing

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: width
                contentHeight: appList.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                function scrollToSelected() {
                    const itemHeight = 42 + Config.Appearance.spacing.small;
                    const itemY = root.selectedIndex * itemHeight;
                    const itemBottom = itemY + 42;

                    if (itemY < contentY)
                        contentY = itemY;
                    else if (itemBottom > contentY + height)
                        contentY = itemBottom - height;
                }

                Column {
                    id: appList
                    width: flick.width
                    spacing: Config.Appearance.spacing.small

                    Repeater {
                        model: root.filteredApps
                        delegate: Item {
                            id: app
                            required property var modelData
                            required property int index
                            implicitWidth: flick.width
                            height: 42

                            // auto scroll to keep selected item visible
                            onIndexChanged: {
                                if (index === root.selectedIndex) {
                                    let itemY = index * (height + Config.Appearance.spacing.small);
                                    if (itemY < flick.contentY)
                                        flick.contentY = itemY;
                                    else if (itemY + height > flick.contentY + flick.height)
                                        flick.contentY = itemY + height - flick.height;
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Config.Appearance.spacing.small
                                anchors.rightMargin: Config.Appearance.spacing.small
                                radius: Config.Appearance.rounding.small
                                color: root.selectedIndex === app.index ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.15) : hov.hovered ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07) : "transparent"
                                border.color: root.selectedIndex === app.index ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.10)
                                border.width: 1
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: Config.Appearance.spacing.normal
                                    anchors.rightMargin: Config.Appearance.spacing.normal
                                    spacing: Config.Appearance.spacing.normal

                                    Image {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 28
                                        height: 28
                                        source: "image://icon/" + app.modelData.icon
                                        sourceSize: Qt.size(28, 28)
                                    }

                                    Widgets.StyledText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: app.modelData.name
                                        font.pixelSize: Config.Appearance.font.size.normal
                                        color: root.selectedIndex === app.index ? Config.Theme.primary : Config.Theme.surfaceOn
                                        width: parent.width - 44
                                        elide: Text.ElideRight
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 100
                                            }
                                        }
                                    }
                                }

                                HoverHandler {
                                    id: hov
                                    onHoveredChanged: if (hovered)
                                        root.selectedIndex = app.index
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        searchInput.text = "";
                                        app.modelData.execute();
                                        root.closeRequested();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: searchInput.forceActiveFocus()
    onSelectedIndexChanged: flick.scrollToSelected()
}
