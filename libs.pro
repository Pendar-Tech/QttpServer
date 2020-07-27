TEMPLATE = subdirs

SUBDIRS += \
    $$PWD/lib/lib.pro \
    #$$PWD/lib/staticlibrary.pro
    $$PWD/lib/sharedlibrary.pro

CONFIG += ordered
