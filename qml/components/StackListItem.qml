import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
import Ubuntu.Components.Popups 1.3
import "../components"

ListItem {
    id: stackListItem

    height: layout.height

    property var stackName: name

    onClicked: {
        activeStack = stackName

        mainStack.push(Qt.resolvedUrl("../pages/StackSettingsPage.qml"))
    }

    ListItemLayout {
        id: layout
        width: parent.width
        title.text: name
        title.color: stringToColor( stackName )

        Icon {
            name: "inbox-all"
            SlotsLayout.position: SlotsLayout.Leading
            width: units.gu(6)
            height: width
            color: stringToColor( stackName )
        }
    }

    function stringToColor ( str ) {
        var number = 0
        for( var i=0; i<str.length; i++ ) number += str.charCodeAt(i)
        number = (number % 100) / 100
        return Qt.hsla( number, 1, 0.3, 1 )
    }

    // Delete Button
    leadingActions: ListItemActions {
        actions: [
        Action {
            iconName: "edit-delete"
            onTriggered: {
                activeStack = stackName
                PopupUtils.open(removeStackDialog)
            }
        }
        ]
    }

}
