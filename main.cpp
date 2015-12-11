#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include "qtquick2applicationviewer.h"

#include "dict.h"
#include "grid.h"

#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Dict::instance()->load(":/input/fr.txt");

    Grid grid(4,4);

    QtQuick2ApplicationViewer viewer;

    QQmlContext *context = viewer.rootContext();
    context->setContextProperty("gridModel", &grid);

    viewer.setMainQmlFile(QStringLiteral("qml/Shuffle/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
