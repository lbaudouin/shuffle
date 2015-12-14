import QtQuick 2.0

Rectangle {

    signal solo();
    signal multi();
    signal solver();

    Rectangle{
        id: titleRect
        color: "orange"

        width: parent.width
        height: parent.height * 0.25

        Repeater{
            id: repeater
            property string name: "SHUFFLE"
            property var points: ([1,4,1,4,4,1,1])
            model: name.length

            Tile{
                width: titleRect.width / (repeater.name.length+1)
                letter: repeater.name[index]
                points: repeater.points[index]
                bonus : -1

                x: (index+1) * titleRect.width / (repeater.name.length+2)

                y: parent.y + parent.height/2 + Math.floor((Math.random() * 20)  - 10) - height/2;

                rotation:  Math.floor((Math.random() * 30)  - 15);

            }
        }
    }

    function menuSelected(index){
        switch(index){
        case 0: solo(); break;
        case 1: multi(); break;
        case 2: solver(); break;
        default: break;
        }
    }


    ListModel{
        id: modeModel

        Component.onCompleted: {
            append({"name":qsTr("Solo")});
            append({"name":qsTr("Multi")});
            append({"name":qsTr("Solver")});
        }
    }

    Rectangle{
        id: menu
        color: "red"
        width: parent.width
        anchors.top: titleRect.bottom
        anchors.topMargin: parent.height * 0.1
        anchors.bottom: parent.bottom

        Column{
            width: parent.width
            anchors.centerIn: parent

            spacing: parent.height * 0.05

            Repeater{
                id: menuRepeater
                model: modeModel

                Rectangle{
                    id: subMenu
                    color: "green"
                    width: parent.width
                    height: (menu.height * (1-0.05*modeModel.count)) / modeModel.count

                    Repeater{
                        id: subMenuRepeater
                        property string name: menuRepeater.model.get(index).name.toUpperCase()
                        property var points: gridModel.pointsForWord(menuRepeater.model.get(index).name)
                        model: name.length

                        Tile{
                            //use scale

                            width: subMenu.width / 8
                            letter: subMenuRepeater.name[index]
                            points: subMenuRepeater.points[index]
                            bonus : -1

                            x: (index+1) * subMenu.width / (subMenuRepeater.name.length+2)

                            y: subMenu.height/2 + Math.floor((Math.random() * 20)  - 10) - height/2;

                            rotation:  Math.floor((Math.random() * 30)  - 15);
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: menuSelected(index)
                    }
                }
            }

        }
    }
}
