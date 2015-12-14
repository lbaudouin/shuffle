import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1

Rectangle {
    id: root
    width: 480
    height: 640

    MainMenu{
        id: mainMenu
        width: parent.width
        height: parent.height

        onSolo: {
            gridModel.generate(4,4)
            root.state = "play"
            playground.forceActiveFocus()
        }

        onSolver: {
            gridModel.generateEmpty(4,4)
            root.state = "play"
            playground.state = "solver"
            playground.forceActiveFocus()
        }
    }


    Playground{
        id: playground
        width: parent.width
        height: parent.height

        x: width

        onBack: {
            state = ""
        }
    }

    states: State {
          name: "play";
          PropertyChanges { target: mainMenu; x: -mainMenu.width;  }
          PropertyChanges { target: playground; x: 0; }
      }

    transitions: Transition{
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
    }
}
