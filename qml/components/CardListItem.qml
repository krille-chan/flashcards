import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
import Ubuntu.Components.Popups 1.3
import "../components"

ListItem {
    id: cardListItem

    height: layout.height

    onClicked: {
        activeCardFront = front
        PopupUtils.open( createCardDialog )
    }

    ListItemLayout {
        id: layout
        width: parent.width
        title.text: front

        Icon {
            name: "stock_note"
            SlotsLayout.position: SlotsLayout.Leading
            width: units.gu(4)
            height: width
        }
    }

    // Delete Button
    leadingActions: ListItemActions {
        actions: [
        Action {
            iconName: "edit-delete"
            onTriggered: {
                activeCardFront = front
                PopupUtils.open( removeCardDialog )
            }
        }
        ]
    }

}
