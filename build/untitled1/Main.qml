import QtQuick 6.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 1000
    height: 600
    title: "Test Uygulaması"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 1. Üstteki Lacivert Sekmeler
        TabBar {
            Layout.fillWidth: true
            height: 40
            background: Rectangle { color: "#1a237e" }

            TabButton {
                text: "Test 1"
                contentItem: Text {
                    text: "Test 1"
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            TabButton {
                text: "Test 2"
                contentItem: Text {
                    text: "Test 2"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }

        // 2. Siyah Buton Barı
        Rectangle {
            height: 25
            Layout.fillWidth: true
            color: "#00000080"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: ["Test Başlat", "Çalışan Test İzleme", "Test Raporları", "Ayarlar"]
                    delegate: Button {
                        text: modelData
                        Layout.fillWidth: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            text: modelData
                            color: "white"
                            font.pixelSize: 14
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        // 3. İçerik Alanı (Sol ve Sağ)
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Frame {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.5
                padding: 10
                background: Rectangle {
                    color: "white"
                    border.color: "#cccccc"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Kırmızı başlık
                    Rectangle {
                        height: 30
                        Layout.fillWidth: true
                        color: "#e53935"
                        Text {
                            anchors.centerIn: parent
                            text: "Devam Eden Testler"
                            color: "white"
                            font.bold: true
                        }
                    }

                    // Scroll ile test listesi
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Column {
                            width: parent.width
                            spacing: 10

                            Repeater {
                                model: 15
                                delegate: Rectangle {
                                    width: parent.width
                                    height: 40
                                    color: "#f5f5f5"
                                    border.color: "#ccc"
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Test #" + (index + 1)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Sağ panel boş
        }
    }
}
