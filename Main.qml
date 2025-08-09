import QtQuick 6.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
// import Qt.Labs.qmlmodels // FileDialog'un hatasız çalışması için bu import'u kaldırdık.

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    title: qsTr("Dinamik Test Paneli")

    // Sekmelerin dinamik verisini yönetmek için ListModel kullanıyoruz.
    // Başlangıçta boş bir model ile başlıyoruz.
    ListModel {
        id: tabModel
    }

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
                    var radius = Math.min(width, height) / 2 - 10;
                    var startAngle = -Math.PI / 2;
                    var endAngle = startAngle + circularProgress.progress * 2 * Math.PI;

                    ctx.clearRect(0, 0, width, height);

                    // Arka plan çemberi
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
                    ctx.lineWidth = 10;
                    ctx.strokeStyle = "#e0e0e0";
                    ctx.stroke();

                    // İlerleme çemberi
                    if (circularProgress.progress > 0) {
                        ctx.beginPath();
                        ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                        ctx.lineWidth = 10;
                        ctx.strokeStyle = "#81c784";
                        ctx.lineCap = "round";
                        ctx.stroke();
                    }
                }
                Connections {
                    target: circularProgress
                    onProgressChanged: canvas.requestPaint()
                }
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

    // Her bir sekme için ana içeriği tanımlayan bileşen.
    Component {
        id: testPage
        Item {
            property string testTitle: "Başlıksız Test"
            property real successRate: 0.0
            property int ongoingTests: 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // SOL SÜTUN: Devam Eden Testler
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.5
                    color: "white"
                    border.color: "#cccccc"
                    border.width: 1
                    radius: 10

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 0

                        Rectangle {
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
                                font.pixelSize: 14
                            }
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            ListView {
                                width: parent.width
                                model: ongoingTests
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

                // SAĞ SÜTUN: Başarı Oranı ve Son Testler
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.5
                    spacing: 10

                    // Başarı Oranı Kutusu
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
                                    font.pixelSize: 14
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                anchors.centerIn: parent
                                spacing: 20

                                Loader {
                                    sourceComponent: circularProgressComponent
                                    onLoaded: item.progress = successRate
                                }

                                ColumnLayout {
                                    spacing: 6
                                    Text { text: "Genel başarı oranı: %" + Math.round(successRate * 100); font.pointSize: 14; color: "#333" }
                                    Text { text: "Geçen hafta: %75  → Artış var"; font.pointSize: 12; color: "#4caf50" }
                                    Text { text: "Test edilen cihaz sayısı: 120"; font.pointSize: 12; color: "#555" }
                                }
                            }
                        }
                    }

                    // Son Yapılan Testler Kutusu
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
                                    font.pixelSize: 14
                                }
                            }

                            ScrollView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true

                                ListView {
                                    Layout.fillWidth: true
                                    model: 4
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
    }

    // ANA ARAYÜZ DÜZENİ
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ÜST SEKMELER (TABS)
        TabBar {
            id: tabBar
            height: 40
            Layout.fillWidth: true
            background: Rectangle { color: "#171e69" }

            Repeater {
                model: tabModel
                delegate: TabButton {
                    text: model.title
                    checked: index === tabBar.currentIndex
                    background: Rectangle {
                        color: "#171e69"
                        border.color: "#171e69"
                    }
                    contentItem: Row {
                        spacing: 2
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: model.title
                            color: "white"
                            font.bold: parent.parent.checked
                        }
                        Button {
                            text: "✕"
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            width: 18
                            height: 18
                            onClicked: {
                                tabModel.remove(index)
                                if (tabBar.currentIndex >= tabModel.count) {
                                    tabBar.currentIndex = tabModel.count - 1;
                                }
                            }
                            background: Rectangle { color: "transparent" }
                            palette.buttonText: "white"
                        }
                    }
                }
            }
        }

        // Şeffaf siyah araç çubuğu ve butonlar
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
                        onClicked: {
                            if (index === 0) {
                                // "Test Başlat" butonuna tıklandığında yeni pencereyi açıyoruz.
                                startTestDialog.open();
                            }
                        }
                    }
                }
            }
        }

        // SEKMELERİN İÇERİĞİNİ GÖSTEREN ALAN
        StackLayout {
            id: pageStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            Repeater {
                model: tabModel
                delegate: Loader {
                    sourceComponent: testPage
                    onLoaded: {
                        item.testTitle = model.title;
                        item.successRate = model.successRate;
                        item.ongoingTests = model.ongoingTests;
                    }
                }
            }
        }
    }

    // Yeni test başlatma penceresini tanımlayan bileşen
    Popup {
        id: startTestDialog
        modal: true
        width: 500
        height: 550
        anchors.centerIn: parent
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: "#f5f5f5"
            radius: 10
            border.color: "#ccc"
        }

        // Popup her açıldığında input alanlarını temizle.
        onOpened: {
            testNameInput.text = "";
            parametersTextArea.text = "";
        }

        // Pencere içeriği
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Yeni Test Başlat"
                font.pixelSize: 24
                font.bold: true
                color: "#333"
                Layout.alignment: Qt.AlignHCenter
            }

            // Test Adı Girişi
            TextField {
                id: testNameInput
                Layout.fillWidth: true
                placeholderText: "Test Adını Giriniz"
                font.pixelSize: 16
                height: 40
            }

            // Test Tipi Seçimi
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                Text { text: "Test Tipi Seçimi:"; font.pixelSize: 14; font.bold: true }
                ComboBox {
                    id: testTypeCombo
                    Layout.fillWidth: true
                    height: 40
                    currentIndex: 0
                    model: ["Smoke", "Regression", "CAN Validation"]
                }
            }

            // Test Parametreleri Girişi
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                Text { text: "Test Parametreleri (JSON veya Form):"; font.pixelSize: 14; font.bold: true }
                TextArea {
                    id: parametersTextArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: "Örnek: { \"param1\": \"deger1\", \"param2\": 123 }"
                    font.pixelSize: 14
                    background: Rectangle {
                        color: "#fff"
                        radius: 5
                        border.color: "#ccc"
                    }
                }
            }

            // Dosya Yükleme Alanı
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                Text { text: "Yüklenen Dosya:"; font.pixelSize: 14; font.bold: true }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    TextField {
                        id: fileNameInput
                        Layout.fillWidth: true
                        placeholderText: "Dosya adı burada görünecek"
                        font.pixelSize: 14
                        readOnly: true
                        height: 40
                    }

                    Button {
                        text: "Dosya Yükle"
                        Layout.preferredWidth: 120
                        height: 40
                        background: Rectangle {
                            color: "#64b5f6"
                            radius: 5
                        }
                        contentItem: Text {
                            anchors.centerIn: parent
                            text: parent.text
                            color: "white"
                        }
                        onClicked: {
                            // FileDialog, bu ortamda desteklenmediği için simülasyon yapıyoruz.
                            fileNameInput.text = "simulated_test_script.hex";
                            console.log("Dosya yükleme simülasyonu: " + fileNameInput.text);
                        }
                    }
                }
            }


            // Kontrol Butonları
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    Layout.fillWidth: true
                    text: "İptal Et"
                    background: Rectangle {
                        color: "#e53935"
                        radius: 5
                    }
                    contentItem: Text { anchors.centerIn: parent; text: parent.text; color: "white" }
                    onClicked: startTestDialog.close()
                }

                Button {
                    Layout.fillWidth: true
                    text: "Başlat"
                    background: Rectangle {
                        color: "#4caf50"
                        radius: 5
                    }
                    contentItem: Text { anchors.centerIn: parent; text: parent.text; color: "white" }
                    onClicked: {
                        if (testNameInput.text.trim() !== "") {
                            // Yeni sekmeyi açıyoruz ve adını girilen metin yapıyoruz.
                            tabModel.append({
                                title: testNameInput.text,
                                successRate: Math.random(),
                                ongoingTests: Math.floor(Math.random() * 100)
                            });
                            tabBar.currentIndex = tabModel.count - 1;
                            startTestDialog.close();
                        } else {
                            // Test adı girilmediyse kullanıcıya geri bildirim verilebilir.
                            // Örneğin bir uyarı metni gösterilebilir.
                            console.log("Test adı boş bırakılamaz.");
                        }
                    }
                }
            }
        }
    }
}

