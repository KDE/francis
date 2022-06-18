// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

import org.kde.francis 1.0

RowLayout {
    id: pageHeader

    Layout.fillWidth: true
    spacing: 0

    //QQC2.ToolButton {
        //action: Kirigami.Action {
            //text: timer.running ? i18n("Stop Pomodoro") : i18n("Start Pomodoro")
            //icon.name: timer.running ? "chronometer-pause" : "chronometer-start"
            //onTriggered: timer.running ? timer.stop() : timer.start()
        //}

        //QQC2.ToolTip.visible: hovered
        //QQC2.ToolTip.text: text
        //QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    //}

    Item {
        Layout.fillWidth: true
    }

    QQC2.ToolButton {
        display: QQC2.AbstractButton.IconOnly
        action: Kirigami.Action {
            text: i18n("About Francis")
            icon.name: "help-about"
            shortcut: StandardKey.HelpContents
            onTriggered: pageStack.layers.push("About.qml")
            enabled: pageStack.layers.depth <= 1
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: text
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }
}
