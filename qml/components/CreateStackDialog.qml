import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: dialog

    Dialog {
        id: dialogue
        title: i18n.tr("How should the stack be named?")
        Rectangle {
            height: units.gu(0.2)
            width: parent.width
            color: UbuntuColors.blue
        }
        TextField {
            id: displaynameTextField
            placeholderText: i18n.tr("Name")
            focus: true
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
                enabled: displaynameTextField.displayText !== "" && displaynameTextField.displayText !== " "
                onClicked: {
                    db.transaction(
                        function(tx) {
                            var res = tx.executeSql( 'SELECT name FROM Stacks WHERE name="' + displaynameTextField.displayText + '" ' )
                            if ( res.rows.length > 0 ) {
                                dialogue.title = i18n.tr("Please choose a name that does not exist yet")
                                return
                            }
                            tx.executeSql( 'INSERT INTO Stacks VALUES( "' + displaynameTextField.displayText + '" )' )
                            PopupUtils.close(dialogue)
                        }
                    )
                    dashPage.update ()
                }
            }
        }
    }
}
