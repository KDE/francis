// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include "config.h"

class QTimer;

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text MEMBER m_text NOTIFY textChanged)
    Q_PROPERTY(float percentage MEMBER m_percentage NOTIFY percentageChanged)
    Q_PROPERTY(int pomodoros MEMBER m_pomodoros NOTIFY pomodorosChanged)
    Q_PROPERTY(bool running MEMBER m_running NOTIFY runningChanged)
    Q_PROPERTY(bool hasStarted MEMBER m_hasStarted NOTIFY hasStartedChanged)
    Q_PROPERTY(bool onBreak MEMBER m_onBreak NOTIFY breakChanged)

public:
    explicit Controller(QObject* parent = nullptr);
    ~Controller() override;

    QString text() const;
    Q_SIGNAL void textChanged();

    int pomodoros() const;
    Q_SIGNAL void pomodorosChanged();

    float percentage();
    Q_SIGNAL void percentageChanged();

    bool running() const;
    Q_SIGNAL void runningChanged();

    bool hasStarted() const;
    Q_SIGNAL void hasStartedChanged();

    bool onBreak() const;
    Q_SIGNAL void breakChanged();

    Q_INVOKABLE void start();
    Q_INVOKABLE void toggle();
    Q_INVOKABLE void reset();

    void update();

    void generateText();

private:
    QTimer *m_timer;
    QString m_text;
    float m_percentage;

    int m_pomodoros { 0 };
    int m_changes { 0 };
    int m_seconds { Config::self()->intervalTime() * 60 };
    bool m_running { false };
    bool m_hasStarted { false };
    bool m_onBreak { false };
};
