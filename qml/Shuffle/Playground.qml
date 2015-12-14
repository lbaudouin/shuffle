import QtQuick 2.0

Rectangle {
    id: root
    width: 480
    height: 640

    signal back()

    property int totalPoints: 0
    property int points: 0
    property string word: ""
    property var wordsFound: []
    property int timeout: 0

    function check(){

        var res = resultsModel.check( root.word );
        switch(res){
        case -1: //Already found
            currentBackground.color = "orange"
            break;
        case 1: //Found
            points += root.word.length
            totalPoints += points;
            timeout += 2*root.word.length;
            currentBackground.color = "green"
            break;
        default: //Not found
            currentBackground.color = "red"
            break;
        }

        points = 0;
        unselectAll();
    }

    function finish(){
        unselectAll();
        undisplayAll();
        root.state = "finished"
    }

    function unselectAll(){
        for(var i=0;i<lettersModel.count;i++){
            lettersModel.get(i).selected = false;
        }
    }

    function undisplayAll(){
        for(var i=0;i<lettersModel.count;i++){
            lettersModel.get(i).display = 0;
        }
    }

    Timer{
        running: timeout>0
        interval: 1000
        repeat: true
        onTriggered:{
            timeout--
            if(timeout==0){
                root.finish()
            }
        }
    }

    Toolbar{
        id: toolbar
        width: parent.width
        height: parent.height * 0.075

        points: totalPoints
        timeout: root.timeout

        onReset: {
            for(var i=0;i<lettersModel.count;i++){
                lettersModel.get(i).letter = "";
                lettersModel.get(i).points = -1;
                lettersModel.get(i).selected = false;
            }
            root.word = ""
            root.points = 0;
            root.totalPoints = 0;
            gridModel.generate();
        }

        onDisplay: {
            gridModel.displaySolutions();
        }

        onSolve: {
            gridModel.solve(text)
        }

        state: root.state
    }

    ListModel{
        id: lettersModel
    }

    ListModel{
        id: resultsModel
        property int total: 0
        property int found: 0

        function check(word){
            word = word.toLowerCase()
            for(var i=0;i<resultsModel.count;i++){
                if(word === resultsModel.get(i).word ){
                    if(resultsModel.get(i).found){
                        console.debug("Already found", word)
                        return -1;
                    }else{
                        resultsModel.get(i).found = true;
                        lengthModel.foundWord(word.length)
                        console.debug("Found",word)
                        resultsModel.found++;
                        return 1;
                    }
                }
            }
            console.debug("Not found", word)
            return 0;
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
            height: (root.state==="finished"||root.state==="solver")?0:(currentBackground.height * 1.1)
            width: parent.width * 0.80
            radius: 3
            clip: true

            Behavior on height {
                NumberAnimation{ duration :250 }
            }

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

                            display: model.display

                            state: root.state===""?"":"small"
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
                                    if(root.points===0){
                                        currentBackground.color = "orange"
                                        root.word = ""
                                    }
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
        anchors.bottom: resultView.top
        width: parent.width
        height: root.state==="solver"?0:(parent.height * 0.075)

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

    ListView{
        id: resultView
        width: parent.width
        anchors.bottom: parent.bottom
        height: 0
        clip: true

        Behavior on height {
            NumberAnimation{ duration :250 }
        }

        model: resultsModel

        delegate: Rectangle{
            width: resultView.width
            height: result.height * 1.2
            color: index%2?"lightgray":"white"
            Text{
                id: result
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 18
                text: word
                color: found?"gray":"black"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.undisplayAll()
                    var m = moves.split(",");
                    for(var i=0;i<m.length;i++){
                        var index = parseInt(m[i]);
                        var s = (i===0?1:((i===m.length-1)?2:3))
                        lettersModel.get( index ).display = s
                    }
                }
            }
        }
    }

    Connections{
        target: gridModel
        onGenerated:{
            if(state!=="solver"){
                root.state = ""
            }
            var temp = gridModel.getTilesJS();
            //console.debug( JSON.stringify( temp ))
            lettersModel.clear()
            for(var i=0;i<temp.length;i++){
                temp[i].letter = temp[i].letter.toUpperCase() || "";
                temp[i].points = temp[i].points || -1;
                temp[i].bonus =  temp[i].bonus  || 0;
                temp[i].selected = temp[i].selected || false;
                temp[i].display = temp[i].display || 0;
                //console.debug( JSON.stringify( temp[i] ))
                lettersModel.append( temp[i] )
            }
            if(state!=="solver"){
                root.timeout = 30
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
                results.words[i].found = false
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

    states: [
        State{
            name: "finished"
            PropertyChanges { target: resultView; height: root.height * 0.6 }
        },
        State{
            name: "solver"
            PropertyChanges { target: resultView; height: root.height * 0.75 }
            PropertyChanges { target: resultsRect; visible: false}
            PropertyChanges { target: root; timeout: -1 }
        }
    ]

    Keys.onBackPressed: {
        event.accepted = true
        back()
    }
}
