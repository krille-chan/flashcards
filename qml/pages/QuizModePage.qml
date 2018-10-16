import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../components"

Page {
    anchors.fill: parent
    id: dashPage

    property var correctCount: 0
    property var failedCount: 0
    property var correctBack: ""
    property var titleInfo: i18n.tr('Now learning %1').arg(activeStack)


    header: PageHeader {
        id: header
        title: i18n.tr('%1 👍<b>%2</b> 👎<b>%3</b>').arg(titleInfo).arg(correctCount).arg(failedCount)
    }

    Component.onCompleted: nextQuestion ()

    function nextQuestion () {
        db.transaction(
            function(tx) {
                var rs = tx.executeSql("SELECT front,back FROM Cards WHERE stack_id='" + activeStack + "' ORDER BY RANDOM() LIMIT 4")
                frontLabel.text = rs.rows[0].front
                correctBack = rs.rows[0].back

                var randomIndex = Math.round( Math.random() * 3 )
                var tempRow = rs.rows[0]
                rs.rows[0] = rs.rows[randomIndex]
                rs.rows[randomIndex] = tempRow

                answer1.text = rs.rows[0].back
                answer2.text = rs.rows[1].back
                answer3.text = rs.rows[2].back
                answer4.text = rs.rows[3].back
            }
        )
    }

    function check ( answer ) {
        if ( !settings.caseAndCaseDistinction ) {
            answer = answer.toUpperCase()
        }
        if ( answer === correctBack.toUpperCase() ){
            correctCount++
            titleInfo = i18n.tr('<font color="#00FF00">That was correct!</font>')
        }
        else {
            failedCount++
            titleInfo = i18n.tr('<font color="#FF0000">Sorry... that was wrong!</font>')
            toast.show ( i18n.tr('Correct solution: %1').arg(correctBack) )
        }
        nextQuestion ()
    }

    Label {
        id: frontLabel
        anchors.margins: units.gu(2)
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - units.gu(4)
        height: parent.height / 2
        wrapMode: Text.Wrap
        textSize: Label.Large
        horizontalAlignment: Text.AlignHCenter
    }

    Column {
        width: parent.width - units.gu(4)
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: units.gu(2)
        anchors.leftMargin: units.gu(2)
        spacing: units.gu(2)

        Button {
            id: answer1
            width: parent.width
            color: UbuntuColors.green
            font.bold: true
            text: ""
            onClicked: check ( text )
        }
        Button {
            id: answer2
            width: parent.width
            color: UbuntuColors.green
            font.bold: true
            text: ""
            onClicked: check ( text )
        }
        Button {
            id: answer3
            width: parent.width
            color: UbuntuColors.green
            font.bold: true
            text: ""
            onClicked: check ( text )
        }
        Button {
            id: answer4
            width: parent.width
            color: UbuntuColors.green
            font.bold: true
            text: ""
            onClicked: check ( text )
        }
    }
}
