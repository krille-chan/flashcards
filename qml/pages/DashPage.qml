import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../components"

Page {
    anchors.fill: parent
    id: dashPage

    Component.onCompleted: update ()

    function update () {

        // On the top are the rooms, which the user is invited to
        db.transaction(
            function(tx) {
                var res = tx.executeSql("SELECT * FROM Stacks")
                model.clear ()
                // We now write the rooms in the column
                for ( var i = 0; i < res.rows.length; i++ ) {
                    var stack = res.rows.item(i)
                    // We request the room name, before we continue
                    model.append ( { "name": stack.name } )
                }
            }
        )
    }


    header: PageHeader {
        id: header
        title: i18n.tr('Stacks')
        trailingActionBar {
            actions: [

            Action {
                iconName: "settings"
                onTriggered: mainStack.push(Qt.resolvedUrl("./SettingsPage.qml"))
            },
            Action {
                iconName: "add"
                onTriggered: PopupUtils.open(createStackDialog)
            }
            ]
        }
    }


    CreateStackDialog { id: createStackDialog }
    RemoveStackDialog { id: removeStackDialog }

    Label {
        text: i18n.tr("You first have to create a flashcard stack")
        anchors.centerIn: parent
        visible: stackListView.count === 0
    }


    ListView {
        id: stackListView
        width: parent.width
        height: parent.height - header.height
        anchors.top: header.bottom
        delegate: StackListItem {}
        model: ListModel { id: model }
    }
}
