# Add more folders to ship with the application, here
folder_01.source = qml/Shuffle
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    dict.cpp \
    grid.cpp \
    tile.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    dict.h \
    grid.h \
    tile.h

RESOURCES += \
    resource.qrc

CONFIG += c++11
