import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import "components"
import "controller"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'flashcards.christianpauly'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    // automatically anchor items to keyboard that are anchored to the bottom
    anchorToKeyboard: true

    theme: ThemeSettings {
        name: settings.darkMode ? "Ubuntu.Components.Themes.SuruDark" : "Ubuntu.Components.Themes.Ambiance"
    }

    readonly property var version: "1.0.0"
    property var tabletMode: width > units.gu(90)
    property var prevMode: false
    property var activeStack: ""

    onTabletModeChanged: {
        if ( prevMode !== tabletMode ) {
            mainStack.clear ()
            if ( tabletMode ) mainStack.push( Qt.resolvedUrl("./pages/BlankPage.qml") )
            else mainStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )
            prevMode = tabletMode
        }
    }

    property var db: LocalStorage.openDatabaseSync("FlashcardsDB", "1.0", "The database of the app Flashcards", 1000000)

    SettingsController { id: settings }

    PageStack {
        id: sideStack
        visible: tabletMode
        anchors.fill: undefined
        anchors.left: parent.left
        anchors.top: parent.top
        width: tabletMode ? units.gu(45) : parent.width
        height: parent.height
    }

    Rectangle {
        height: parent.height
        visible: tabletMode
        width: units.gu(0.1)
        color: UbuntuColors.slate
        anchors.top: parent.top
        anchors.left: sideStack.right
        z: 11
    }

    PageStack {
        id: mainStack
        anchors.fill: undefined
        anchors.right: parent.right
        anchors.top: parent.top
        width: tabletMode ? parent.width - units.gu(45) : parent.width
        height: parent.height
    }


    Component.onCompleted: {
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Stacks( name TEXT, UNIQUE (name) )')
                tx.executeSql('CREATE TABLE IF NOT EXISTS Cards( stack_id INTEGER, front TEXT, back TEXT, UNIQUE (stack_id, front) )')
            })
            sideStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )
            if ( tabletMode ) mainStack.push( Qt.resolvedUrl("./pages/BlankPage.qml") )
            else mainStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )

        }
    }
