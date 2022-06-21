// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.14
import QtQml 2.14

import org.kde.kirigami 2.19 as Kirigami
import org.kde.notification 1.0

import org.kde.francis 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Francis")

    width: Kirigami.Units.gridUnit * 28
    height: Kirigami.Units.gridUnit * 15
    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 15

    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }

    Connections {
        id: saveWindowGeometryConnections
        enabled: false // Disable on startup to avoid writing wrong values if the window is hidden
        target: root

        function onClosing() { App.saveWindowGeometry(root); }
        function onWidthChanged() { saveWindowGeometryTimer.restart(); }
        function onHeightChanged() { saveWindowGeometryTimer.restart(); }
        function onXChanged() { saveWindowGeometryTimer.restart(); }
        function onYChanged() { saveWindowGeometryTimer.restart(); }
    }

    Connections {
        target: Controller

        function onBreakChanged() {
            if (Controller.onBreak) {
                intervalEndedNotification.sendEvent()
            } else {
                breakEndedNotification.sendEvent()
            }
        }
    }

    Loader {
        active: !Kirigami.Settings.isMobile
        sourceComponent: GlobalMenu {}
    }

    Notification {
        id: intervalEndedNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        urgency: Notification.LowUrgency
        title: i18n("Interval Ended")
        text: i18n("Enjoy your break, drink some water.")
        iconName: "appointment-reminder"
    }

    Notification {
        id: breakEndedNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        urgency: Notification.LowUrgency
        title: i18n("Break Ended")
        text: i18n("Get back to work.")
        iconName: "appointment-reminder"
    }

    pageStack.initialPage: Kirigami.Page {
        id: page

        padding: 0
        titleDelegate: PageHeader {}

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillHeight: true
            }

            QQC2.Label {
                Layout.alignment: Qt.AlignCenter

                text: {
                    switch (Controller.pomodoros) {
                        case 1:
                            return i18n("Lap 2")
                            break
                        case 2:
                            return i18n("Lap 3")
                            break
                        case 3:
                            return i18n("Lap 4")
                            break
                        default:
                            return i18n("Lap 1")
                            break
                    }
                }
                font.pointSize: Math.floor(Kirigami.Theme.defaultFont.pointSize * 1.5)
                color: Kirigami.Theme.disabledTextColor
            }

            QQC2.Label {
                id: timeText

                Layout.alignment: Qt.AlignCenter

                text: Controller.text
                color: Controller.onBreak ? Kirigami.Theme.textColor : Kirigami.Theme.linkColor
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 5
                font.bold: true
                font.family: "monospace"
            }

            QQC2.Label {
                visible: Controller.onBreak

                Layout.fillWidth: true
                Layout.maximumWidth: root.width - (Kirigami.Units.gridUnit * 4)
                Layout.preferredHeight: goalText.implicitHeight
                Layout.alignment: Qt.AlignCenter

                text: i18n("Taking a Break")
                wrapMode: Text.Wrap
                horizontalAlignment: Qt.AlignHCenter
                font.pointSize: Math.round(Kirigami.Theme.defaultFont.pointSize * 1.5)
            }

            QQC2.TextField {
                id: goalText

                visible: !Controller.onBreak

                Layout.fillWidth: true
                Layout.maximumWidth: root.width - (Kirigami.Units.gridUnit * 4)
                Layout.alignment: Qt.AlignCenter

                wrapMode: Text.Wrap
                horizontalAlignment: Qt.AlignHCenter
                maximumLength: 78
                font.pointSize: Math.round(Kirigami.Theme.defaultFont.pointSize * 1.5)

                onEditingFinished: {
                    text = text.trim()
                    goalText.focus = false
                }

                background: Item {
                    QQC2.Label {
                        enabled: false
                        visible: !goalText.text && !goalText.activeFocus

                        anchors.centerIn: parent

                        Layout.alignment: Qt.AlignCenter

                        text: i18n("Click to set a goal…")
                        horizontalAlignment: Qt.AlignHCenter

                        color: Kirigami.Theme.disabledTextColor
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Component.onCompleted: {
        if (!Kirigami.Settings.isMobile) {
            saveWindowGeometryConnections.enabled = true
        }
    }
}
