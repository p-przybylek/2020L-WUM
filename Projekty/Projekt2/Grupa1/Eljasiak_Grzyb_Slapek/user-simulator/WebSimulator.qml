import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{

    property int inf_pages: 0
    property double inf_time_start: 0;
    property double inf_save: 0;

    property int adm_pages: 0
    property double adm_time_start: 0;
    property double adm_save: 0;

    property int pro_pages: 0
    property double pro_time_start: 0;
    property double pro_save: 0;
    signal updateInfo(string column, double time)


    color: "lightgrey"

    Column{
        spacing: 100
        anchors.horizontalCenter: parent.horizontalCenter

        Row{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Month \n" + month
                font.pointSize: 10
            }
            Text {
                text: "Special day \n" + special_day
                font.pointSize: 10
            }
            Text {
                text: "Visitor type \n" + visitor_type
                font.pointSize: 10
            }
            Text {
                text: "Operating system \n" + os
                font.pointSize: 10
            }
            Text {
                text: "Browser \n" + browser
                font.pointSize: 10
            }
            Text {
                text: "Region \n" + region
                font.pointSize: 10
            }
            Text {
                text: "Traffic type \n" + traffic_type
                font.pointSize: 10
            }
        }

        Row{
            spacing: 80
            anchors.horizontalCenter: parent.horizontalCenter

            Column{
                id: column2
                spacing: 20

                Text {
                    text: qsTr("Informational")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                    font.bold: true
                }


                Text {
                    id:inf_time
                    text: "Czas"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                Text {
                    text: "Przejrzano "+ inf_pages + " stron"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button{
                    text: inf_time_start === 0 ? "Przejdz" :  "Nastepna strona"
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked:{
                        pro_time_start = 0
                        adm_time_start = 0
                        if(inf_time_start === 0){
                            inf_time.text = "Counting"
                            inf_time_start = new Date().getSeconds()
                        } else {
                            inf_save = new Date().getSeconds() - inf_time_start+inf_save
                            inf_time.text = "Spędzono " + inf_save +" s"
                        }

                        inf_pages+=1
                        updateInfo("Informational",inf_save)
                    }
                }
            }

            Column{
                id: column
                spacing: 20

                Text {
                    text: qsTr("Administrative")
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }

                Text {
                    id:adm_time
                    text: "Czas"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Przejrzano "+ adm_pages + " stron"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button{
                    text: adm_time_start===0? "Przejdz" :  "Nastepna strona"
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked:{
                        pro_time_start = 0
                        inf_time_start = 0
                        if(adm_time_start === 0){
                            adm_time.text = "Counting"
                            adm_time_start = new Date().getSeconds()
                        } else {
                            adm_save = new Date().getSeconds() - adm_time_start + adm_save
                            adm_time.text = "Spędzono " + adm_save +" s"
                        }

                        adm_pages+=1
                        updateInfo("Administrative",adm_save)
                    }
                }
            }

            Column{
                id: column1
                spacing: 20

                Text {
                    text: qsTr("ProductRelated")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                    font.bold: true
                }



                Text {
                    id:pro_time
                    text: "Czas"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Przejrzano "+ pro_pages + " stron"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button{
                    text: pro_time_start === 0?"Przejdz" :  "Nastepna strona"
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked:{
                        adm_time_start = 0
                        inf_time_start = 0
                        if(pro_time_start === 0){
                            pro_time.text = "Counting"
                            pro_time_start = new Date().getSeconds()
                        } else {
                            pro_save = new Date().getSeconds() - pro_time_start +pro_save
                            pro_time.text = "Spędzono " + pro_save +" s"
                        }

                        pro_pages+=1
                        updateInfo("ProductRelated",pro_save)
                    }
                }
            }

        }

        Row{
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            Column{
                id: column4
                spacing: 30

                Text {
                    text: "Użytkownik z klastra"
                    font.pointSize: 12
                    font.bold: true
                }

                Text {
                    text: cluster_nr
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 10
                }
            }

            Column{
                id: column3
                spacing: 30

                Text {
                    text: "Szansa na zakup"
                    font.pointSize: 12
                    font.bold: true
                }

                Text {
                    text: buy_chance
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 10
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
