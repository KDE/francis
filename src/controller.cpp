// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "controller.h"

#include <QDebug>
#include <QTimer>

Controller::Controller(QObject *parent)
    : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &Controller::update);
    generateText();
}

Controller::~Controller() = default;

QString Controller::text() const
{
    return m_text;
}

int Controller::pomodoros() const
{
    return m_pomodoros;
}

bool Controller::running() const
{
    return m_running;
}

bool Controller::hasStarted() const
{
    return m_hasStarted;
}

bool Controller::onBreak() const
{
    return m_onBreak;
}

void Controller::start()
{
    m_seconds = Config::self()->intervalTime() * 60;
    m_timer->start(1000);

    m_running = true;
    Q_EMIT runningChanged();

    m_hasStarted = true;
    Q_EMIT hasStartedChanged();
}

void Controller::toggle()
{
    if (m_timer->isActive()) {
        m_timer->stop();
        m_running = false;
        Q_EMIT runningChanged();
    } else {
        m_timer->start(1000);
        m_running = true;
        Q_EMIT runningChanged();
    }
}

void Controller::reset()
{
    m_seconds = Config::self()->intervalTime() * 60;
    m_changes = 0;
    m_pomodoros = 0;

    m_hasStarted = false;
    Q_EMIT hasStartedChanged();

    m_running = false;
    Q_EMIT runningChanged();

    m_timer->stop();

    generateText();
}

void Controller::update()
{
    if (m_seconds == 0) {
        if (m_changes == 7) {
            m_changes = 0;

            m_hasStarted = false;
            Q_EMIT hasStartedChanged();

            m_running = false;
            Q_EMIT runningChanged();

            m_timer->stop();
        }

        m_changes++;

        if (m_onBreak) {
            m_pomodoros++;
            Q_EMIT pomodorosChanged();
        }

        m_onBreak = !m_onBreak;
        Q_EMIT breakChanged();

        const int breakTime = m_changes > 5 ? Config::self()->longBreakTime() : Config::self()->breakTime();

        m_seconds = m_onBreak ? breakTime * 60 : Config::self()->intervalTime() * 60;
    }

    generateText();

    m_seconds--;
}

void Controller::generateText()
{
    int minutes = m_seconds / 60;
    int seconds = m_seconds % 60;
    const QString minutesText = minutes < 10 ? QString("0%1").arg(m_seconds / 60) : QString::number(m_seconds / 60);
    const QString secondsText = seconds < 10 ? QString("0%1").arg(m_seconds % 60) : QString::number(m_seconds % 60);

    m_text = QString("%1:%2").arg(minutesText).arg(secondsText);
    Q_EMIT textChanged();
}
