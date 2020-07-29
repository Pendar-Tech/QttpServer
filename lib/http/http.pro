QT -= gui network

# If the core lib is loaded, then we'll automatically compile the Qt-version of
# the HttpServer.
QT += core

TEMPLATE = lib
CONFIG += staticlib
TARGET = node_native

!win32 {
    VERSION = 0.0.1
}

include($$PWD/http.pri)

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
    #CONFIG += c++14
    QMAKE_CXXFLAGS += -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -stdlib=libc++
}

unix:!macx {
    #CONFIG += c++0x
    # This supports GCC 4.7
    QMAKE_CXXFLAGS += -lm -lpthread -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
}

win32 {
    #CONFIG += c++14
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

# For ease and quick reference in QtCreator
# OTHER_FILES += \
#     $$PWD/../libuv/include/*.h \
#     $$PWD/../http-parser/*.h

INCLUDEPATH = $$unique(INCLUDEPATH)
HEADERS = $$unique(HEADERS)
SOURCES = $$unique(SOURCES)
