import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: dialog

    Dialog {
        id: dialogue
        title: i18n.tr("Are you sure you want to delete this card?")
        Rectangle {
            height: units.gu(0.2)
            width: parent.width
            color: UbuntuColors.blue
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
                width: (parent.width - units.gu(1)) / 2
                text: i18n.tr("Yes")
                color: UbuntuColors.green
                onClicked: {
                    db.transaction(
                        function(tx) {
                            tx.executeSql( 'DELETE FROM Cards WHERE stack_id="' + activeStack + '" AND front="' + activeCardFront + '"' )
                            PopupUtils.close(dialogue)
                        }
                    )
                    stackSettingsPage.update()
                }
            }
        }
    }
}
