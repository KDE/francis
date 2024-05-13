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

    Shortcut {
        sequence: StandardKey.Cancel
        enabled: Controller.running
        onActivated: Controller.toggle()
    }

    QQC2.ToolButton {
        action: Kirigami.Action {
            text: Controller.running ? i18n("Pause") : (Controller.hasStarted ? i18n("Resume") : i18n("Start"))
            icon.name: Controller.running ? "chronometer-pause" : "chronometer-start"
            shortcut: "S"
            onTriggered: Controller.hasStarted ? Controller.toggle() : Controller.start()
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: i18nc("keyboard shortcut", "Toggle Timer (S)")
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }

    QQC2.ToolButton {
        visible: Controller.hasStarted

        action: Kirigami.Action {
            text: i18n("Reset")
            icon.name: "chronometer-reset"
            shortcut: "R"
            enabled: Controller.hasStarted
            onTriggered: Controller.reset()
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: i18nc("keyboard shortcut", "Reset (R)")
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }

    Item {
        Layout.fillWidth: true
    }

    QQC2.CheckBox {
        checked: Config.criticalUrgencyNotification
        action: Kirigami.Action {
            text: i18nc("@option:check", "Bypass do not disturb")
            shortcut: "B"
            onTriggered: {
                Config.criticalUrgencyNotification = !checked;
            Config.save();
            }
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: i18nc("keyboard shortcut", "Bypass do not disturb (B)")
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }

    QQC2.ToolButton {
        display: QQC2.AbstractButton.IconOnly
        action: Kirigami.Action {
            text: i18nc("keyboard shortcut", "About Francis (F1)")
            icon.name: "help-about"
            shortcut: StandardKey.HelpContents
            onTriggered: pageStack.pushDialogLayer(Qt.resolvedUrl("About.qml"), {}, {
                maximumWidth: Kirigami.Units.gridUnit * 30
            })
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: text
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }
}
