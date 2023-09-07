# SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)

project(francis VERSION 1.0.0)
string(TOUPPER ${CMAKE_PROJECT_NAME} CMAKE_PROJECT_NAME_UPPERCASE)

include(FeatureSummary)

set(QT5_MIN_VERSION 5.15)
set(KF_MIN_VERSION 5.92)
set(KDE_COMPILERSETTINGS_LEVEL "5.82.0")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(ECMAddTests)
include(ECMPoQmTools)
include(ECMDeprecationSettings)
include(KDEClangFormat)
include(KDEGitCommitHooks)

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX ${CMAKE_PROJECT_NAME_UPPERCASE}
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/src/version-${CMAKE_PROJECT_NAME}.h"
)

find_package(Qt${QT_MAJOR_VERSION} ${QT5_MIN_VERSION} REQUIRED COMPONENTS Core Quick Gui Qml QuickControls2 Svg)
find_package(KF${QT_MAJOR_VERSION} ${KF_MIN_VERSION} REQUIRED COMPONENTS Kirigami2 CoreAddons Config I18n Notifications)

if (BUILD_TESTING)
    find_package(Qt${QT_MAJOR_VERSION}Test ${QT5_MIN_VERSION} REQUIRED)
endif()

if (NOT ANDROID AND NOT WIN32 AND NOT APPLE)
    find_package(KF${QT_MAJOR_VERSION}DBusAddons ${KF_MIN_VERSION} REQUIRED)
endif()

if (NOT ANDROID)
    find_package(Qt${QT_MAJOR_VERSION}Widgets REQUIRED)
endif()

find_package(KF${QT_MAJOR_VERSION}KirigamiAddons 0.10 REQUIRED)

ecm_set_disabled_deprecation_versions(QT 6.4.0
    KF 5.102
)

add_subdirectory(src)

ki18n_install(po)

install(PROGRAMS org.kde.${CMAKE_PROJECT_NAME}.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.${CMAKE_PROJECT_NAME}.metainfo.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(FILES org.kde.${CMAKE_PROJECT_NAME}.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES src/*.cpp src/*.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
