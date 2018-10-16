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
            id: nameTextField
            placeholderText: i18n.tr("Name")
            focus: true
            text: activeStack
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
                enabled: nameTextField.displayText !== "" && nameTextField.displayText !== " "
                onClicked: {
                    db.transaction(
                        function(tx) {
                            tx.executeSql( 'UPDATE Stacks SET name="' + nameTextField.displayText + '" WHERE name="' + activeStack + '"' )
                            tx.executeSql( 'UPDATE Cards SET stack_id="' + nameTextField.displayText + '" WHERE stack_id="' + activeStack + '"' )
                            PopupUtils.close(dialogue)
                        }
                    )
                    activeStack = nameTextField.text
                    mainStack.pop()
                    mainStack.pop()
                    mainStack.push(Qt.resolvedUrl("../pages/DashPage.qml"))
                    mainStack.push(Qt.resolvedUrl("../pages/StackSettingsPage.qml"))
                }
            }
        }
    }
}
