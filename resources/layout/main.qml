import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import QtQuick.Controls.Material 2.12
import QtQuick.Window 2.2

import "../colors"
import "../string"


ApplicationWindow {
    id: applicationWindow

    visible: true

    Material.theme: Material.Light
    Material.accent: Light.accent
    Material.background: Light.background
    Material.primary: Light.primary
    Material.foreground: Light.foreground

    height: Screen.height / 2
    width: Screen.width / 2

    minimumWidth: Screen.width / 3
    minimumHeight: Screen.height / 3

    StackView {
        id: stack
        initialItem: enterView
        anchors.fill: parent
    }

    Column {
        id: enterView

        Item {
            width: 1
            height: applicationWindow.height / 2 - Screen.height / 10
        }

        Image {
            source: "../svg/mango.svg"
            width: Screen.width / 10; height: Screen.height / 10
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            id: signInBtn
            text: qsTr(String.signIn)
            Material.background: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            id: signUpBtn
            text: qsTr(String.signUp)
            Material.background: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            id: offlineBtn
            text: qsTr(String.offline)
            Material.background: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: switchToMainScreen()
        }
    }

    Component {
        id: todayLayout

        Column {
            height: stack.height
            width: stack.width

            ToolBar {
                id: toolbar
                anchors.left: parent.left
                anchors.right: parent.right
                Material.elevation: 0

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    ToolButton {
                        icon.source: "../svg/slider.svg"
                        onClicked: drawer.open()
                    }

                    TabBar {
                        id: switchBar
                        focus: true

                        TabButton {
                            text: qsTr(String.day)
                            width: implicitWidth
                        }
                        TabButton {
                            text: qsTr(String.week)
                            width: implicitWidth
                        }
                        TabButton {
                            text: qsTr(String.month)
                            width: implicitWidth
                        }
                    }
                }
            }

            Drawer {
                id: drawer
                width: 0.1 * Screen.width
                height: applicationWindow.height
                Column {
                    Button {
                        text: qsTr(String.tasks)
                        Material.background: "transparent"
                        icon.source: "../svg/list.svg"
                    }

                    Button {
                        text: qsTr(String.account)
                        Material.background: "transparent"
                        icon.source: "../svg/account.svg"
                    }

                    Button {
                        text: qsTr(String.settings)
                        Material.background: "transparent"
                        icon.source: "../svg/settings.svg"
                    }
                }

                Button {
                    text: qsTr(String.exit)
                    anchors.bottom: parent.bottom
                    Material.background: "transparent"
                    icon.source: "../svg/exit.svg"
                    onClicked: stack.pop()
                }
            }

            StackLayout {
                id: tabsStack
                width: parent.width
                height: parent.height - toolbar.height

                currentIndex: switchBar.currentIndex

                Item {
                    id: dayItem

                    ListView {
                        id: dayList
                        anchors.fill: parent
                        clip: true

                        model: tasksmodel
                        delegate: Rectangle {
                            width: parent.width
                            height: Screen.height / 9
                            color: Material.background
                            Pane {
                                id: taskcard
                                width: parent.width
                                height: Screen.height / 10

                                Material.elevation: 3
                                Material.background: Light.background

                                Row {
                                    anchors {
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: applicationWindow.width / 3
                                        color: Light.background

                                        Label {
                                            anchors.centerIn: parent
                                            text: model.start
                                        }
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: applicationWindow.width / 3
                                        color: Light.background

                                        Label {
                                            anchors.centerIn: parent
                                            text: model.name
                                        }
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: applicationWindow.width / 3
                                        color: Light.background

                                        Label {
                                            anchors.centerIn: parent
                                            text: model.finish
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Pane {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: Screen.height / 10

                        Material.elevation: 3
                        Material.background: Light.accent

                        RoundButton {
                            anchors.centerIn: parent
                            text: qsTr(String.add)
                            Material.background: Light.background
                            Material.elevation: 0

                            onClicked: addDialog.open()
                        }
                    }

                    Component.onCompleted: tasksmodel.update()

                }

                Item {
                    id: weekItem
                    Pane {
                        anchors.centerIn: parent
                        width: 120
                        height: 120

                        Material.elevation: 6

                        Label {
                            text: qsTr("Coming soon")
                            anchors.centerIn: parent
                        }
                    }
                }

                Item {
                    id: monthItem
                    Pane {
                        anchors.centerIn: parent
                        width: 120
                        height: 120

                        Material.elevation: 6

                        Label {
                            text: qsTr("Coming soon")
                            anchors.centerIn: parent
                        }
                    }
                }

                Dialog {
                    id: addDialog
                    height: applicationWindow.height / 2
                    width: applicationWindow.width / 2
                    anchors.centerIn: parent

                    contentItem: Rectangle {
                        anchors.fill: parent
                        id: dialogRectangle

                        Column {
                            anchors.fill: parent

                            Rectangle {
                                width: dialogRectangle.width
                                height: dialogRectangle.height * 0.8

                                Column {
                                    anchors.centerIn: parent

                                    TextField {
                                        id: name
                                        placeholderText: qsTr(String.name)
                                    }

                                    TextField {
                                        id: start
                                        placeholderText: qsTr(String.start)
                                    }

                                    TextField {
                                        id: finish
                                        placeholderText: qsTr(String.finish)
                                    }
                                }
                            }

                            Rectangle {
                                id: dialogButtonBar
                                width: dialogRectangle.width
                                height: dialogRectangle.height * 0.2

                                RoundButton {
                                    anchors.centerIn: parent
                                    text: qsTr(String.add)
                                    Material.background: Light.background
                                    Material.elevation: 0

                                    onClicked: {
                                        addDialog.close()
                                        tasksmodel.add(name.text, start.text, finish.text)

                                    }
                                }
                            }
                        }


                    }

                }
            }
        }
    }


    function switchToMainScreen() {
        stack.push(todayLayout)
    }
}