// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.francis

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

    QQC2.ToolButton {
        visible: Controller.hasStarted

        action: Kirigami.Action {
            text: i18nc("@action:button", "Skip")
            icon.name: "go-next-skip-symbolic"
            shortcut: "N"
            enabled: Controller.hasStarted
            onTriggered: Controller.skip()
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: i18nc("keyboard shortcut", "Skip (N)")
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }

    Item {
        Layout.fillWidth: true
    }

    QQC2.CheckBox {
        text: i18nc("@option:check", "Bypass do not disturb")
        action: QQC2.Action {
            shortcut: "B"
        }
        checked: Config.criticalUrgencyNotification
        checkable: true
        onClicked: {
            checked = !checked;
            Config.criticalUrgencyNotification = checked;
            Config.save();
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
            onTriggered: pageStack.layers.push(Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutPage"))
        }

        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: text
        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
    }
}
