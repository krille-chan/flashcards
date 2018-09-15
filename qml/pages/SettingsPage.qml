import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../components"

Page {
    anchors.fill: parent
    id: dashPage


    header: PageHeader {
        id: header
        title: i18n.tr('Settings')
    }

    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height - header.height
        anchors.top: header.bottom
        contentItem: Column {
            width: dashPage.width

            SettingsListSwitch {
                name: i18n.tr("Case and case distinction")
                icon: "stock_application"
                Component.onCompleted: isChecked = settings.caseAndCaseDistinction
                onSwitching: function () { settings.caseAndCaseDistinction = isChecked }
            }

            SettingsListSwitch {
                name: i18n.tr("Dark mode")
                icon: "torch-off"
                Component.onCompleted: isChecked = settings.darkMode
                onSwitching: function () { settings.darkMode = isChecked }
            }

            SettingsListLink {
                name: i18n.tr("About Flashcards")
                icon: "info"
                page: "InfoPage"
            }

        }
    }
}
