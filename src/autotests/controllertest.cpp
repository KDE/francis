// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: GPL-3.0-or-later

#include <QSignalSpy>
#include <QtTest/QtTest>

#include <controller.h>

class ControllerTest : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase()
    {
    }

    void testToggle()
    {
        Controller controller;
        QVERIFY(!controller.running());
        QCOMPARE(controller.text(), QStringLiteral("25:00"));

        controller.start();
        QVERIFY(controller.running());
        QCOMPARE(controller.text(), QStringLiteral("25:00"));

        controller.toggle();
        QVERIFY(!controller.running());

        controller.toggle();
        QVERIFY(controller.running());

        controller.reset();
        QVERIFY(!controller.running());
        QCOMPARE(controller.text(), QStringLiteral("25:00"));
    }

    void testUpdate()
    {
        Config::self()->setIntervalTime(1);

        Controller controller;
        controller.setMinuteDuration(3);
        QVERIFY(!controller.running());

        controller.start();
        QVERIFY(controller.running());
        QCOMPARE(controller.text(), QStringLiteral("01:00"));

        QSignalSpy spy(&controller, &Controller::textChanged);
        spy.wait(5000);
        QCOMPARE(controller.text(), QStringLiteral("00:02"));

        QSignalSpy spy2(&controller, &Controller::textChanged);
        spy.wait(5000);
        QCOMPARE(controller.text(), QStringLiteral("00:01"));

        QSignalSpy spy3(&controller, &Controller::textChanged);
        spy.wait(5000);
        QCOMPARE(controller.text(), QStringLiteral("00:00"));

        QSignalSpy spy4(&controller, &Controller::textChanged);
        spy.wait(5000);
        QCOMPARE(controller.text(), QStringLiteral("00:14"));
        QVERIFY(controller.onBreak());
    }
};

QTEST_MAIN(ControllerTest)
#include "controllertest.moc"