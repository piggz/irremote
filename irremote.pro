# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = irremote

CONFIG += sailfishapp

SOURCES += src/IRRemote.cpp \
    src/consumerirdevice.cpp \
    src/templatelistmodel.cpp \
    src/fileio.cpp

OTHER_FILES += qml/IRRemote.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    translations/*.ts \
    IRRemote.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
CONFIG += link_pkgconfig
PKGCONFIG += android-headers libhardware
LIBS += -lsailfishapp

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/IRRemote-de.ts

HEADERS += \
    src/consumerirdevice.h \
    src/templatelistmodel.h \
    src/fileio.h

DISTFILES += \
    qml/pages/TemplatesPage.qml \
    templates/samsung.irtemplate \
    rpm/irremote.yaml \
    rpm/irremote.spec \
    rpm/irremote.changes.in


templates.path=/usr/share/irremote/irremote
templates.files = templates/*

INSTALLS += templates
