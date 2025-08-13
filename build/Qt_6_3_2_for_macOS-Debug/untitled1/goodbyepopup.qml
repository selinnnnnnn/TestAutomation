import QtQuick
import QtQuick.Controls

Window {
    id: goodbyeWindow

    // Pencere boyutu ve bayrakları
    width: 250
    height: 100
    // Çerçevesiz ve her zaman üstte duran bir pencere
    flags: Qt.SplashScreen | Qt.FramelessWindowHint

    // Arka planı transparan yapabiliriz (isteğe bağlı)
    color: "transparent"

    // İçerik: Yazı
    Text {
        text: "developed by s&d"
        anchors.centerIn: parent
        font.pixelSize: 20
        font.bold: true
        color: "#333" // Koyu gri bir renk
    }

    // Bu pencere açıldığında çalışacak zamanlayıcı
    Timer {
        interval: 2000 // 2000 milisaniye = 2 saniye
        repeat: false
        running: true // Pencere açılır açılmaz çalışmaya başla

        // Zamanlayıcı süresi dolduğunda...
        onTriggered: {
            // ...tüm uygulamayı kapat.
            Qt.quit();
        }
    }
}
