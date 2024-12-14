// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Qt.labs.platform as Labs
import org.kde.kirigami as Kirigami
import org.kde.coreaddons as KCoreAddons

import org.kde.francis

Labs.MenuBar {
    id: menuBar

    Labs.Menu {
        title: i18nc("@menu", "File")

        Labs.MenuItem {
            text: Controller.running ? i18n("Pause") : (Controller.hasStarted ? i18n("Resume") : i18n("Start"))
            icon.name: Controller.running ? "chronometer-pause" : "chronometer-start"
            shortcut: "S"
            onTriggered: Controller.hasStarted ? Controller.toggle() : Controller.start()
        }

        Labs.MenuItem {
            visible: Controller.hasStarted
            text: i18n("Reset")
            icon.name: "chronometer-reset"
            shortcut: "R"
            enabled: Controller.hasStarted
            onTriggered: Controller.reset()
        }

        Labs.MenuItem {
            text: i18nc("@menu-action", "Quit")
            icon.name: "application-exit"
            onTriggered: Qt.quit()
        }
    }

    Labs.Menu {
        title: i18nc("@menu", "Help")

        Labs.MenuItem {
            text: i18nc("@menu-action", "Report Bug…")
            icon.name: "tools-report-bug"
            onTriggered: Qt.openUrlExternally(KCoreAddons.AboutData.bugAddress);
        }

        Labs.MenuItem {
            text: i18nc("@menu-action", "About Francis")
            icon.name: "help-about"
            onTriggered: pageStack.layers.push(Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutPage"))
            enabled: pageStack.layers.depth <= 1
        }
    }
}
