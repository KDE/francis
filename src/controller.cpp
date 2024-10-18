// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "controller.h"

#include <QDebug>
#include <QTimer>
#include <qstringliteral.h>

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

float Controller::percentage()
{
    return m_percentage;
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

void Controller::setMinuteDuration(int duration)
{
    m_minuteDuration = duration;
}

void Controller::start()
{
    m_seconds = Config::self()->intervalTime() * m_minuteDuration;

    startTimer();
}

void Controller::toggle()
{
    m_timer->isActive() ? stopTimer() : startTimer();
}

void Controller::reset()
{
    resetInternal();
    generateText();
}

void Controller::skip()
{
    stopTimer();
    goToNextRound();
    generateText();
}

void Controller::startTimer()
{
    if (!m_timer->isActive()) {
        m_timer->start(1000);
    }

    if (!m_running) {
        m_running = true;
        Q_EMIT runningChanged();
    }

    if (!m_hasStarted) {
        m_hasStarted = true;
        Q_EMIT hasStartedChanged();
    }
}

void Controller::stopTimer()
{
    if (m_timer->isActive()) {
        m_timer->stop();
    }

    if (m_running) {
        m_running = false;
        Q_EMIT runningChanged();
    }
}

void Controller::goToNextRound()
{
    if (m_changes == 7) {
        resetInternal();
        return;
    }

    m_changes++;

    if (m_onBreak) {
        m_pomodoros++;
        Q_EMIT pomodorosChanged();
    }

    m_onBreak = !m_onBreak;
    Q_EMIT breakChanged();

    const int breakTime = m_changes > 5 ? Config::self()->longBreakTime() : Config::self()->breakTime();

    m_seconds = m_onBreak ? breakTime * m_minuteDuration : Config::self()->intervalTime() * m_minuteDuration;
}

void Controller::resetInternal()
{
    stopTimer();

    m_seconds = Config::self()->intervalTime() * m_minuteDuration;
    m_changes = 0;

    if (m_pomodoros > 0) {
        m_pomodoros = 0;
        Q_EMIT pomodorosChanged();
    }

    if (m_hasStarted) {
        m_hasStarted = false;
        Q_EMIT hasStartedChanged();
    }

    if (m_onBreak) {
        m_onBreak = false;
        Q_EMIT breakChanged();
    }
}

void Controller::update()
{
    if (m_seconds == 0) {
        goToNextRound();
    }

    m_seconds--;

    generateText();
}

void Controller::generateText()
{
    int minutes = m_seconds / 60;
    int seconds = m_seconds % 60;
    const QString minutesText = minutes < 10 ? QStringLiteral("0%1").arg(m_seconds / 60) : QString::number(m_seconds / 60);
    const QString secondsText = seconds < 10 ? QStringLiteral("0%1").arg(m_seconds % 60) : QString::number(m_seconds % 60);

    m_percentage = m_onBreak ? ((float(Config::breakTime()) * 60 - m_seconds)) / (float(Config::breakTime()) * 60) * 100
                             : ((float(Config::intervalTime()) * 60 - m_seconds)) / (float(Config::intervalTime()) * 60) * 100;
    m_text = QStringLiteral("%1:%2").arg(minutesText, secondsText);
    Q_EMIT textChanged();
    Q_EMIT percentageChanged();
}
