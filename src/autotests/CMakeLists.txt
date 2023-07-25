# SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_test(controllertest.cpp
    TEST_NAME controllertest
    LINK_LIBRARIES francis_static Qt::Test
    NAME_PREFIX "francies-"
)
