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
                        anchors.top: todayPanel.bottom
                        width: parent.width
                        height: parent.height - Screen.height / 5
                        maximumFlickVelocity : Screen.height
                        clip: true

                        model: tasksmodel
                        delegate: Rectangle {
                            width: parent.width
                            height: Screen.height / 9
                            color: Material.background
                            Pane {
                                id: taskcard
                                width: parent.width * 0.95
                                height: Screen.height / 10

                                anchors.centerIn: parent

                                Material.elevation: 3
                                Material.background: Light.background

                                Row {
                                    anchors {
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: taskcard.width / 3
                                        color: Light.background

                                        Label {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: model.name
                                            font.family: String.font
                                            font.bold: true
                                            font.pointSize: 16
                                        }
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: taskcard.width / 4
                                        color: Light.background
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: taskcard.width / 4
                                        color: Light.background

                                        Label {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.right: parent.right
                                            text: model.duration
                                            font.family: String.font
                                            font.bold: true
                                            font.pointSize: 12
                                        }
                                    }

                                    Rectangle {
                                        height: taskcard.height
                                        width: taskcard.width / 12
                                        color: Light.background

                                        Label {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.right: parent.right
                                            text: model.time
                                            font.family: String.font
                                            font.pointSize: 12
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Pane {
                        id: todayPanel
                        anchors.top: parent.top
                        width: parent.width
                        height: Screen.height / 10

                        Material.elevation: 3
                        Material.background: Light.background

                        Row {
                            anchors.fill: parent

                            Rectangle {
                                width: Screen.width / 5
                                height: parent.height
                                color: Light.background

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.family: String.font
                                    font.bold: true
                                    font.pointSize: 20
                                    text: qsTr(String.today)
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
                        color: Light.background

                        Column {
                            anchors.fill: parent

                            Rectangle {
                                width: dialogRectangle.width
                                height: dialogRectangle.height * 0.2
                                color: "transparent"

                                TextField {
                                    id: name
                                    anchors.centerIn: parent
                                    width: dialogRectangle.width / 3
                                    placeholderText: qsTr(String.name)
                                }
                            }

                            Rectangle {
                                width: dialogRectangle.width
                                height: dialogRectangle.height * 0.6
                                color: "transparent"

                                Row {
                                    anchors.fill: parent

                                    Rectangle {
                                        height: parent.height
                                        width: parent.width / 2
                                        color: "transparent"

                                        Column {
                                            anchors.fill: parent

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height / 5
                                                color: "transparent"

                                                Text {
                                                    anchors.centerIn: parent
                                                    font.family: String.font
                                                    font.pointSize: 16
                                                    text: qsTr(String.start)
                                                }
                                            }

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height * 0.8
                                                color: "transparent"

                                                Row {
                                                    anchors.centerIn: parent

                                                    Tumbler {
                                                        id: yearStart
                                                        currentIndex: time.get_year() - 2020
                                                        model: getInterval(2020, 2050)
                                                        onCurrentIndexChanged: {
                                                            dayStart.model = getInterval(1,
                                                                            time.get_days_number(yearStart.currentIndex + 2020, monthStart.currentIndex + 1))
                                                        }
                                                    }

                                                    Tumbler {
                                                        id: monthStart
                                                        currentIndex: time.get_month() - 1
                                                        model: getInterval(1, 12)
                                                        onCurrentIndexChanged: {
                                                            dayStart.model = getInterval(1,
                                                                            time.get_days_number(yearStart.currentIndex + 2020, monthStart.currentIndex + 1))
                                                        }
                                                    }

                                                    Tumbler {
                                                        id: dayStart
                                                        currentIndex: time.get_day() - 1
                                                        model: getInterval(1, time.get_current_days_number())
                                                    }

                                                    Tumbler {
                                                        id: hourStart
                                                        currentIndex: time.get_hour()
                                                        model: getInterval(0, 23)
                                                    }

                                                    Tumbler {
                                                        id: minuteStart
                                                        currentIndex: 0
                                                        model: getInterval(0, 59)
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        height: parent.height
                                        width: parent.width / 2
                                        color: "transparent"

                                        Column {
                                            anchors.fill: parent

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height / 5
                                                color: "transparent"

                                                Text {
                                                    anchors.centerIn: parent
                                                    font.family: String.font
                                                    font.pointSize: 16
                                                    text: qsTr(String.finish)
                                                }
                                            }

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height * 0.8
                                                color: "transparent"

                                                Row {
                                                    anchors.centerIn: parent

                                                    Tumbler {
                                                        id: yearFinish
                                                        currentIndex: time.get_year() - 2020
                                                        model: getInterval(2020, 2050)
                                                        onCurrentIndexChanged: {
                                                            dayFinish.model = getInterval(1,
                                                                            time.get_days_number(yearFinish.currentIndex + 2020, monthFinish.currentIndex + 1))
                                                        }
                                                    }

                                                    Tumbler {
                                                        id: monthFinish
                                                        currentIndex: time.get_month() - 1
                                                        model: getInterval(1, 12)
                                                        onCurrentIndexChanged: {
                                                            dayFinish.model = getInterval(1,
                                                                            time.get_days_number(yearFinish.currentIndex + 2020, monthFinish.currentIndex + 1))
                                                        }
                                                    }

                                                    Tumbler {
                                                        id: dayFinish
                                                        currentIndex: time.get_day() - 1
                                                        model: getInterval(1, time.get_current_days_number())
                                                    }

                                                    Tumbler {
                                                        id: hourFinish
                                                        currentIndex: time.get_hour() + 1
                                                        model: getInterval(0, 23)
                                                    }

                                                    Tumbler {
                                                        id: minuteFinish
                                                        currentIndex: 0
                                                        model: getInterval(0, 59)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            }

                            Rectangle {
                                color: "transparent"
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
                                        tasksmodel.add(name.text, createDateStirng(yearStart.currentIndex,
                                                                                    monthStart.currentIndex,
                                                                                    dayStart.currentIndex,
                                                                                    hourStart.currentIndex,
                                                                                    minuteStart.currentIndex),
                                                                  createDateStirng(yearFinish.currentIndex,
                                                                                    monthFinish.currentIndex,
                                                                                    dayFinish.currentIndex,
                                                                                    hourFinish.currentIndex,
                                                                                    minuteFinish.currentIndex))
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
        auth.offline();
        stack.push(todayLayout);
    }

    function getInterval(from, to) {
        var resultList = [];
        for (var x = from; x <= to; ++x) {
            resultList.push(x);
        }
        return resultList;
    }

    function createDateStirng(year, month, day, hour, minute) {
        var yearStr = (year + 2020).toString();
        var monthStr = (month + 1).toString();
        var dayStr = (day + 1).toString();
        var hourStr = hour.toString();
        var minuteStr = minute.toString();

        return yearStr + "-" + monthStr + "-" + dayStr + " " + hourStr + ":" + minuteStr;
    }
}