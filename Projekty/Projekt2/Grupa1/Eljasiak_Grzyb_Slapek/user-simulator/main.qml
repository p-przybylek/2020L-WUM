import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12


Window {
    id: window
    visible: true
    width: 800
    height: 600
    color: "white"
    title: qsTr("User simulator")
    visibility: "Windowed"


    property var main_page: MainPage {
        objectName: "MainPage"
        onStart: {
            stackView.push(web_simulator)
        }

    }

    property var web_simulator: WebSimulator {
        objectName: "WebSimulator"
//        onAction: {
//            stackView.push(web_simulator)
//        }
//        onFinish: {
//            stackView.pop()
//        }

    }

    StackView {
        id: stackView
        initialItem: main_page
        anchors.fill: parent
    }
}
