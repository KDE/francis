// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include <QApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>
#include <QQuickWindow>
#include <QQuickStyle>

#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>
#ifdef HAVE_KDBUSADDONS
#include <KDBusService>
#endif

#ifdef Q_OS_WINDOWS
#include <Windows.h>
#endif

constexpr auto APPLICATION_ID = "org.kde.francis";

#include "version-francis.h"
#include "config.h"
#include "app.h"
#include "controller.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

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
                         KAboutLicense::GPL,
                         // Copyright Statement.
                         i18n("© 2022"));
    aboutData.addAuthor(i18nc("@info:credit", "Felipe Kinoshita"), i18nc("@info:credit", "Author"), QStringLiteral("kinofhek@gmail.com"), QStringLiteral("https://fhek.gitlab.io"));
    aboutData.setBugAddress("https://invent.kde.org/fhek/francis/-/issues/new");
    KAboutData::setApplicationData(aboutData);
    QGuiApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.francis")));

    QQmlApplicationEngine engine;

    auto config = Config::self();
    qmlRegisterSingletonInstance(APPLICATION_ID, 1, 0, "Config", config);

    App application;
    qmlRegisterSingletonInstance(APPLICATION_ID, 1, 0, "App", &application);

    qmlRegisterSingletonType(APPLICATION_ID, 1, 0, "About", [](QQmlEngine *engine, QJSEngine *) -> QJSValue {
            qDebug() << "called";
        return engine->toScriptValue(KAboutData::applicationData());
    });

    Controller controller;
    qmlRegisterSingletonInstance(APPLICATION_ID, 1, 0, "Controller", &controller);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

#ifdef HAVE_KDBUSADDONS
    KDBusService service(KDBusService::Unique);
#endif

    // Restore window size and position
    const auto rootObjects = engine.rootObjects();
    for (auto obj : rootObjects) {
        auto view = qobject_cast<QQuickWindow *>(obj);
        if (view) {
            if (view->isVisible()) {
                application.restoreWindowGeometry(view);
            }
            break;
        }
    }

    return app.exec();
}
