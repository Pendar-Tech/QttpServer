QT -= gui core network

TEMPLATE = lib
CONFIG += staticlib
TARGET = uv

!win32 {
    VERSION = 1.10.0
}

include($$PWD/libuv_qmake.pri)

win32 {
    !contains(QMAKE_TARGET.arch, x86_64) {
        LIBDIR = lib_win32_x86
        #message('Targetting x86 Windows')
    } else {
        LIBDIR = lib_win32_x64
        #message('Targetting x64 Windows')
    }
} else:linux {
    arm-linux-gnueabihf-g++ {
        LIBDIR = lib_linux_armv7
        #message('Targetting ARMv7 Linux')
    } else:linux-aarch64-gnu-g++ {
        LIBDIR = lib_linux_aarch64
        #message('Targetting AArch64 Linux')
    } else:contains(QMAKE_TARGET.arch, x86_64) {
        LIBDIR = lib_linux_x64
        #message('Targetting x64 Linux')
    } else {
        message('Unknown Target!')
    }
} else:macx {
    LIBDIR = lib_macos
    #message('Targetting MacOS')
}
DESTDIR = $$PWD/../../$$LIBDIR

macx: {
    LIBS += -framework CoreFoundation # -framework CoreServices
    QMAKE_CXXFLAGS += -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -stdlib=libc++
}

unix:!macx {
    # This supports GCC 4.7
    QMAKE_CXXFLAGS += -lm -lpthread -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
}

win32 {
    QMAKE_CXXFLAGS += -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
    LIBS += \
        -llibuv \
        -lhttp_parser \
        -ladvapi32 \
        -liphlpapi \
        -lpsapi \
        -lshell32 \
        -lws2_32 \
        -luserenv \
        -luser32
}

# Might need to go back and clean up the actual list of included source and
# headers because it looks like we've included some test functions, so in the
# meanwhile we can go ahead and stub them by adding stubs.

SOURCES += $$PWD/workaround.c

win32 {
    # Terrible work-around to include "winapi.h" before "winsock2.h"
    INCLUDEPATH += $$PWD
    HEADERS += $$PWD/uv-win.h $$PWD/uv.h
}

INCLUDEPATH = $$unique(INCLUDEPATH)
HEADERS = $$unique(HEADERS)
SOURCES = $$unique(SOURCES)

# OTHER_FILES += $$PWD/../libuv/include/*.h $$PWD/../libuv/src/unix/*.c
# OTHER_FILES += $$PWD/../libuv/test/*
