// SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "about.h"

KAboutData AboutType::aboutData() const
{
    return KAboutData::applicationData();
}
