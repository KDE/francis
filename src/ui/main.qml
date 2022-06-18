// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.14
import QtQml 2.14

import org.kde.kirigami 2.19 as Kirigami

import org.kde.francis 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Francis")

    width: Kirigami.Units.gridUnit * 32
    height: Kirigami.Units.gridUnit * 15
    minimumWidth: Kirigami.Units.gridUnit * 15
    minimumHeight: Kirigami.Units.gridUnit * 15

    //onWidthChanged: console.info(Math.floor(width / 17))
    //onHeightChanged: console.info(Math.floor(height / 17))

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

    Loader {
        active: !Kirigami.Settings.isMobile
        sourceComponent: GlobalMenu {}
    }

    function startTimer() {
        page.diff = page.duration - (((Date.now() - page.start) / 1000) | 0)

        page.minutes = (page.diff / 60) | 0
        page.seconds = (page.diff % 60) | 0

        page.minutes = page.minutes < 10 ? "0" + page.minutes : page.minutes
        page.seconds = page.seconds < 10 ? "0" + page.seconds : page.seconds

        timeText.text = `${page.minutes}:${page.seconds}`

        if (page.diff <= 0) {
            page.breaking = !page.breaking

            page.start = Date.now() + 100
        }
    }

    pageStack.initialPage: Kirigami.Page {
        id: page

        property bool breaking: false

        property int duration: page.breaking ? 60 * 15 : 60 * 25
        property var start: Date.now()
        property int diff
        property string minutes
        property string seconds

        padding: 0
        titleDelegate: PageHeader {}

        Timer {
            id: timer
            interval: 1000
            repeat: true
            running: true

            onTriggered: {
                startTimer()
                timeText.color = page.breaking ? Kirigami.Theme.textColor : Kirigami.Theme.highlightColor
            }
        }

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillHeight: true
            }

            QQC2.Label {
                id: timeText

                Layout.alignment: Qt.AlignCenter

                text: "25:00"
                color: Kirigami.Theme.highlightColor
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 5
                font.bold: true
            }

            QQC2.TextField {
                id: goalText

                Layout.fillWidth: true
                Layout.maximumWidth: root.width - (Kirigami.Units.gridUnit * 4)
                Layout.alignment: Qt.AlignCenter

                wrapMode: Text.Wrap
                horizontalAlignment: Qt.AlignHCenter
                maximumLength: 270
                font.pointSize: Math.round(Kirigami.Theme.defaultFont.pointSize * 1.5)

                onEditingFinished: {
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

//                     HoverHandler {
//                         cursorShape: Qt.IBeamCursor
//                     }
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
