import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../components"

Page {
    anchors.fill: parent
    id: page

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
                var rs = tx.executeSql("SELECT * FROM Cards WHERE stack_id='" + activeStack + "' ORDER BY RANDOM() LIMIT 1")
                frontLabel.text = rs.rows[0].front
                correctBack = rs.rows[0].back
                backTextField.text = ""
                backTextField.focus = true
            }
        )
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

        TextField {
            id: backTextField
            anchors.margins: units.gu(2)
            width: parent.width
            placeholderText: i18n.tr("Answer")
            Keys.onReturnPressed: confirmButton.clicked ()
        }

        Row {
            width: parent.width
            spacing: units.gu(1)
            Button {
                width: (parent.width - units.gu(1)) / 2
                text: i18n.tr("Skip")
                onClicked: nextQuestion ()
            }
            Button {
                id: confirmButton
                width: (parent.width - units.gu(1)) / 2
                text: i18n.tr("Check")
                color: UbuntuColors.green
                onClicked: {
                    var input = backTextField.displayText
                    if ( !settings.caseAndCaseDistinction ) {
                        input = input.toUpperCase()
                    }
                    if ( input === correctBack.toUpperCase() ){
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
            }
        }
    }
}
