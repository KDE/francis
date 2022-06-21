// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QTimer>
#include <QObject>

#include "config.h"

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text MEMBER m_text NOTIFY textChanged)
    Q_PROPERTY(int pomodoros MEMBER m_pomodoros NOTIFY pomodorosChanged)
    Q_PROPERTY(bool running MEMBER m_running NOTIFY runningChanged)
    Q_PROPERTY(bool hasStarted MEMBER m_hasStarted NOTIFY hasStartedChanged)
    Q_PROPERTY(bool onBreak MEMBER m_onBreak NOTIFY onBreakChanged)

public:
    explicit Controller(QObject* parent = nullptr);
    ~Controller() override;

    QString text();
    Q_SIGNAL void textChanged();

    int pomodoros();
    Q_SIGNAL void pomodorosChanged();

    bool running();
    Q_SIGNAL void runningChanged();

    bool hasStarted();
    Q_SIGNAL void hasStartedChanged();

    bool onBreak();
    Q_SIGNAL void onBreakChanged();

    Q_INVOKABLE void start();
    Q_INVOKABLE void toggle();
    Q_INVOKABLE void reset();

    void update();

    void generateText();

private:
    QTimer *m_timer;
    QString m_text;

    int m_pomodoros { 0 };
    int m_changes { 0 };
    int m_seconds { Config::self()->intervalTime() * 60 };
    bool m_running { false };
    bool m_hasStarted { false };
    bool m_onBreak { false };
};
