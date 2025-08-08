import QtQuick 6.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 1200
    height: 800
    title: qsTr("Test Paneli")

    // 🛠️ Aktif sekmelerin listesini tutmak için
    property var activeTabs: ["Test 1", "Test 2"]

    // Circular Progress Bar Bileşeni
    Component {
        id: circularProgressComponent
        Item {
            id: circularProgress
            property real progress: 0.75
            width: 120
            height: 120

            Canvas {
                id: canvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = width / 2 - 10;
                    var startAngle = -Math.PI / 2;
                    var endAngle = startAngle + progress * 2 * Math.PI;

                    ctx.clearRect(0, 0, width, height);

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
                    ctx.lineWidth = 10;
                    ctx.strokeStyle = "#ddd";
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                    ctx.lineWidth = 10;
                    ctx.strokeStyle = "#81c784";
                    ctx.stroke();
                }

                Connections {
                    target: circularProgress
                    onProgressChanged: canvas.requestPaint()
                }

                Component.onCompleted: requestPaint()
            }

            Text {
                anchors.centerIn: parent
                text: Math.round(circularProgress.progress * 100) + "%"
                font.pixelSize: 28
                font.bold: true
                color: "#333"
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 🛠️ Üst Sekmeler
        TabBar {
            id: tabBar
            height: 40
            Layout.fillWidth: true
            background: Rectangle { color: "#171e69" }

            Repeater {
                model: activeTabs
                delegate: TabButton {
                    text: modelData
                    checkable: true
                    checked: index === 0
                    background: Rectangle {
                        color: "#171e69"  // 🛠️ Seçiliyken de lacivert kalsın
                    }

                    contentItem: Row {
                        spacing: 6
                        Text {
                            text: modelData
                            color: "white"
                        }
                        // 🛠️ Sekme kapatma butonu
                        Button {
                            text: "✕"
                            font.pixelSize: 20
                            onClicked: {
                                activeTabs.splice(index, 1)
                            }
                            background: Rectangle { color: "transparent" }
                            width: 18
                            height: 18
                        }
                    }
                }
            }
        }

        // 🛠️ Şeffaf siyah araç çubuğu ve butonlar
        Rectangle {
            Layout.fillWidth: true
            height: 25
            color: "#1c1b1b"
            RowLayout {
                anchors.fill: parent
                spacing: 10

                Repeater {
                    model: ["Test Başlat", "Çalışan Test İzleme", "Test Raporları", "Ayarlar"]
                    delegate: Button {
                        text: modelData
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width / 4
                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.5
                color: "white"
                border.color: "#cccccc"
                border.width: 1
                radius: 10
                anchors.margins: 10

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 0

                    // 🛠️ Başlık sabitlendi
                    Rectangle {
                        id: titleBar
                        height: 30
                        Layout.fillWidth: true
                        color: "#e53935"
                        radius: 10
                        z: 1
                        Text {
                            anchors.centerIn: parent
                            text: "Devam Eden Testler"
                            color: "white"
                            font.bold: true
                        }
                    }

                    // 🛠️ Scroll alanı başlıktan bağımsız
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ListView {
                            width: parent.width
                            model: 76
                            delegate: Rectangle {
                                height: 40
                                width: parent.width
                                border.color: "#ccc"
                                border.width: 1
                                color: "#fdfdfd"
                                Text {
                                    anchors.centerIn: parent
                                    text: "Test " + (index + 1)
                                    color: "#333"
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.5
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.4
                    color: "white"
                    radius: 10
                    border.color: "#dddddd"
                    border.width: 1
                    anchors.margins: 10

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0
                        anchors.margins: 10

                        Rectangle {
                            height: 30
                            Layout.fillWidth: true
                            color: "#81c784"
                            radius: 10
                            Text {
                                anchors.centerIn: parent
                                text: "Başarı Oranı"
                                color: "white"
                                font.bold: true
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 20

                            Loader {
                                sourceComponent: circularProgressComponent
                                id: daireselProgress
                                onLoaded: item.progress = 0.82
                            }

                            ColumnLayout {
                                spacing: 6
                                Text { text: "Başarı oranı: %82"; font.pointSize: 14; color: "#333" }
                                Text { text: "Geçen hafta: %75  → Artış var"; font.pointSize: 12; color: "#4caf50" }
                                Text { text: "Test edilen cihaz sayısı: 120"; font.pointSize: 12; color: "#555" }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    radius: 10
                    border.color: "#dddddd"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 0

                        Rectangle {
                            height: 30
                            Layout.fillWidth: true
                            color: "#64b5f6"
                            radius: 10
                            Text {
                                anchors.centerIn: parent
                                text: "Son Yapılan Testler"
                                color: "white"
                                font.bold: true
                            }
                        }

                        // 🛠️ Sekme kapatıldığında içerik boş kalsın
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: activeTabs.length > 0 ? 4 : 0
                            delegate: Rectangle {
                                height: 40
                                width: parent.width
                                radius: 6
                                color: "#f9f9f9"
                                border.color: "#ccc"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: "🧪 Test " + (index + 1) + " - 2025/08/0" + (index + 1)
                                    color: "#333"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
