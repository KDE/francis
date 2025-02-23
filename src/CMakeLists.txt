# SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

add_library(${CMAKE_PROJECT_NAME}_static STATIC)
ecm_add_qml_module(${CMAKE_PROJECT_NAME}_static
    URI "org.kde.${CMAKE_PROJECT_NAME}"
    GENERATE_PLUGIN_SOURCE
)

ecm_target_qml_sources(${CMAKE_PROJECT_NAME}_static SOURCES
    ui/Main.qml
    ui/PageHeader.qml
    ui/GlobalMenu.qml
)

target_sources(${CMAKE_PROJECT_NAME}_static PRIVATE
    controller.cpp
    controller.h
)
kconfig_add_kcfg_files(${CMAKE_PROJECT_NAME}_static GENERATE_MOC config.kcfgc)

target_link_libraries(${CMAKE_PROJECT_NAME}_static PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Svg
    KF6::I18n
    KF6::I18nQml
    KF6::CoreAddons
    KF6::ConfigCore
    KF6::ConfigGui
)

add_executable(${CMAKE_PROJECT_NAME}
    main.cpp
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_PROJECT_NAME}_static
    ${CMAKE_PROJECT_NAME}_staticplugin
    Qt::QuickControls2
)

if (TARGET KF6::DBusAddons)
    target_link_libraries(${CMAKE_PROJECT_NAME}_static PUBLIC Qt6::DBus)
    target_compile_definitions(${CMAKE_PROJECT_NAME}_static PUBLIC -DHAVE_KDBUSADDONS)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE KF6::DBusAddons)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE -DHAVE_KDBUSADDONS)
endif()

if (TARGET Qt6::Widgets)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt6::Widgets)
endif()

install(TARGETS ${CMAKE_PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

if (BUILD_TESTING)
    add_subdirectory(autotests)
endif()
