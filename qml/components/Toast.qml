import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Rectangle {

    property var defaultTime: 8000
    property bool stateVisible: false

    id: toast
    anchors.top: parent.top
    anchors.margins: units.gu(2)
    anchors.topMargin: units.gu(8)
    anchors.horizontalCenter: parent.horizontalCenter
    width: label.width + units.gu(2)
    height: label.height + units.gu(2)
    color: Qt.rgba(0,0,0,0.75)
    radius: units.gu(0.5)
    visible: false
    z: 30

    MouseArea {
        anchors.fill: parent
        onClicked: { toast.stateVisible = false }
        visible: toast.opacity
    }

    states: [
    State { when: stateVisible;
        PropertyChanges {   target: toast; opacity: 1.0;    }
    },
    State { when: !stateVisible;
        PropertyChanges {   target: toast; opacity: 0.0;    }
    }
    ]


    transitions: Transition {
        NumberAnimation { property: "opacity"; duration: 250}
    }

    function show ( str, time ) {
        if ( !time ) time = defaultTime

        var urlRegex = /(https?:\/\/[^\s]+)/g
        var tempText = str || " "
        if ( tempText === "" ) tempText = " "
        tempText = tempText.replace ( "&#60;", "<" )
        tempText = tempText.replace ( "&#62;", "<" )
        tempText = tempText.replace(urlRegex, function(url) {
            return '<a href="%1"><font color="#CCCCFF">%1</font></a>'.arg(url)
        })

        label.text = tempText

        var maxWidth = root.width - units.gu(6)
        if ( label.width > maxWidth ) label.width = maxWidth

        visible = true
        stateVisible = true
        function Timer() {
            return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root)
        }
        var timer = new Timer()
        timer.interval = time
        timer.repeat = false
        timer.triggered.connect(function () {
            if ( label.text === str ) toast.stateVisible = false
        })
        timer.start();
    }

    Label {
        id: label
        //elide: Text.ElideMiddle
        anchors.centerIn: parent
        text: ""
        color: "#FFFFFF"
        wrapMode: Text.Wrap
        onLinkActivated: Qt.openUrlExternally(link)
    }

}
