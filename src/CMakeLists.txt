# SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

add_library(${CMAKE_PROJECT_NAME}_static STATIC)
target_sources(${CMAKE_PROJECT_NAME}_static PUBLIC
    controller.cpp
    controller.h
)
kconfig_add_kcfg_files(${CMAKE_PROJECT_NAME}_static GENERATE_MOC config.kcfgc)

target_link_libraries(${CMAKE_PROJECT_NAME}_static PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::Svg
    KF${QT_MAJOR_VERSION}::I18n
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::ConfigCore
    KF${QT_MAJOR_VERSION}::ConfigGui
    KF${QT_MAJOR_VERSION}::Notifications
)

add_executable(${CMAKE_PROJECT_NAME}
    main.cpp
    app.cpp
    resources.qrc
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_PROJECT_NAME}_static
    Qt::QuickControls2
)

if (NOT ANDROID)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt::Widgets)
endif()

if (TARGET KF${QT_MAJOR_VERSION}::DBusAddons)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE KF${QT_MAJOR_VERSION}::DBusAddons)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE -DHAVE_KDBUSADDONS)
endif()

install(TARGETS ${CMAKE_PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

if (BUILD_TESTING)
    add_subdirectory(autotests)
endif()
