import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: dialog

    Dialog {
        id: dialogue
        title: i18n.tr("Flashcard")

        Component.onCompleted: {
            if ( activeCardFront !== "" ) {
                db.transaction(
                    function(tx) {
                        var rs = tx.executeSql( 'SELECT back FROM Cards WHERE ' +
                        ' stack_id="' + activeStack + '" AND front="' + activeCardFront + '"' )
                        frontTextField.text = activeCardFront
                        backTextField.text = rs.rows[0].back
                    }
                )
            }
        }

        Rectangle {
            height: units.gu(0.2)
            width: parent.width
            color: UbuntuColors.blue
        }
        TextField {
            id: frontTextField
            placeholderText: i18n.tr("Front")
            focus: true
            Keys.onReturnPressed: backTextField.focus = true
        }
        TextField {
            id: backTextField
            placeholderText: i18n.tr("Back")
            Keys.onReturnPressed: confirmButton.clicked()
        }
        Row {
            width: parent.width
            spacing: units.gu(1)
            Button {
                width: (parent.width - units.gu(1)) / 2
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(dialogue)
            }
            Button {
                id: confirmButton
                width: (parent.width - units.gu(1)) / 2
                text: i18n.tr("Save")
                color: UbuntuColors.green
                onClicked: {
                    db.transaction(
                        function(tx) {
                            tx.executeSql( 'INSERT OR REPLACE INTO Cards ' +
                            'VALUES("' + activeStack + '", "' + frontTextField.displayText + '", "' + backTextField.displayText + '")' )
                            PopupUtils.close(dialogue)
                        }
                    )
                    stackSettingsPage.update ()
                }
            }
        }
    }
}
