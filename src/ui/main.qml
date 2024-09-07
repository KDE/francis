// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.14
import QtQml 2.14

import org.kde.kirigami 2.19 as Kirigami
import org.kde.notification 1.0
import org.kde.config as KConfig

import org.kde.francis 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Francis")

    width: Kirigami.Units.gridUnit * 25
    height: Kirigami.Units.gridUnit * 25
    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    KConfig.WindowStateSaver {
        configGroupName: "MainWindow"
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
        urgency: Config.criticalUrgencyNotification ? Notification.CriticalUrgency : Notification.LowUrgency
        title: i18n("Interval Ended")
        text: i18n("Enjoy your break, drink some water.")
        iconName: "appointment-reminder"
    }

    Notification {
        id: breakEndedNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        urgency: Config.criticalUrgencyNotification ? Notification.CriticalUrgency : Notification.LowUrgency
        title: i18n("Break Ended")
        text: i18n("Get back to work.")
        iconName: "appointment-reminder"
    }

    pageStack.initialPage: Kirigami.Page {
        id: page

        padding: 0
        titleDelegate: PageHeader {}

        TapHandler {
            onTapped: Controller.hasStarted ? Controller.toggle() : Controller.start()
        }

        ColumnLayout {
            anchors.centerIn: parent

            Item {
                implicitWidth: circleArc.radiusX * 2 + 10
                implicitHeight: implicitWidth

                Shape {
                    id: circle

                    layer {
                        enabled: true
                        samples: 8
                    }
                    anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    Kirigami.Theme.colorSet: Kirigami.Theme.Button

                    // base circle
                    ShapePath {
                        strokeColor: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.disabledTextColor, "transparent", 0.6);
                        fillColor: "transparent"
                        strokeWidth: 3
                        capStyle: ShapePath.FlatCap
                        PathAngleArc {
                            id: circleArc
                            centerX: circle.width / 2; centerY: circle.height / 2;
                            radiusX: Math.min(root.width * (Kirigami.Settings.isMobile ? 0.3 : 0.25), root.height * (Kirigami.Settings.isMobile ? 0.3 : 0.25)); radiusY: radiusX
                            startAngle: -180
                            sweepAngle: 360
                        }
                    }

                    // progress circle
                    ShapePath {
                        strokeColor: Controller.onBreak ? Kirigami.Theme.textColor : Kirigami.Theme.linkColor
                        fillColor: "transparent"
                        strokeWidth: 7
                        capStyle: ShapePath.RoundCap
                        PathAngleArc {
                            id: arc
                            centerX: circleArc.centerX; centerY: circleArc.centerY
                            radiusX: circleArc.radiusX; radiusY: circleArc.radiusY
                            startAngle: -90 + 360 * Controller.percentage / 100
                            sweepAngle: 360 * (1 - Controller.percentage/100)
                            Behavior on sweepAngle {
                                NumberAnimation{
                                    duration: 1000
                                }
                            }
                        }
                    }
                    ShapePath {
                        strokeColor: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, "transparent", 0.4);
                        fillColor: "transparent"
                        strokeWidth: 5
                        capStyle: ShapePath.RoundCap
                        PathAngleArc {
                            centerX: circleArc.centerX; centerY: circleArc.centerY
                            radiusX: circleArc.radiusX; radiusY: circleArc.radiusY
                            startAngle: -90 + 360 * Controller.percentage / 100
                            sweepAngle: 360 * (1 - Controller.percentage/100)

                            Behavior on sweepAngle {
                                NumberAnimation{

                                    duration: 1000
                                }
                            }
                        }
                    }
                }

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
                                case 2:
                                    return i18n("Lap 3")
                                case 3:
                                    return i18n("Lap 4")
                                default:
                                    return i18n("Lap 1")
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
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 4
                        font.bold: true
                        font.family: "monospace"
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
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

                        text: i18n("I need to focus on…")
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
}
