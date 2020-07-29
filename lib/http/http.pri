message($$PWD)

HEADERS += \
    $$PWD/include/native/base.h \
    $$PWD/include/native/callback.h \
    $$PWD/include/native/error.h \
    $$PWD/include/native/fs.h \
    $$PWD/include/native/handle.h \
    $$PWD/include/native/http.h \
    $$PWD/include/native/loop.h \
    $$PWD/include/native/native.h \
    $$PWD/include/native/net.h \
    $$PWD/include/native/stream.h \
    $$PWD/include/native/tcp.h \
    $$PWD/include/native/text.h

SOURCES += \
    $$PWD/src/fs.cc \
    $$PWD/src/handle.cc \
    $$PWD/src/http.cc \
    $$PWD/src/loop.cc \
    $$PWD/src/net.cc \
    $$PWD/src/stream.cc \
    $$PWD/src/tcp.cc

INCLUDEPATH += \
    $$PWD/include \
    $$PWD/include/native \
    $$PWD/../libuv/include \
    $$PWD/../http-parser \
    $$PWD/../evt_tls

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
LIBS = $$PWD/../../$$LIBDIR

LIBS += -luv -lhttp_parser

contains(QT, core) {
  HEADERS += $$PWD/qttp/*.h
  SOURCES += $$PWD/qttp/*.cc
  INCLUDEPATH += $$PWD/qttp
}

contains(CONFIG, MINGW) {
    DEFINES += NNATIVE_EXPORT
}

contains(CONFIG, SSL_TLS) {

    DEFINES += SSL_TLS_UV

    HEADERS += $$PWD/../evt_tls/*.h

    SOURCES += \
        $$PWD/../evt_tls/uv_tls.c \
        $$PWD/../evt_tls/evt_tls.c

    INCLUDEPATH += \
        $$PWD/../evt_tls \
        $$PWD/..

    # Currently this is specifically for mac + homebrew soft links.
    macx: {
        message('Adding openSSL libraries')
        # The user should be able to provide the exact location of openssl.
        INCLUDEPATH += /usr/local/opt/openssl/include
        LIBS += -L/usr/local/opt/openssl/lib -lssl -lcrypto
    }
}
