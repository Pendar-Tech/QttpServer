QT += core
QT -= gui

TARGET = qttpserver
CONFIG += staticlib
TEMPLATE = lib

message('Including core files')
include($$PWD/../core.pri)
