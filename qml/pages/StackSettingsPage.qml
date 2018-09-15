import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../components"

Page {
    anchors.fill: parent
    id: stackSettingsPage
    property var activeCardFront: ""

    Component.onCompleted: update ()

    function update () {

        // On the top are the rooms, which the user is invited to
        db.transaction(
            function(tx) {
                var res = tx.executeSql("SELECT * FROM Cards WHERE stack_id='" + activeStack + "'")
                model.clear ()
                // We now write the rooms in the column
                for ( var i = 0; i < res.rows.length; i++ ) {
                    var card = res.rows.item(i)
                    // We request the room name, before we continue
                    model.append ( { "front": card.front } )
                }
            }
        )
    }


    header: PageHeader {
        id: header
        title: activeStack
        trailingActionBar {
            actions: [
            Action {
                iconName: "compose"
                onTriggered: PopupUtils.open(changeStackNameDialog)
            }
            ]
        }
    }

    ChangeStackNameDialog { id: changeStackNameDialog }
    CreateCardDialog { id: createCardDialog }
    RemoveCardDialog { id: removeCardDialog }

    Column {
        id: contentColumn
        width: parent.width
        anchors.top: header.bottom
        z: 2

        SettingsListLink {
            name: i18n.tr("Learn now")
            icon: "select"
            page: "LearnModePage"
            visible: model.count > 0
        }

        SettingsListLink {
            name: i18n.tr("Quiz mode")
            icon: "help"
            page: "QuizModePage"
            visible: model.count >= 4
        }

        Rectangle {
            width: parent.width
            height: units.gu(2)
            color: theme.palette.normal.background
        }

        Rectangle {
            width: parent.width
            height: units.gu(2)
            color: theme.palette.normal.background
            Label {
                id: userInfo
                height: units.gu(2)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)
                text: i18n.tr("Flashcards (%1):").arg(cardListView.count)
                font.bold: true
            }
        }

        Rectangle {
            width: parent.width
            height: units.gu(2)
            color: theme.palette.normal.background
        }

        Rectangle {
            width: parent.width
            height: 1
            color: UbuntuColors.ash
        }

        SettingsListItem {
            name: i18n.tr("Create new flashcard")
            icon: "add"
            onClicked: {
                activeCardFront = ""
                PopupUtils.open ( createCardDialog )
            }
        }
    }

    ListView {
        id: cardListView
        width: parent.width
        height: parent.height - header.height
        anchors.top: contentColumn.bottom
        anchors.bottom: parent.bottom
        delegate: CardListItem {}
        model: ListModel { id: model }
    }

}
