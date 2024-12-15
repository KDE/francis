// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include <QtGlobal>
#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif
#include <QQuickStyle>
#include <QQuickWindow>
#include <QtQml>

#include <KAboutData>
#include <KLocalizedQmlContext>
#include <KLocalizedString>
#ifdef HAVE_KDBUSADDONS
#include <KDBusService>
#endif

#ifdef Q_OS_WINDOWS
#include <Windows.h>
#endif

#include "version-francis.h"

using namespace Qt::StringLiterals;

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
#else
    QApplication app(argc, argv);
    // Default to org.kde.desktop style unless the user forces another style
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }

#endif
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    KLocalizedString::setApplicationDomain("francis");

    KAboutData aboutData(
        // The program name used internally.
        QStringLiteral("francis"),
        // A displayable program name string.
        i18nc("@title", "Francis"),
        // The program version string.
        QStringLiteral(FRANCIS_VERSION_STRING),
        // Short description of what the app does.
        i18n("Track your time"),
        // The license this code is released under.
        KAboutLicense::GPL_V3,
        // Copyright Statement.
        i18n("© KDE Community"));
    aboutData.addAuthor(i18nc("@info:credit", "Felipe Kinoshita"),
                        i18nc("@info:credit", "Author"),
                        QStringLiteral("kinofhek@gmail.com"),
                        QStringLiteral("https://fhek.gitlab.io"));
    aboutData.addAuthor(i18nc("@info:credit", "Carl Schwan"),
                        i18nc("@info:credit", "Maintainer"),
                        QStringLiteral("carl@carlschwan.eu"),
                        QStringLiteral("https://carlschwan.eu/"));
    aboutData.setBugAddress("https://bugs.kde.org/enter_bug.cgi?product=Francis");
    KAboutData::setApplicationData(aboutData);
    QGuiApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.francis")));

    QQmlApplicationEngine engine;
    KLocalization::setupLocalizedContext(&engine);
    engine.loadFromModule(u"org.kde.francis"_s, u"Main"_s);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

#ifdef HAVE_KDBUSADDONS
    KDBusService service(KDBusService::Unique);
#endif

    return app.exec();
}
