import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{
    id: root

    signal start(string s1, string s2,string s3,string s4,string s5, string s6,string s7)

    color: "lightgrey"

    Column{
        spacing: 50

        anchors.fill: parent

        width: 329
        height: 348



        Image{
            anchors.horizontalCenter: parent.horizontalCenter
            source: "logo.png"
            fillMode: Image.PreserveAspectFit

        }

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Column{
                id: column1
                spacing: 20

                Row{
                    anchors.right: parent.right
                    spacing: 20
                    Text {
                        text: qsTr("Month")
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: month
                        currentIndex: 0
                        model: ["Random","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Oct","Sep","Nov","Dec"]
                    }
                }

                Row{
                    spacing: 20
                    Text {
                        text: qsTr("Special day")
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id:special_day
                        currentIndex: 0
                        model: ["Random","0.0","0.2","0.4","0.6","0.8","1"]
                    }
                }

                Row{
                    spacing: 20
                    Text {
                        text: qsTr("Visitor type")
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: visitor_type
                        currentIndex: 0
                        model: ["Random","Returning_Visitor","New_Visitor"]
                    }
                }
            }

            Column{
                id: column
                spacing: 20
                Row{
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    spacing: 20
                    Text{
                        text: "Operating system"
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: os
                        currentIndex: 0
                        model:["Random","1","2","3","4","Other"]
                    }

                }
                Row{
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    spacing: 20
                    Text{
                        text: "Browser"
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: browser
                        currentIndex: 0
                        model:["Random","1","2","3","4","Other"]
                    }

                }
                Row{
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    spacing: 20
                    Text{
                        text: "Region"
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: region
                        currentIndex: 0
                        model:["Random","1","2","3","4","5"]
                    }

                }
                Row{
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    spacing: 20
                    Text{
                        text: "Traffic type"
                        font.bold: true
                        font.pointSize: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox{
                        id: traffic_type
                        currentIndex: 0
                        model:["Random","1","2","3","4","Other"]
                    }

                }


            }
        }

        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Wejdź"
            width: 200
            height: 60
            background: Rectangle{
                color: "lightblue"
                radius: 6
            }

            onPressed: {
                start(month.currentText,special_day.currentText,visitor_type.currentText,os.currentText,browser.currentText,region.currentText,traffic_type.currentText)
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
