import QtQuick
import QtQuick.Layouts

Rectangle {
    id: assignmentCard
    property string title: "Assignment"
    property string descriptions: "Descriptions"

    implicitHeight: content.implicitHeight + 2 * Constants.padding
    color: Constants.card
    radius: Constants.radius
    border.width: 1
    border.color: Constants.border

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Constants.padding
        spacing: Constants.spacing / 2

        Text {
            id: cardTitle
            Layout.fillWidth: true
            text: assignmentCard.title
            wrapMode: Text.WordWrap
            font.pixelSize: Constants.bodySize + 2
            font.bold: true
            color: Constants.cardForeground
        }
        Text {
            id: cardDescription
            Layout.fillWidth: true
            text: assignmentCard.descriptions
            wrapMode: Text.WordWrap
            font.pixelSize: Constants.bodySize - 2
            color: Constants.mutedForeground
        }
    }
}
