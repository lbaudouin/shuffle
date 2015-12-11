import QtQuick 2.0

Rectangle {
    id: root
    width: 480
    height: 640

    property int totalPoints: 0
    property int points: 0
    property string word: ""
    property var wordsFound: []
    property int timeout: 120

    function check(){

        if( resultsModel.check( root.word )){
            totalPoints += points;
            points = 0;
        }

        for(var i=0;i<lettersModel.count;i++){
            lettersModel.get(i).selected = false;
        }

        word = ""
    }

    function finish(){
        console.debug("FINISH", root.totalPoints)
    }

    Timer{
        //running: timeout>0
        interval: 1000
        repeat: true
        onTriggered:{
            timeout--
            if(timeout<=0){
                root.finish()
            }
        }
    }

    Rectangle{
        id: toolbar
        color: "#757575"
        height: 50
        width: parent.width


        Text{
            color: "white"
            text: Math.floor(timeout/60).toString() + ":" + ((timeout%60)<10?("0"+(timeout%60).toString()):(timeout%60).toString())
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Text{
            color: "white"
            text: totalPoints.toString()
            font.pointSize: 18
            font.bold: true

            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                    gridModel.displaySolutions();
                }
            }
        }

        Text{
            color: "white"
            text: "Reset"
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    for(var i=0;i<lettersModel.count;i++){
                        lettersModel.get(i).letter = "";
                        lettersModel.get(i).points = -1;
                        lettersModel.get(i).selected = false;
                    }
                    root.word = ""
                    root.points = 0;
                    root.totalPoints = 0;
                    root.timeout = 119
                    gridModel.generate();
                }
            }
        }
    }

    ListModel{
        id: lettersModel
    }

    ListModel{
        id: resultsModel
        property int total: -1
        property int found: -1

        function check(word){
            word = word.toLowerCase()
            for(var i=0;i<resultsModel.count;i++){
                if(word === resultsModel.get(i).word ){
                    if(resultsModel.get(i).found){
                        console.debug("Already found", word)
                        return false;
                    }else{
                        resultsModel.get(i).found = true;
                        lengthModel.foundWord(word.length)
                        console.debug("Found",word)
                        found++;
                        return true;
                    }
                }
            }
            console.debug("Not found", word)
            return false;
        }

    }

    ListModel{
        id: lengthModel

        function foundWord(length){
            for(var i=0;i<count;i++){
                if(get(i).wordLength === length){
                    get(i).found++;
                }
            }
        }
    }

    Rectangle{
        id: background
        color: "#bdbdbd"
        anchors.top: toolbar.bottom
        anchors.bottom: resultsRect.top
        width: parent.width

        Rectangle {
            id: current
            color: "#e0e0e0"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: currentBackground.height * 1.1
            width: parent.width * 0.80
            radius: 3

            Rectangle{
                id: currentBackground
                color: "orange"
                anchors.centerIn: parent
                height: currentText.height * 1.1
                width: currentText.width * 1.1
                radius: 5

                Text{
                    id: currentText
                    font.pointSize: 25
                    font.bold: true
                    color: "white"
                    text: root.word

                    anchors.centerIn: parent
                }
            }
        }

        Item{
            anchors.top: current.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            Item{
                id: content
                //color: "yellow"
                anchors.centerIn: parent
                width: Math.min(parent.width,parent.height) * 0.75
                height: width
                //border.color: "black"
                //border.width: 2

                property int tileSize: content.width / grid.columns

                Grid{
                    id: grid
                    anchors.fill: parent
                    anchors.margins: 1
                    columns: gridModel.columns
                    rows: gridModel.rows

                    Repeater{
                        model: lettersModel

                        Tile{
                            width: grid.width / grid.columns
                            letter: model.letter || ""
                            points: model.points || -1
                            bonus: model.bonus || 0
                            selected: model.selected
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    enabled: timeout>0

                    property int posX : -1
                    property int posY : -1

                    function posChanged(x,y){
                        if(enabled && posX>=0 && posY>=0){
                            var index = y*grid.columns + x;

                            //console.debug("pos",posX,posY)

                            if(index<lettersModel.count){
                                if(!lettersModel.get(index).selected){
                                    root.word += lettersModel.get(index).letter
                                    root.points += lettersModel.get(index).points
                                    lettersModel.get(index).selected = true;
                                }
                            }
                        }
                    }

                    function mousePosChanged(x,y){

                        var w = content.tileSize
                        var tempPosX = Math.floor(x/w)
                        var tempPosY = Math.floor(y/w)

                        if( tempPosX<0 || tempPosY<0 || tempPosX>=grid.columns || tempPosY>=grid.rows){
                            return;
                        }

                        var near = false;
                        if(posX<0 || posY<0){
                            near = true;
                        }else{
                            if(Math.abs(posX-tempPosX)<=1 && Math.abs(posY-tempPosY)<=1){
                                near = true;
                            }
                        }
                        //console.debug(posX,posY,tempPosX,tempPosY,near)

                        if(posX != tempPosX || posY != tempPosY){
                            if( near && (Math.abs((tempPosX+0.5)*w - x) + Math.abs((tempPosY+0.5)*w - y)) <0.6*w ){

                                var index = tempPosY*grid.columns + tempPosX;
                                if(index<lettersModel.count){
                                    if(!lettersModel.get(index).selected){
                                        posX = tempPosX
                                        posY = tempPosY
                                        posChanged(posX,posY)
                                    }
                                }
                            }
                        }
                    }

                    onPressed: mousePosChanged(mouseX,mouseY);
                    onMouseXChanged: mousePosChanged(mouseX,mouseY);
                    onMouseYChanged: mousePosChanged(mouseX,mouseY);

                    onReleased: {
                        posX = -1;
                        posY = -1;
                        if(enabled )
                            root.check()
                    }
                }
            }
        }
    }


    Rectangle{
        id: resultsRect
        anchors.bottom: parent.bottom
        width: parent.width
        height: 50

        Column{
            width: parent.width
            ResultPerLength{
                length: qsTr("Total")
                found: resultsModel.found
                total: resultsModel.total

                width: parent.width
            }

            Grid{
                width: parent.width
                columns: 5

                Repeater{
                    model: lengthModel
                    ResultPerLength{
                        length: model.wordLength
                        found: model.found
                        total: model.number

                        width: parent.width / 5
                    }
                }
            }
        }
    }

    Connections{
        target: gridModel
        onGenerated:{
            var temp = gridModel.getTilesJS();
            //console.debug( JSON.stringify( temp ))
            lettersModel.clear()
            for(var i=0;i<temp.length;i++){
                temp[i].letter = temp[i].letter.toUpperCase() || "";
                temp[i].points = temp[i].points || -1;
                temp[i].bonus =  temp[i].bonus  || 0;
                temp[i].selected = temp[i].selected || false;
                //console.debug( JSON.stringify( temp[i] ))
                lettersModel.append( temp[i] )
            }
        }
        onResults:{
            //console.debug( JSON.stringify( results ))
            resultsModel.clear();
            resultsModel.total = results.total
            resultsModel.found = 0

            lengthModel.clear()

            var ll = {}

            for(var i=0;i<results.words.length;i++){
                resultsModel.append( results.words[i] )

                var l = results.words[i].word.length

                if(l in ll){
                    ll[l].number = ll[l].number + 1
                }else{
                    ll[l] = {}
                    ll[l].number = 1
                    ll[l].wordLength = l
                    ll[l].found = 0
                }
            }

            for(var k in ll){
                lengthModel.append( ll[k] )
            }
        }
    }

    Component.onCompleted: {
        gridModel.generate()
    }
}
