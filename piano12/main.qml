import QtQuick 2.12 // основной модуль (Rectangle, Image и т.д.)
import QtQuick.Window 2.12 // Отображение окна
import QtQuick.Controls 2.12 // Для кнопок
import QtMultimedia 5.12 // Поддержка аудиофайлов в проекте
import QtQuick.Dialogs 1.3 // Поддержка диалоговых окон(в нашем случае выбор файла)

Window {
    visible: true // видимость окна
    minimumHeight: 570 // минимальная высота
    minimumWidth: 680 // минимальная ширина
    maximumHeight: 570 // максимальная высота                       // первые 6 строчек задают фиксированный размер окна, который нельзя изменить
    maximumWidth: 680 // максимальная ширина
    width: 680 // ширина
    height: 570 // высота
    title: qsTr("Пианино 2.0") // заголовок окна

    property string path: ""  // путь к выбранному файлу через диалогове окно

    Image {
        source: "qrc:/img/fon.jpg" // фоновая картинка приложения
    }

    function getStatus(value)                // функция преобразование пути до файла к названию файлу
    {                                        // file:///C:/Users/bug/Desktop/piano12/sounds/test.mp3 -> test.mp3
        var str = value + '\0';              // str = path
        var size = str.length - 1;           // размер строки str - 1(количество индексов от 0 до size)
        var i  = size;                       // i - переменная, чтобы запомнить место, где мы первый раз встретим '/'

        while(str[i] !== '/')                // идем справа налево до символа '/' (выше пример)
            i--;

        var newString = str.slice(i + 1, size);  // берем все правее первого '/', получим test.mp3
        status.text = "<b>" + newString + "</b>";   // выводим внизу файл, который открыт(жирным текстом)
    }

Item {                                           // обертка для вего, что есть на экране, чтобы можно было все двинать разом координатами x и у, а не менять во всей проге
    x: 5                                         // координаты по x
    y: 5                                         // координаты по у

    Audio {                                        //================================================================================================================================
        id: d
        source: "qrc:/sounds/do.wav"
    }

    Audio {
        id: f
        source: "qrc:/sounds/fa.wav"
    }

    Audio {
        id: l
        source: "qrc:/sounds/la.wav"
    }

    Audio {
        id: m
        source: "qrc:/sounds/mi.wav"
    }

    Audio {
        id: ob
        source: "qrc:/sounds/ob.mp3"
    }

    Audio {
        id: r
        source: "qrc:/sounds/re.wav"                 // создаем объекты типа Audio, где по id мы будем запускать или останавливать тот или иной звук
    }                                                // source - путь до нужного звука

    Audio {
        id: s
        source: "qrc:/sounds/si.wav"
    }

    Audio {
        id: so
        source: "qrc:/sounds/sol.wav"
    }

    Audio {
        id: b79
        source: "qrc:/sounds/b79.mp3"
    }

    Audio {
        id: b80
        source: "qrc:/sounds/b80.mp3"
    }

    Audio {
        id: b81
        source: "qrc:/sounds/b81.mp3"
    }

    Audio {
        id: b83
        source: "qrc:/sounds/b83.mp3"
    }

    Audio {
        id: b84
        source: "qrc:/sounds/b84.mp3"
    }

    Audio {
        id: gg
        source: path                             // отличается от всех остальных Audio, потому что нужно менять каждый раз то, что будет проигрывать, через path
        onStopped:                               // что будет происходить, когда эта музыка будет заканчиваться
        {
            bPause.visible = false;              // мызыка закончилась - убираем кнопку паузы
            bStart.visible = true;               // включаем кнопку старта, чтобы можно было снова запустить эту музыку
            bRefresh.enabled = false;            // отключаем кнопку запуска с начала мызыки, так как она и так закончилась и будет проигрываться с начала
        }
    }                                            //=====================================================================================================================

    Rectangle{                                   // каждый Rectangle(прямоугольник) - это либо белая кнопка, либо черная в нашем приложении
        id: keya                                 // id - идентификатор, по которому мы можем обращаться к этому элементу и менять его свойства
        width: 100                               // ширина
        height: 500                              // высота
        color: "white"                           // цвет
        border.color: "black"                    // цвет обводки
        border.width: 1                          // размер обводки
        Image {                                  // у каждой белой или черной кнопки есть картинка, которая наложена поверх - эту буквы(W, R, A, S и т.д.)
            x: 27                                // координаты по x
            y: 430                               // координаты по у
            width: 50                            // ширина картинки
            height: 50                           // высота картинки
            source: "qrc:/img/A.png"             // путь, где хранится картинка, чтобы можно было ее отобразить
        }

        MouseArea {                              // у каждой белой или черной кнопки есть своя зона срабатывания кликами мышками
            id: maA
            anchors.fill: parent                 // границы зоны срабатывания, в нашем случае вся кнопка, где parent в этом случае - это Rectangle
            onPressed: {                         // что делать, когда мы кликнули на клавишу
                keya.color = "lightyellow";      // меняем цвет на светло-желтый, так как кнопка нажата
                d.stop();                        // останавливаем проигрывае этого звука, если он был, чтобы можно было много раз нажимать на кнопку
                d.play();                        // воспроизводим звук
            }
            onReleased: {                        // что делать, когда мы кликнули и отпустили кнопку
                keya.color = "white";            // возвращаем цвет на белый, так как кнопка больше не нажата
            }                                    // !!! и так все остальные Rectangle, Image и MouseArea, что ниже(код повторяется, меняется только координаты и звуки) !!!
        }

        focus: true;                             // фокус на кнопку A, чтобы проигрывание на кнопки работало

        Keys.onReleased: {                                      // обработка нажатий клавиш(в данном случае, когда мы отпускам кнопку)
            if(event.isAutoRepeat)                              // убирает автоповтор нажатий(чтобы срабатывало один раз)
               return;                                          // словили повторение - просто выходим и так бесконечно, пока не
            if(event.key === Qt.Key_A || event.key === 1060){   // что делать если пользователь отжал кнопку A англ или Ф русскую
                keya.color = "white";                           // возвращаем цвет обратно на белый, так как мы отпустили кнопку
                event.accepted = true;                          // значение true, чтобы предотвратить распространение события вверх по иерархии элементов
            }                                                   // и все что ниже по тому же принципу, меняются только кнопки
            if(event.key === Qt.Key_S || event.key === 1067){
                keys.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_D || event.key === 1042){
                keyd.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_F || event.key === 1040){
                keyf.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_G || event.key === 1055){
                keyg.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_H || event.key === 1056){
                keyh.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_J || event.key === 1054){
                keyj.color = "white";
                event.accepted = true;
            }
            if(event.key === Qt.Key_W || event.key === 1062){
                keyw.color = "black";
                event.accepted = true;
            }
            if(event.key === Qt.Key_E || event.key === 1059){
                keye.color = "black";
                event.accepted = true;
            }
            if(event.key === Qt.Key_R || event.key === 1050){
                keyr.color = "black";
                event.accepted = true;
            }
            if(event.key === Qt.Key_T || event.key === 1045){
                keyt.color = "black";
                event.accepted = true;
            }
            if(event.key === Qt.Key_Y || event.key === 1053){
                keyy.color = "black";
                event.accepted = true;
            }
            if(event.key === Qt.Key_U || event.key === 1043){
                keyu.color = "black";
                event.accepted = true;
            }
        }                                                                  //===========================================================================================

        Keys.onPressed: {                                                   // обработка нажатий клавиш(в данном случае, когда мы нажимаем кнопку)
            if(event.isAutoRepeat)                                          // всё так же, как и выше, только изменились действия после нажатия кнопки
               return;
            if(event.key === Qt.Key_A || event.key === 1060){
                d.stop();                                                   // останавливаем проигрывание этого звука, если он был, чтобы можно было много раз нажимать на кнопку
                d.play();                                                   // воспроизводим звук
                keya.color = "lightyellow";                                 // меняем цвет на светло-желтый, так как кнопка нажата
                event.accepted = true;                                      // значение true, чтобы предотвратить распространение события вверх по иерархии элементов
            }                                                               // и все что ниже по тому же принципу, меняются только кнопки
            if(event.key === Qt.Key_S || event.key === 1067){
                r.stop();
                r.play();
                keys.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_D || event.key === 1042){
                m.stop();
                m.play();
                keyd.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_F || event.key === 1040){
                f.stop();
                f.play();
                keyf.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_G || event.key === 1055){
                so.stop();
                so.play();
                keyg.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_H || event.key === 1056){
                l.stop();
                l.play();
                keyh.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_J || event.key === 1054){
                s.stop();
                s.play();
                keyj.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_W || event.key === 1062){
                b79.stop();
                b79.play();
                keyw.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_E || event.key === 1059){
                b80.stop();
                b80.play();
                keye.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_R || event.key === 1050){
                b81.stop();
                b81.play();
                keyr.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_T || event.key === 1045){
                ob.stop();
                ob.play();
                keyt.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_Y || event.key === 1053){
                b84.stop();
                b84.play();
                keyy.color = "lightyellow";
                event.accepted = true;
            }
            if(event.key === Qt.Key_U || event.key === 1043){
                b83.stop();
                b83.play();
                keyu.color = "lightyellow";
                event.accepted = true;
            }
        }                                                            //===========================================================================================

        Rectangle {                                                  // уже описывал все, что ниже выше, где кнопка A(id: keya)
            id: keys
            width: 100
            height: 500
            x: 95
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maS
                anchors.fill: parent
                onPressed: {
                    keys.color = "lightyellow";
                    r.stop();
                    r.play();
                }
                onReleased: {
                    keys.color = "white";
                }
            }
        }
        Image {
            x: 122
            y: 432
            width: 45
            height: 45
            source: "qrc:/img/S.png"
        }

        Rectangle{
            id: keyd
            width: 100
            height: 500
            x: 190
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maD
                anchors.fill: parent
                onPressed: {
                    keyd.color = "lightyellow";
                    m.stop();
                    m.play();
                }
                onReleased: {
                    keyd.color = "white";
                }
            }
        }
        Image {
            x: 217
            y: 434
            width: 45
            height: 45
            source: "qrc:/img/D.png"
        }

        Rectangle{
            id: keyf
            width: 100
            height: 500
            x: 285
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maF
                anchors.fill: parent
                onPressed: {
                    keyf.color = "lightyellow";
                    f.stop();
                    f.play();
                }
                onReleased: {
                    keyf.color = "white";
                }
            }
        }
        Image {
            x: 312
            y: 425
            width: 45
            height: 60
            source: "qrc:/img/F.png"
        }

        Rectangle {
            id: keyg
            width: 100
            height: 500
            x: 380
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maG
                anchors.fill: parent
                onPressed: {
                    keyg.color = "lightyellow";
                    so.stop();
                    so.play();
                }
                onReleased: {
                    keyg.color = "white";
                }
            }
        }
        Image {
            x: 407
            y: 425
            width: 50
            height: 55
            source: "qrc:/img/G.png"
        }

        Rectangle{
            id: keyh
            width: 100
            height: 500
            x: 475
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maH
                anchors.fill: parent
                onPressed: {
                    keyh.color = "lightyellow";
                    l.stop();
                    l.play();
                }
                onReleased: {
                    keyh.color = "white";
                }
            }
        }
        Image {
            x: 502
            y: 430
            width: 50
            height: 50
            source: "qrc:/img/H.png"
        }

        Rectangle{
            id: keyj
            width: 100
            height: 500
            x: 570
            color: "white"
            border.color: "black"
            border.width: 1

            MouseArea {
                id: maJ
                anchors.fill: parent
                onPressed: {
                    keyj.color = "lightyellow";
                    s.stop();
                    s.play();
                }
                onReleased: {
                    keyj.color = "white";
                }
            }
        }
        Image {
            x: 597
            y: 430
            width: 50
            height: 52
            source: "qrc:/img/J.png"
        }

        Rectangle{
            id: keyw
            width: 80
            height: 300
            x: 56
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5
            Image {
                x: 20
                y: 236
                width: 35
                height: 35
                source: "qrc:/img/W.png"
            }

            MouseArea {
                id: maW
                anchors.fill: parent
                onPressed: {
                    keyw.color = "lightyellow";
                    b79.stop();
                    b79.play();
                }
                onReleased: {
                    keyw.color = "black";
                }
            }
        }

        Rectangle{
            id: keye
            width: 80
            height: 300
            x: 151
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                id: maE
                anchors.fill: parent
                onPressed: {
                    keye.color = "lightyellow";
                    b80.stop();
                    b80.play();
                }
                onReleased: {
                    keye.color = "black";
                }
            }
        }
        Image {
            x: 175
            y: 240
            width: 30
            height: 30
            source: "qrc:/img/E.png"
        }

        Rectangle{
            id: keyr
            width: 80
            height: 300
            x: 245
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                id: maR
                anchors.fill: parent
                onPressed: {
                    keyr.color = "lightyellow";
                    b81.stop();
                    b81.play();
                }
                onReleased: {
                    keyr.color = "black";
                }
            }
        }
        Image {
            x: 270
            y: 240
            width: 30
            height: 30
            source: "qrc:/img/R.png"
        }

        Rectangle{
            id: keyt
            width: 80
            height: 300
            x: 340
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                id: maT
                anchors.fill: parent
                onPressed: {
                    keyt.color = "lightyellow";
                    ob.stop();
                    ob.play();
                }
                onReleased: {
                    keyt.color = "black";
                }
            }
        }
        Image {
            x: 365
            y: 240
            width: 30
            height: 30
            source: "qrc:/img/T.png"
        }

        Rectangle{
            id: keyy
            width: 80
            height: 300
            x: 435
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                id: maY
                anchors.fill: parent
                onPressed: {
                    keyy.color = "lightyellow";
                    b84.stop();
                    b84.play();
                }
                onReleased: {
                    keyy.color = "black";
                }
            }
        }
        Image {
            x: 459
            y: 240
            width: 30
            height: 30
            source: "qrc:/img/Y.png"
        }

        Rectangle{
            id: keyu
            width: 80
            height: 300
            x: 530
            y: 1
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                id: maU
                anchors.fill: parent
                onPressed: {
                    keyu.color = "lightyellow";
                    b83.stop();
                    b83.play();
                }
                onReleased: {
                    keyu.color = "black";
                }
            }
        }
        Image {
            x: 555
            y: 240
            width: 30
            height: 30
            source: "qrc:/img/U.png"
        }

    }                                                 //============================================================================================

    Button {                  //-----------Кнопка выхода-------------------------------------
        x: 569                // ее координаты по x
        y: 505                // ее координаты по y
        text: "Выйти"         // текст кнопки
        highlighted: true     // делает кнопку черной(стиль такой)
        onClicked: Qt.quit()  // что делает при нажатии на нее - закрывает приложение
    }                         //------------------------------------------------------

    Button {                    //-----------Кнопка запуска музыки--------------------------------------------------------
        id: bStart              // идентификатор кнопки, чтобы можно было менять ее свойства
        x: 1                    // ее координаты по x
        y: 505                  // ее координаты по у
        text: "►"               // текст кнопки
        highlighted: true       // делает кнопку черной(стиль такой)
        enabled: false          // делаем кнопку недоступной(чтобы нельзя было нажать), когда запустили программу, так как файл для воспроизведения еще не выбран
        onClicked:              // что делает при нажатии на нее -
        {
            keya.focus = true;       // фокус на кнопку A, чтобы проигрывание на кнопки работало
            gg.play();               // запускает аудиофайл, у которого id - gg
            bStart.visible = false;  // так как мы запустили музыку, то нужно убрать кнопку запуска
            bPause.visible = true;   // и показать кнопку паузы
            bRefresh.enabled = true; // и показать кнопку сброса в начало
        }                            // и так далее, меняются только свойства других кнопок и назнвачения
    }

    Button {                     //-----------Кнопка проигрывания с начала------------------------------------------------------------
        id: bRefresh
        width: 25
        x:104
        y:505
        text: "↺"
        highlighted: true
        enabled: false
        onClicked:                   // что делает при нажатии на нее:
        {
            keya.focus = true;       // фокус на кнопку A, чтобы проигрывание на кнопки работало
            gg.stop();               // останавливает аудиофайл, у которого id - gg, чтобы
            gg.play();               // снова ее запустить, чтобы начать проигрывать с начала
            bStart.visible = false;  // раз запустили с начала трек, то кнопку запуска мызыки убираем
            bPause.visible = true;   // показываем кнопку паузы
            bRefresh.enabled = true; // делаем доступной кнопку проигрывания с начала, так как когда мы делаем gg.stop(), то у нас выполняются команды, которые отключают эти 3 кнопки выше
        }
    }

    Button {                     //-----------Кнопка паузы------------------------------------------------------------
        id: bPause
        x:1
        y:505
        text: " ▍▍"
        visible: false
        highlighted: true
        onClicked:                   // что делает при нажатии на нее:
        {
            keya.focus = true;      // фокус на кнопку A, чтобы проигрывание на кнопки работало
            gg.pause();             // останавливает аудиофайл, у которого id - gg
            bPause.visible = false; // так как мы нажали кнопку паузы, то ее нужно скрыть
            bStart.visible = true;  // и показать кнопку запуска
        } 
    }

    Button {                     //-----------Кнопка выбора файла------------------------------------------------------------
        x:154
        y:505
        text: "Выбрать файл..."
        highlighted: true
        onClicked:               // что делает при нажатии на нее:
        {
            keya.focus = true;          // фокус на кнопку A, чтобы проигрывание на кнопки работало
            gg.stop();                  // останавливает аудиофайл, у которого id - gg, так мы загружаем новый трек или тот же, но запускаться он будет с начала
            fileDialog.visible = true;  // открываем окно выбора файла
            bStart.enabled = false;     // запрещаем нажимать на кнопку запуска музыки, так как мы ее выбираем (на всякий случай)
            bPause.visible = false;     // скрываем кнопку паузы
            bStart.visible = true;      // и показываем кнопку запуска (так как мы после загрузки только запустить трек можем)
            bRefresh.enabled = false;   // кнопку запуска с начала тоже делаем недоступной, так как и так трек будет с начала запускаться после нажатия на кнопку запуска
        }
    }                            //===============================================================================================================================

    FileDialog {                                     // =================Диалоговое окно===========================
        id: fileDialog                               // его id, чтобы можно было обращаться к его свойствам
        title: "Выберите файл..."                    // заголовок диалогового окна
        folder: shortcuts.home                       // где будем находиться, когда окно отрылось(в данном случае в домашнем каталоге - в папке пользователя)
        nameFilters: [ "Music Files (*.mp3 *.wav)"]  // какие файлы можно будет выбрать и будет показывать(в данном случае форматы музыки - .mp3 и .wav)
        onAccepted: {                                // что делать если мы выбрали трек
            path = fileDialog.fileUrl;               // получаем полный путь до файла
            bStart.enabled = true;                   // делаем кнопку запуска доступной для нажатия, так мы выбрали трек и его возможно будет воспроизвести
            getStatus(fileDialog.fileUrl);           // отправляет полный путь к файлу в функцию getStatus, которую я описал выше, чтобы получить только название файла
        }
        onRejected: {                                // что делать, если мы отрыли окно, ничего не выбрали и просто его закрыли
            if(status.text !== "**<...>**")          // проверяем: если какой-то файл уже был до этого открыт, то
                bStart.enabled = true;               // делаем кноку запуска музыки доступной для нажатия, иначе нет
        }                                            // это чтобы если мы до этого выбрали файл, открыли выбор файла и закрыли, чтобы кнопка стала доступной
    }                                                // так как до этого у нас уже был открыт трек для запуска

    Text {                                             //=============Текст: Выбран файл... =====================================
        x: 1                                           // координаты по x
        y: 545                                         // координаты по у
        text: "<b>Выбран файл:</b> "                   // текст кнопки, ** делают его жирным
        color: Qt.rgba(53/255, 54/255, 55/255)         // цвет текста
        font.pixelSize: 15                             // размер текста
        style: Text.Outline                            // стиль текста(в данном случае обводка текста)
        styleColor: Qt.rgba(200/255, 200/255, 200/255) // цвет обводки текста
    }

    Text {                                             //=============Текст: какой файл открыт =====================================
        id: status                                     // его id, чтобы можно было обращаться к его свойствам
        x: 116                                         // координаты по x
        y: 545                                         // координаты по у
        text: "<b>...</b>"                             // текст кнопки(жирный)
        color: Qt.rgba(53/255, 54/255, 55/255)         // цвет текста
        font.pixelSize: 15                             // размер текста
        style: Text.Outline                            // стиль текста(в данном случае обводка текста)
        styleColor: Qt.rgba(200/255, 200/255, 200/255) // цвет обводки текста
    }
  }
}

