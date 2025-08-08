import QtQuick 6.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Window 6.3
import QtQuick.Dialogs 6.3
import Qt.labs.platform 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1200
    height: 800
    title: "Test Paneli"

    // Aktif sekmeler dizisi
    property var activeTabs: []
    property int currentTabIndex: -1

    // Test Başlatma Penceresi
    Window {
        id: testStartWindow
        width: 400
        height: 350
        visible: false
        title: "Test Başlat"
        modality: Qt.ApplicationModal
        flags: Qt.Window

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            ComboBox {
                id: testTypeCombo
                Layout.fillWidth: true
                model: ["Fonksiyonel Test", "Performans Testi", "Güvenlik Testi"]
                currentIndex: 0
            }

            TextArea {
                id: paramInput
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                placeholderText: "Test parametrelerini JSON formatında giriniz"
            }

            Button {
                text: "Dosya Yükle"
                Layout.fillWidth: true
                onClicked: fileDialog.open()
            }

            FileDialog {
                id: fileDialog
                title: "Dosya Seç"
                nameFilters: ["JSON Dosyaları (*.json)", "Tüm Dosyalar (*)"]
                onAccepted: {
                    console.log("Seçilen dosya: " + fileDialog.fileUrl)
                }
            }


            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10

                Button {
                    text: "İptal"
                    onClicked: testStartWindow.visible = false
                }

                Button {
                    text: "Başlat"
                    onClicked: {
                        if(paramInput.text.trim() === "") {
                            console.log("Parametre girişi boş olamaz!")
                            return
                        }
                        var newTabName = testTypeCombo.currentText + " " + (mainWindow.activeTabs.length + 1)
                        mainWindow.activeTabs.push(newTabName)
                        mainWindow.currentTabIndex = mainWindow.activeTabs.length - 1
                        testStartWindow.visible = false
                        paramInput.text = ""
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Sekme Çubuğu - sağdan sola dizilen sekmeler
        Rectangle {
            id: tabBarRect
            height: 40
            Layout.fillWidth: true
            color: "#005493"

            Flickable {
                contentWidth: tabRow.width
                anchors.fill: parent
                clip: true
                interactive: true
                flickableDirection: Flickable.HorizontalFlick

                Row {
                    id: tabRow
                    spacing: 6
                    height: parent.height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: activeTabs
                        delegate: Rectangle {
                            width: 140
                            height: 32
                            radius: 4
                            color: index === currentTabIndex ? "#04375e" : "#005493"
                            border.color: "#04375e"
                            border.width: 1

                            Row {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 6

                                Text {
                                    text: modelData
                                    color: "white"
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                    font.pixelSize: 14
                                }

                                MouseArea {
                                    width: 20
                                    height: 20
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        activeTabs.splice(index, 1)
                                        if (currentTabIndex >= activeTabs.length)
                                            currentTabIndex = activeTabs.length - 1
                                        if (activeTabs.length === 0)
                                            currentTabIndex = -1
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "✕"
                                        color: "white"
                                        font.pixelSize: 16
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentTabIndex = index
                            }
                        }
                    }
                }
            }
        }

        // Araç Çubuğu
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#1c1b1b"

            RowLayout {
                anchors.fill: parent
                spacing: 10


                Button {
                    text: "Test Başlat"
                    Layout.preferredWidth: 160
                    height: parent.height
                    background: Rectangle { color: "transparent" }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text: "Test Başlat"
                        color: "white"
                        font.pixelSize: 14
                    }
                    onClicked: testStartWindow.visible = true
                }

                Repeater {
                    model: ["Çalışan Test İzleme", "Test Raporları", "Ayarlar"]
                    delegate: Button {
                        Layout.preferredWidth: 160
                        height: parent.height
                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 14
                        }
                        onClicked: {
                            console.log(modelData + " tıklandı")
                        }
                    }
                }
            }
        }

        // Ana içerik
        Rectangle {
            color: "white"
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            border.color: "#ddd"
            border.width: 1
            anchors.margins: 10

            Loader {
                anchors.fill: parent
                sourceComponent: currentTabIndex >= 0 ? testContentComponent : noTestComponent
            }
        }
    }

    // Test İçeriği (senin gönderdiğin tasarım burada olacak)
    Component {
        id: testContentComponent

        // Senin gönderdiğin tasarımın birebir aynısı, sadece currentTabIndex'e göre içerik dinamik
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Üst sekmeler burada değil, çünkü ana sekme zaten aktif sekmeyi belirliyor.

            // Araç çubuğu burada değil, zaten yukarıda

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Sol panel (Devam Eden Testler)
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

                        // Başlık sabit
                        Rectangle {
                            id: titleBar
                            height: 30
                            Layout.fillWidth: true
                            color: "#7207a3"    // Senin verdiğin lacivert
                            radius: 10
                            z: 1
                            Text {
                                anchors.centerIn: parent
                                text: "Devam Eden Testler"
                                color: "white"
                                font.bold: true
                            }
                        }

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

                // Sağ panel (Başarı Oranı + Son Yapılan Testler)
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.5
                    spacing: 10

                    // Başarı Oranı kutusu
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

                                // Circular Progress Component (Aynı senin)
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

                    // Son Yapılan Testler kutusu
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

    // Circular Progress Bar Bileşeni (aynı senin)
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

    // Boş sekme içeriği
    Component {
        id: noTestComponent

        Rectangle {
            color: "#f0f0f0"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                text: "Henüz test başlatılmadı."
                font.pixelSize: 18
                color: "#888"
            }
        }
    }
}
