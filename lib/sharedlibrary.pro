QT += core
QT -= gui

TARGET = qttpserver
CONFIG += QTTP_SHARED_LIBRARY
TEMPLATE = lib

message('Including core files')
include($$PWD/../core.pri)
