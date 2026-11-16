#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptScriptDir%
CoordMode, Pixel, Screen
global version := "1.0"

#Include %A_ScriptDir%\lib\Gdip_All.ahk
#Include %A_ScriptDir%\lib\Gdip_ImageSearch.ahk
#Include %A_ScriptDir%\lib\OCR\OCR.ahk

IconsPath := A_ScriptDir . "\icons"


global delayLoop := 1000

global isRunning := false
global isTradeRunning := false
global isChecking := false
global discordLink := "https://discord.gg/AKUtsqddVX"
global funpayLink := "https://funpay.com/users/20494621/"

global SetingsMsg := ""
global SetingsCur := 0

global WebHookURL := ""
global WebHookCheckBox := 0
global WebHookCheckBoxAlarmEnd := 0
global WebHookCheckBoxMsgTradeStart := 0
global WebHookCheckBoxMsgTradeEnd := 0
global WebHookCheckBoxScreenshotTrade := 0

global MaxLogLines := 10  
global hLogBox := 0       
global LogTextData := ""  

global TradeX := 0
global TradeY := 565
global TradeW := 280
global TradeH := 335

SysGet, screenWidth, 0
SysGet, screenHeight, 1
if (screenWidth != 1920 || screenHeight != 1080) {
    LogMessage("Screen Resolution: " screenWidth "x" screenHeight " (Required: 1920x1080)")
}

OnMessage(0x0201, "WM_LBUTTONDOWN")

Gui, Font, s10 cffffff, 9CA3AF, Segoe UI
Gui, -Caption +Border
Gui, Color, 000000

Gui, Font, s20 cffffff, 9CA3AF, Segoe UI
Gui, Add, Text, x20 y10 h15, HolyMacro
Gui, Font, s11 cffffff, 9CA3AF, Segoe UI

Gui, Font, s30 ffffff, 9CA3AF, Segoe UI
Gui, Add, Text, x380 y3 w50 h50 gMinimizeGui, _

Gui, Tab, 1
Gui, Font, s11 cffffff, 9CA3AF, Segoe UI
Gui, Add, Tab3, x10 y55 w400 h320, Главная|Товар|Настройки|Вебхук
Gui, Font, s16 cffffff, 9CA3AF, Segoe UI
Gui, Add, Button, x90 y200 w240 h50 vStartButton gStartMacro, ▶ ЗАПУСТИТЬ
Gui, Font, s12 , 9CA3AF, Segoe UI
Gui, Add, Text, x0 y345 w420 h420 Center, F3 для выхода





Gui, Tab, 2
Gui, Font, s11 cffffff, 9CA3AF, Segoe UI

Gui, Add, Text, x25 y90 w200 h25, Крафт
Gui, Add, Button, x25 y115 w170 h30 gOpenSetingsWindowCraft, Настроить

Gui, Add, Text, x25 y155 w200 h25, Протоартефакты
Gui, Add, Button, x25 y180 w170 h30 gOpenSetingsWindowProtoartifacts, Настроить

Gui, Add, Text, x25 y220 w200 h25, Инструменты и запчасти
Gui, Add, Button, x25 y245 w170 h30 gOpenSetingsWindowTools, Настроить

Gui, Add, Text, x210 y90 w200 h25, Мякоть и трава
Gui, Add, Button, x210 y115 w170 h30 gOpenSetingsWindowGrass, Настроить

Gui, Add, Text, x210 y155 w200 h25, Сезонные ящики
Gui, Add, Button, x210 y180 w170 h30 gOpenSetingsWindowSeasonBox, Настроить

Gui, Add, Text, x210 y220 w200 h25, Подарки и кейсы
Gui, Add, Button, x210 y245 w170 h30 gOpenSetingsWindowGifts, Настроить


GetSavedPrice(itemName, ByRef isChecked, defaultVal := "0") {
    pricesFile := A_ScriptDir . "\config\Prices.ini"
    selectedFile := A_ScriptDir . "\config\SelectedItems.ini"
    
    isChecked := 0
    val := ""

    if FileExist(selectedFile) {
        IniRead, selVal, %selectedFile%, Selected, %itemName%, MISSING
        
        if (selVal != "MISSING") {
            isChecked := 1 
            val := selVal
        }
    }

    if (val = "" || val = "ERROR") {
        if FileExist(pricesFile) {
            IniRead, val, %pricesFile%, Prices, %itemName%, %defaultVal%
        }
    }

    return (val = "ERROR" || val = "") ? defaultVal : val
}

OpenSetingsWindowCraft() {
    global

    Gui, 3:+AlwaysOnTop -Caption +Border
    Gui, 3:Color, 000000

    col1 := []
    col1.Push(Object("name", "Набор специй"))
    col1.Push(Object("name", "Дрожжи"))
    col1.Push(Object("name", "Помидор"))
    col1.Push(Object("name", "Чеснок"))
    col1.Push(Object("name", "Полутухая рыба"))
    col1.Push(Object("name", "Животный жир"))
    col1.Push(Object("name", "Колбасная нарезка"))
    col1.Push(Object("name", "Масло кабана"))
    col1.Push(Object("name", "Масло хрюши"))
    col1.Push(Object("name", "Масло шавки"))
    col1.Push(Object("name", "Копыто сильного кабана"))
    col1.Push(Object("name", "Банка с пшеном"))
    col1.Push(Object("name", "Молоко"))
    col1.Push(Object("name", "Фасолевый суп"))
    col1.Push(Object("name", "Жаркое из мутантов"))
    col1.Push(Object("name", "Армейские галеты"))
    col1.Push(Object("name", "Тесто"))
    col1.Push(Object("name", "Протёртые овощи"))
    col1.Push(Object("name", "Пломбир"))
    col1.Push(Object("name", "Лимон"))
    col1.Push(Object("name", "Хорог"))
    col1.Push(Object("name", "Боевой горох"))
    col1.Push(Object("name", "Варёный тунец"))
    col1.Push(Object("name", "Кофе"))
    col1.Push(Object("name", "Красная икра"))
    col1.Push(Object("name", "Отличная тушёнка"))
    col1.Push(Object("name", "Шпроты"))
    col1.Push(Object("name", "Аномальное шампанское"))
    col1.Push(Object("name", "Игристое шампанское"))


    col2 := []
    col2.Push(Object("name", "Реагенты"))
    col2.Push(Object("name", "Ртуть"))
    col2.Push(Object("name", "Нефть"))
    col2.Push(Object("name", "Нитроглицерин"))
    col2.Push(Object("name", "Глицерин"))
    col2.Push(Object("name", "Ацетилхлорид"))
    col2.Push(Object("name", "Хлор"))
    col2.Push(Object("name", "Психореагент"))
    col2.Push(Object("name", "Аминокислота"))
    col2.Push(Object("name", "Раствор йода"))
    col2.Push(Object("name", "Плазма крови"))
    col2.Push(Object("name", "Мутаген"))
    col2.Push(Object("name", "Теломераза"))
    col2.Push(Object("name", "Протромбин"))
    col2.Push(Object("name", "Водород"))
    col2.Push(Object("name", "Метан"))
    col2.Push(Object("name", "Нашатырь"))
    col2.Push(Object("name", "Углекислый газ"))
    col2.Push(Object("name", "Адреналин"))
    col2.Push(Object("name", "Гормоны"))
    col2.Push(Object("name", "Алюминиевый порошок"))
    col2.Push(Object("name", "Селитра"))
    col2.Push(Object("name", "Порох"))
    col2.Push(Object("name", "Дымный порох"))
    col2.Push(Object("name", "Хлорид алюминия"))
    col2.Push(Object("name", "Поташ"))
    col2.Push(Object("name", "Серная соль"))
    col2.Push(Object("name", "Промышленный растворитель"))


    col3 := []
    col3.Push(Object("name", "Остатки приборов «Шепота»"))
    col3.Push(Object("name", "Набор болтов"))
    col3.Push(Object("name", "Мультитул"))
    col3.Push(Object("name", "Железо"))
    col3.Push(Object("name", "Консервная банка"))
    col3.Push(Object("name", "Скворвода"))
    col3.Push(Object("name", "Кастрюля"))
    col3.Push(Object("name", "Сменный аккумулятор"))
    col3.Push(Object("name", "Сталь"))
    col3.Push(Object("name", "Набор кухонных ножей"))
    col3.Push(Object("name", "Газовый баллон"))
    col3.Push(Object("name", "Защитное снаряжение"))
    col3.Push(Object("name", "Аммиак"))
    col3.Push(Object("name", "Азотная кислота"))
    col3.Push(Object("name", "Серная кислота"))
    col3.Push(Object("name", "Колба с раствором"))
    col3.Push(Object("name", "Кровяная сыворотка"))
    col3.Push(Object("name", "Голова крысы"))
    col3.Push(Object("name", "Глаз зомби"))
    col3.Push(Object("name", "Опухоль мертвеца"))
    col3.Push(Object("name", "Гипофиз мертвеца"))
    col3.Push(Object("name", "Сердце Линь"))
    col3.Push(Object("name", "Тёмный Линь"))
    col3.Push(Object("name", "Чёрная селезёнка"))
    col3.Push(Object("name", "Селезенка мутанта из Любеча"))
    col3.Push(Object("name", "Сердце мутанта из Любеча"))
    col3.Push(Object("name", "Зажигательное покрытие"))
    col3.Push(Object("name", "Нейродетегенар"))
    col3.Push(Object("name", "Мутировавшие ферменты"))


    col4 := []
    col4.Push(Object("name", "Светящийся сахар"))
    col4.Push(Object("name", "Аномальная пыль"))
    col4.Push(Object("name", "Хрононыль"))
    col4.Push(Object("name", "Пыль изменения"))
    col4.Push(Object("name", "Странный артефакт"))
    col4.Push(Object("name", "Электросмесь"))
    col4.Push(Object("name", "Термическая смесь"))
    col4.Push(Object("name", "Морозная смесь"))
    col4.Push(Object("name", "Ноотроп"))
    col4.Push(Object("name", "Коагулянт"))
    col4.Push(Object("name", "Полимеры"))
    col4.Push(Object("name", "Ткань"))
    col4.Push(Object("name", "Клей"))
    col4.Push(Object("name", "Перчатки"))
    col4.Push(Object("name", "Гнилые доски"))
    col4.Push(Object("name", "Смазочные материалы"))
    col4.Push(Object("name", "Древесный уголь"))
    col4.Push(Object("name", "Технический спирт"))
    col4.Push(Object("name", "Борная кислота"))
    col4.Push(Object("name", "Едкий натрий"))
    col4.Push(Object("name", "Гремучая ртуть"))
    col4.Push(Object("name", "Динамит"))
    col4.Push(Object("name", "Гипс"))
    col4.Push(Object("name", "Самодельный светощум"))
    col4.Push(Object("name", "Граната «Кустарник-1»"))
    col4.Push(Object("name", "Бутылка чистой воды"))
    col4.Push(Object("name", "Пластиковая бутылка"))

    _craftGroups := []
    _craftGroups.Push(Object("title", "Кулинария", "list", col1, "chkX", 30,  "editX", 240,  "startY", 47))
    _craftGroups.Push(Object("title", "Реагенты",      "list", col2, "chkX", 460, "editX", 670,  "startY", 47))
    _craftGroups.Push(Object("title", "Дроп с монстров", "list", col3, "chkX", 890, "editX", 1100, "startY", 47))
    _craftGroups.Push(Object("title", "Артефакты и материалы",     "list", col4, "chkX", 1320, "editX", 1530, "startY", 47))

    idx := 0
    for g, grp in _craftGroups {
        chkX := grp.chkX
        editX := grp.editX
        startY := grp.startY
        title := grp.title

        Gui, 3:Font, s14 cffffff, 9CA3AF, Segoe UI
        Gui, 3:Add, Text, x%chkX% y15 w420 h30 Center, %title%

        y := startY
        for i, it in grp.list {
            idx++
            name := it.name
            savedPrice := GetSavedPrice(name, isChecked, "0")
            
            Gui, 3:Font, s11 cFFFFFF, Segoe UI
            Gui, 3:Add, Checkbox, Checked%isChecked% vCraftChk%idx% x%chkX% y%y% w210 h20, %name%
            Gui, 3:Color, ,1E1E1E
            Gui, 3:Add, Edit, vCraftPrice%idx% x%editX% y%y% w150 h20 -E0x200 +Border, %savedPrice%
            y += 25
        }
    }

    Gui, 3:Font, s11 cffffff, 9CA3AF, Segoe UI
    Gui, 3:Add, Button, x20 y820 w100 h30 gSaveCraft, Сохранить
    Gui, 3:Font, s11 cffffff, 9CA3AF, Segoe UI
    Gui, 3:Add, Button, x140 y820 w100 h30 gcloseWindow, Отмена

    Gui, 3:Show, w1710 h870, HolyMacro
}

OpenSetingsWindowProtoartifacts() {
    global
    Gui, 3:Destroy
    Gui, 3:+AlwaysOnTop -Caption +Border
    Gui, 3:Color, 000000

    g1 := []
    g1.Push(Object("name", "Протоартефакт (Обычный)",        "h", 25))
    g1.Push(Object("name", "Протоартефакт (Необычный)",      "h", 40))
    g1.Push(Object("name", "Протоартефакт (Особый)",         "h", 25))
    g1.Push(Object("name", "Протоартефакт (Редкий)",         "h", 25))
    g1.Push(Object("name", "Протоартефакт (Исключительный)", "h", 40))

    g2 := []
    g2.Push(Object("name", "Малый артефактный фрагмент",    "h", 25))
    g2.Push(Object("name", "Обычный артефактный фрагмент",  "h", 25))
    g2.Push(Object("name", "Крупный артефактный фрагмент",  "h", 25))
    g2.Push(Object("name", "Огромный артефактный фрагмент", "h", 25))



    _protoGroups := []
    _protoGroups.Push(Object("title", "Протоартефакты",            "list", g1, "chkX", 25, "editX", 280, "startY", 45,  "gap", 4))
    _protoGroups.Push(Object("title", "Артефактные фрагменты",     "list", g2, "chkX", 25, "editX", 280, "startY", 265, "gap", 4))


    idx := 0
    for g, grp in _protoGroups {
        chkX := grp.chkX
        editX := grp.editX
        startY := grp.startY
        gap := grp.gap
        title := grp.title

        textY := startY - 32

        Gui, 3:Font, s14 cFFFFFF, Segoe UI
        Gui, 3:Add, Text, x0 y%textY% w420 h28 Center, %title%

        y := startY
        for i, it in grp.list {
            idx++
            name := it.name
            h := it.h
            editY := y + (h - 20) // 2
            savedPrice := GetSavedPrice(name, isChecked, "0")

            Gui, 3:Font, s11 cFFFFFF, Segoe UI
            Gui, 3:Add, Checkbox, Checked%isChecked% vProtoChk%idx% x%chkX% y%y% w245 h%h%, %name%

            Gui, 3:Color, , 1E1E1E
            Gui, 3:Add, Edit, vProtoPrice%idx% x%editX% y%editY% w115 h20 -E0x200 +Border, %savedPrice%
            y += h + gap
        }

    }

    Gui, 3:Font, s11 cFFFFFF, Segoe UI
    Gui, 3:Add, Button, x25 y630 w100 h30 gSaveProtoartifacts, Сохранить
    Gui, 3:Add, Button, x145 y630 w100 h30 gcloseWindow, Отмена

    Gui, 3:Show, w420 h680, HolyMacro
}

OpenSetingsWindowTools() {
    global

    Gui, 4:Destroy
    Gui, 4:+AlwaysOnTop -Caption +Border
    Gui, 4:Color, 000000

    g1 := []
    g1.Push(Object("name", "Продвинутые запчасти",  "h", 25))
    g1.Push(Object("name", "Стандартные запчасти",  "h", 25))
    g1.Push(Object("name", "Дешевые запчасти",      "h", 25))

    g2 := []
    g2.Push(Object("name", "Продвинутые инструменты", "h", 25))
    g2.Push(Object("name", "Стандартные инструменты", "h", 25))
    g2.Push(Object("name", "Дешевые инструменты",     "h", 25))

    g3 := []
    g3.Push(Object("name", "Набор компонентов оружия (Мастер)",  "h", 42))
    g3.Push(Object("name", "Набор компонентов оружия (Ветеран)", "h", 42))
    g3.Push(Object("name", "Набор компонентов оружия (Новичок)", "h", 42))

    g4 := []
    g4.Push(Object("name", "Набор компонентов брони (Мастер)",  "h", 42))
    g4.Push(Object("name", "Набор компонентов брони (Ветеран)", "h", 42))
    g4.Push(Object("name", "Набор компонентов брони (Новичок)", "h", 42))

    _toolsGroups := []
    _toolsGroups.Push(Object("title", "Запчасти",          "list", g1, "chkX", 25, "editX", 265, "startY", 45,  "step", 26))
    _toolsGroups.Push(Object("title", "Инструменты",       "list", g2, "chkX", 25, "editX", 265, "startY", 165, "step", 26))
    _toolsGroups.Push(Object("title", "Компоненты оружия", "list", g3, "chkX", 25, "editX", 265, "startY", 285, "step", 44))
    _toolsGroups.Push(Object("title", "Компоненты брони",  "list", g4, "chkX", 25, "editX", 265, "startY", 455, "step", 44))

    idx := 0
    for g, grp in _toolsGroups {
        chkX := grp.chkX
        editX := grp.editX
        startY := grp.startY
        step := grp.step
        title := grp.title

        textY := startY - 32

        Gui, 4:Font, s14 cFFFFFF, Segoe UI
        Gui, 4:Add, Text, x0 y%textY% w420 h28 Center, %title%

        y := startY
        for i, it in grp.list {
            idx++
            name := it.name
            h := it.h
            editY := y + (h - 20) // 2
            savedPrice := GetSavedPrice(name, isChecked, "0")

            Gui, 4:Font, s11 cFFFFFF, Segoe UI
            Gui, 4:Add, Checkbox, Checked%isChecked% vToolsChk%idx% x%chkX% y%y% w230 h%h%, %name%

            Gui, 4:Color, , 1E1E1E
            Gui, 4:Add, Edit, vToolsPrice%idx% x%editX% y%editY% w130 h20 -E0x200 +Border, %savedPrice%
            y += step
        }

    }

    Gui, 4:Font, s11 cFFFFFF, Segoe UI
    Gui, 4:Add, Button, x25 y630 w100 h30 gSaveTools, Сохранить
    Gui, 4:Add, Button, x145 y630 w100 h30 gcloseWindow, Отмена

    Gui, 4:Show, w420 h680, HolyMacro
}



OpenSetingsWindowGrass() {
    global 
    Gui, 5:Destroy 
    Gui, 5:+AlwaysOnTop -Caption +Border
    Gui, 5:Color, 000000

    g1 := []
    g1.Push(Object("name", "Мякоть солевика"))
    g1.Push(Object("name", "Мякоть мятноплода"))
    g1.Push(Object("name", "Мякоть сластены"))
    g1.Push(Object("name", "Мякоть спиртеня"))
    g1.Push(Object("name", "Мякоть куборбуза"))
    g1.Push(Object("name", "Мякоть лимонника"))

    g2 := []
    g2.Push(Object("name", "Тусклые минералы"))
    g2.Push(Object("name", "Изумрудные минералы"))
    g2.Push(Object("name", "Лазурные минералы"))
    g2.Push(Object("name", "Пурпурные минералы"))
    g2.Push(Object("name", "Алые минералы"))
    g2.Push(Object("name", "Золотые минералы"))

    g3 := []
    g3.Push(Object("name", "Бледнолист"))
    g3.Push(Object("name", "Кислотная крапива"))
    g3.Push(Object("name", "Водонос"))
    g3.Push(Object("name", "Гнозис"))
    g3.Push(Object("name", "Чертоцвет"))
    g3.Push(Object("name", "Янтарная полынь"))

    _grassGroups := []
    _grassGroups.Push(Object("title", "Мякоть", "list", g1, "chkX", 30, "editX", 240, "startY", 50, "step", 25))
    _grassGroups.Push(Object("title", "Минералы", "list", g2, "chkX", 30, "editX", 240, "startY", 250, "step", 25))
    _grassGroups.Push(Object("title", "Трава", "list", g3, "chkX", 30, "editX", 240, "startY", 450, "step", 25))

    idx := 0
    for g, grp in _grassGroups {
        chkX := grp.chkX
        editX := grp.editX
        startY := grp.startY
        step := grp.step
        title := grp.title
        textY := startY - 35

        Gui, 5:Font, s14 cFFFFFF, Segoe UI
        Gui, 5:Add, Text, x0 y%textY% w420 h30 Center, %title%

        y := startY
        for i, it in grp.list {
            idx++
            name := it.name
            editY := y + 3
            savedPrice := GetSavedPrice(name, isChecked, "0")
            Gui, 5:Font, s11 cFFFFFF, Segoe UI
            Gui, 5:Add, Checkbox, Checked%isChecked% vGrassChk%idx% x%chkX% y%y% w210 h25, %name%

            Gui, 5:Color, , 1E1E1E
            Gui, 5:Add, Edit, vGrassPrice%idx% x%editX% y%editY% w150 h20 -E0x200 +Border, %savedPrice%

            y += step
        }
    }

    Gui, 5:Font, s11 cFFFFFF, Segoe UI
    Gui, 5:Add, Button, x20 y630 w100 h30 gSaveGrass, Сохранить
    Gui, 5:Add, Button, x140 y630 w100 h30 gcloseWindow, Отмена

    Gui, 5:Show, w420 h680, HolyMacro
}


OpenSetingsWindowSeasonBox() {
    global

    Gui, 6:+AlwaysOnTop -Caption +Border
    Gui, 6:Color, 000000

    Gui, 6:Font, s14 cffffff, Segoe UI
    Gui, 6:Add, Text, x0 y15 w420 h30 Center, Сезонные ящики

    items := []
    items.Push(Object("name", "Промерзший хабар", "y", 50))
    items.Push(Object("name", "Загадочная добыча", "y", 75))
    items.Push(Object("name", "Дар «Шепота»", "y", 100))
    items.Push(Object("name", "Забытые припасы", "y", 125))
    items.Push(Object("name", "Черный Презент", "y", 150))
    items.Push(Object("name", "Тактический запас", "y", 175))
    items.Push(Object("name", "Благодать Перуна", "y", 200))

    idx := 0
    for i, it in items {
        idx++
        name := it.name
        y := it.y
        editY := y + 3 
        
        savedPrice := GetSavedPrice(name, isChecked, "0")
        Gui, 6:Font, s11 cffffff, Segoe UI
        Gui, 6:Add, Checkbox, Checked%isChecked% vSeasonChk%idx% x30 y%y% w210 h25, %name%
        Gui, 6:Color, ,1E1E1E
        Gui, 6:Font, s11 cffffff,, Segoe UI
        Gui, 6:Add, Edit, vSeasonPrice%idx% x240 y%editY% w150 h20 -E0x200 +Border, %savedPrice%
    }

    ; Gui, 6:Font, s14 cffffff, Segoe UI
    ; Gui, 6:Add, Text, x0 y340 w420 h30 Center, Кейсы с обликами

    ; cases := []
    ; cases.Push(Object("name", "Кейс с обликами «Операции Криостазис»", "y", 375))
    ; cases.Push(Object("name", "Кейс с обликами «Черного Рынка»", "y", 410))
    ; cases.Push(Object("name", "Кейс с обликами «Корпорации ZIVCAS»", "y", 445))
    ; cases.Push(Object("name", "Кейс с обликами «Славянской весны»", "y", 480))

    ; idx := 0
    ; for i, it in cases {  ; <-- Fixed: was looping over "items" instead of "cases"
    ;     idx++
    ;     name := it.name
    ;     y := it.y
    ;     editY := y + 3
        
    ;     Gui, 6:Font, s11 cffffff, Segoe UI
    ;     Gui, 6:Add, Checkbox, vCaseChk%idx% x30 y%y% w210 h45, %name%  ; <-- Fixed: changed from vSeasonChk to vCaseChk
    ;     Gui, 6:Color, ,1E1E1E
    ;     Gui, 6:Font, s10 cffffff,, Segoe UI
    ;     Gui, 6:Add, Edit, vCasePrice%idx% x240 y%editY% w150 h20 -E0x200 +Border, 0  ; <-- Fixed: changed from vSeasonPrice to vCasePrice
    ; }

    Gui, 6:Font, s11 cffffff, Segoe UI
    Gui, 6:Add, Button, x20 y630 w100 h30 gSaveSeasonBox, Сохранить
    Gui, 6:Font, s11 cffffff, Segoe UI
    Gui, 6:Add, Button, x140 y630 w100 h30 gcloseWindow, Отмена

    Gui, 6:Show, w420 h680, HolyMacro

    _seasonItems := items
    _caseItems := cases
}

OpenSetingsWindowGifts() {
    global
    
    Gui, 7:Destroy
    Gui, 7:+AlwaysOnTop -Caption +Border
    Gui, 7:Color, 000000
    Gui, 7:Font, s14 cffffff, Segoe UI
    Gui, 7:Add, Text, x0 y15 w420 h30 Center, Подарки и кейсы

    giftsList := []
    giftsList.Push(Object("name", "Подарок 1"))
    giftsList.Push(Object("name", "Подарок 2"))
    giftsList.Push(Object("name", "Подарок 3"))
    giftsList.Push(Object("name", "Кейс 1"))
    giftsList.Push(Object("name", "Кейс 2"))
    giftsList.Push(Object("name", "Кейс 3"))

    _giftsGroups := []
    _giftsGroups.Push(Object("title", "Подарки", "list", giftsList, "chkX", 30, "editX", 240, "startY", 50, "step", 25))

    idx := 0
    for g, grp in _giftsGroups {
        chkX := grp.chkX
        editX := grp.editX
        startY := grp.startY
        step := grp.step
        title := grp.title
        textY := startY - 35
        y := startY
        for i, it in grp.list {
            idx++
            name := it.name
            editY := y + 3
            
            savedPrice := GetSavedPrice(name, isChecked, "0")
            
            Gui, 7:Font, s11 cffffff, Segoe UI
            Gui, 7:Add, Checkbox, Checked%isChecked% vGiftsChk%idx% x%chkX% y%y% w210 h25, %name%
            
            Gui, 7:Color, ,1E1E1E
            Gui, 7:Font, s11 cffffff,, Segoe UI
            Gui, 7:Add, Edit, vGiftsPrice%idx% x%editX% y%editY% w150 h20 -E0x200 +Border, %savedPrice%
            y += step
        }
    }

    Gui, 7:Font, s11 cffffff, Segoe UI
    Gui, 7:Add, Button, x20 y630 w100 h30 gSaveGifts, Сохранить
    Gui, 7:Font, s11 cffffff, Segoe UI
    Gui, 7:Add, Button, x140 y630 w100 h30 gcloseWindow, Отмена
    Gui, 7:Show, w420 h680, HolyMacro
}



SaveGifts() {
    global _giftsGroups
    Gui, 7:Submit, NoHide
    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%

    pricesFile := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"
    idx := 0

    for g, grp in _giftsGroups {

        for i, it in grp.list {
            idx++
            v := GiftsPrice%idx%
            IniWrite, %v%, %pricesFile%, Prices, % it.name

            if (GiftsChk%idx%) {
                IniWrite, %v%, %selectedFile%, Selected, % it.name
            } else {
                IniDelete, %selectedFile%, Selected, % it.name
            }
        }
    }
}

SaveCraft() {
    global _craftGroups
    Gui, 3:Submit, NoHide

    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%
    pricesFile   := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"

    idx := 0
    for g, grp in _craftGroups {
        for i, it in grp.list {
            idx++
            v := CraftPrice%idx%
            IniWrite, %v%, %pricesFile%, Prices, % it.name
            if (CraftChk%idx%)
                IniWrite, %v%, %selectedFile%, Selected, % it.name
            else
                IniDelete, %selectedFile%, Selected, % it.name
        }
    }
}

SaveProtoartifacts() {
    global _protoGroups
    Gui, 3:Submit, NoHide

    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%
    pricesFile   := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"

    idx := 0
    for g, grp in _protoGroups {
        for i, it in grp.list {
            idx++
            v := ProtoPrice%idx%
            IniWrite, %v%, %pricesFile%, Prices, % it.name
            if (ProtoChk%idx%)
                IniWrite, %v%, %selectedFile%, Selected, % it.name
            else
                IniDelete, %selectedFile%, Selected, % it.name
        }
    }
}

SaveTools() {
    global _toolsGroups
    Gui, 4:Submit, NoHide

    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%
    pricesFile   := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"

    idx := 0
    for g, grp in _toolsGroups {
        for i, it in grp.list {
            idx++
            v := ToolsPrice%idx%
            IniWrite, %v%, %pricesFile%, Prices, % it.name
            if (ToolsChk%idx%)
                IniWrite, %v%, %selectedFile%, Selected, % it.name
            else
                IniDelete, %selectedFile%, Selected, % it.name
        }
    }
}

SaveGrass() {
    global _grassGroups
    Gui, 5:Submit, NoHide

    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%
    pricesFile   := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"

    idx := 0
    for g, grp in _grassGroups {
        for i, it in grp.list {
            idx++
            v := GrassPrice%idx%
            IniWrite, %v%, %pricesFile%, Prices, % it.name
            if (GrassChk%idx%)
                IniWrite, %v%, %selectedFile%, Selected, % it.name
            else
                IniDelete, %selectedFile%, Selected, % it.name
        }
    }
}

SaveSeasonBox() {
    global _seasonItems, _caseItems
    Gui, 6:Submit, NoHide

    cfgDir := A_ScriptDir . "\config\"
    if !FileExist(cfgDir)
        FileCreateDir, %cfgDir%
    pricesFile   := cfgDir . "Prices.ini"
    selectedFile := cfgDir . "SelectedItems.ini"

    for i, it in _seasonItems {
        val := SeasonPrice%i%
        IniWrite, %val%, %pricesFile%, Prices, % it.name
    }
    for i, it in _caseItems {
        val := CasePrice%i%
        IniWrite, %val%, %pricesFile%, Prices, % it.name
    }
    for i, it in _seasonItems {
        if (SeasonChk%i%) {
            val := SeasonPrice%i%
            IniWrite, %val%, %selectedFile%, Selected, % it.name
        } else {
            IniDelete, %selectedFile%, Selected, % it.name
        }
    }
    for i, it in _caseItems {
        if (CaseChk%i%) {
            val := CasePrice%i%
            IniWrite, %val%, %selectedFile%, Selected, % it.name
        } else {
            IniDelete, %selectedFile%, Selected, % it.name
        }
    }
}

Gui, Tab, 3
Gui, Font, s20 cffffff, 9CA3AF, Segoe UI
Gui, Add, Text, x20 y10 h15, HolyMacro
Gui, Font, s11 cffffff, 9CA3AF, Segoe UI

Gui, Add, Text, x25 y85 w400 h15, Текст сообщения для отправки в чат(140 символов)
Gui, Color, ,1E1E1E
Gui, Font, s10 1E1E1E,, Segoe UI
Gui, Add, Edit, x24 y105 w380 h25 -E0x200 +Border vInputMsg, %SetingsMsg%
GuiControl, +Limit, InputMsg 

Gui, Add, Text, x25 y140 w400 h15, Кол-во денег которое можно потратить
Gui, Color, ,1E1E1E
Gui, Font, s10 1E1E1E,, Segoe UI
Gui, Add, Edit, x24 y160 w380 h25 -E0x200 +Border vInputCur, %SetingsCur%
Gui, Add, Button, x30 y325 w100 h30 gSaveInput, Сохранить


Gui, Tab, 4
Gui, Font, s20 cffffff, 9CA3AF, Segoe UI
Gui, Add, Text, x20 y10 h15, HolyMacro
Gui, Font, s11 cffffff, 9CA3AF, Segoe UI

Gui, Add, Text, x25 y85 w400 h15, Ссылка на вебхук
Gui, Color, ,1E1E1E
Gui, Font, s10 1E1E1E,, Segoe UI
Gui, Add, Edit, x24 y105 w380 h25 -E0x200 +Border vInputWebHook, %WebHookURL%
Gui, Add, Button, x30 y325 w100 h30 gSaveInput, Сохранить

Gui, Add, CheckBox, x27 y135 w150 h25 vWebHookCheckBox, Включить вебхук
Gui, Add, CheckBox, x27 y160 w400 h25 vWebHookCheckBoxAlarmEnd, Включить Оповещение о конце работы макроса
Gui, Add, CheckBox, x27 y185 w400 h25 vWebHookCheckBoxMsgTradeStart, Включить Сообщение о начале трейда
Gui, Add, CheckBox, x27 y210 w400 h25 vWebHookCheckBoxMsgTradeEnd, Включить Сообщение о конце трейда
Gui, Add, CheckBox, x27 y235 w400 h25 vWebHookCheckBoxScreenshotTrade, Включить Автоматический скриншот трейда

pToken := Gdip_Startup()
if (!pToken) {
    MsgBox, Ошибка запуска GDI+! Проверьте Gdip_All.ahk.
    ExitApp
}
OnExit("ExitFunc")

LoadInput()
Gui, Show, w420 h390, HolyMacro
Return

closeWindow() {
    Gui, Destroy
    Return
}

~F3::
if (isRunning) {
    StopMacro()
}


WM_LBUTTONDOWN() {
    PostMessage, 0xA1, 2,,, A
}

MinimizeGui() {
    Gui, Minimize
    return
}

StartMacro() {
    global
    static overlayCreated := false
    if (!overlayCreated) {
        CreateLogOverlay()
        overlayCreated := true
    }
    isRunning := true
    LogTextData := ""
    GuiControl, Log:, %hLogBox%, 
    GuiControl, 1:, StartButton, ⏸ ПАУЗА
    GuiControl, 1:+BackgroundFF5555, StartButton
    Gui, 1:Hide
    Gui, Log:Show, NoActivate 

    LogMessage("Начало работы макроса")
    ; SetTimer, MacroLoop, 1000
    MacroLoop()
}

StopMacro() {
    global
    isRunning := false
    SetTimer, MacroLoop, Off
    Gui, Log:Hide
    GuiControl, 1:, StartButton, ▶ ЗАПУСТИТЬ
    GuiControl, 1:+Background4CAF50, StartButton
    Gui, 1:Show
    LogMessage("Конец работы макроса")
}

SaveInput() {
    Gui, Submit, NoHide
    global WebHookCheckBox
    global WebHookCheckBoxAlarmEnd
    global WebHookCheckBoxMsgTradeStart
    global WebHookCheckBoxMsgTradeEnd
    global WebHookCheckBoxScreenshotTrade

    GuiControlGet, SetingsMsg,, InputMsg
    SetingsMsg := Trim(SetingsMsg)
    GuiControlGet, SetingsCur,, InputCur
    SetingsCur := Trim(SetingsCur)
    GuiControlGet, WebHookURL,, InputWebHook
    WebHookURL := Trim(WebHookURL)

    ConfigFolder := A_ScriptDir . "\config"
    ConfigFile := ConfigFolder . "\macro_settings.ini"

    if (!FileExist(ConfigFolder)) {
        FileCreateDir, %ConfigFolder%
    }

    if (!FileExist(ConfigFile)) {
        IniWrite, %A_Space%, %ConfigFile%, Settings, Message
        IniWrite, 0, %ConfigFile%, Settings, Canspend
        IniWrite, %A_Space%, %ConfigFile%, WebHook, DiscordWebHookURL
        IniWrite, False, %ConfigFile%, WebHook, WebHookEnable
        IniWrite, False, %ConfigFile%, WebHook, WebHookAlarmEnd
        IniWrite, False, %ConfigFile%, WebHook, WebHookMsgTradeStart
        IniWrite, False, %ConfigFile%, WebHook, WebHookMsgTradeEnd
        IniWrite, False, %ConfigFile%, WebHook, WebHookScreenshotTrade
    }

    if (RegExMatch(WebHookURL, "^https://discord\.com/api/webhooks/")) {
        IniWrite, %WebHookURL%, %ConfigFile%, WebHook, DiscordWebHookURL
    } else {
        MsgBox, 16, Ошибка, Введен неверный Discord Webhook!
        return
    }

    if (StrLen(SetingsMsg) > 140) {
        MsgBox, 16, Ошибка, Сообщение слишком длинное! Максимум 140 символов.
        return
    } else {
        IniWrite, %SetingsMsg%, %ConfigFile%, Settings, Message
    }

    if SetingsCur is not integer
    {
        MsgBox, 16, Ошибка, В поле "Кол-во денег которое можно потратить" должно быть число!
        return
    } else {
        IniWrite, %SetingsCur%, %ConfigFile%, Settings, Canspend
    }

    IniWrite, %WebHookCheckBox%, %ConfigFile%, WebHook, WebHookEnable
    IniWrite, %WebHookCheckBoxAlarmEnd%, %ConfigFile%, WebHook, WebHookAlarmEnd
    IniWrite, %WebHookCheckBoxMsgTradeStart%, %ConfigFile%, WebHook, WebHookMsgTradeStart
    IniWrite, %WebHookCheckBoxMsgTradeEnd%, %ConfigFile%, WebHook, WebHookMsgTradeEnd
    IniWrite, %WebHookCheckBoxScreenshotTrade%, %ConfigFile%, WebHook, WebHookScreenshotTrade
    Return
}

LoadInput() {
    global SetingsMsg, SetingsCur, WebHookURL
    global WebHookCheckBox, WebHookCheckBoxAlarmEnd, WebHookCheckBoxMsgTradeStart, WebHookCheckBoxMsgTradeEnd, WebHookCheckBoxScreenshotTrade

    ConfigFile := A_ScriptDir . "\config\macro_settings.ini"

    if (!FileExist(ConfigFile)) {
        return
    }

    IniRead, SetingsMsg, %ConfigFile%, Settings, Message, %A_Space%
    IniRead, SetingsCur, %ConfigFile%, Settings, Canspend, 0
    IniRead, WebHookURL, %ConfigFile%, WebHook, DiscordWebHookURL, %A_Space%
    IniRead, WebHookCheckBox, %ConfigFile%, WebHook, WebHookEnable, 0
    IniRead, WebHookCheckBoxAlarmEnd, %ConfigFile%, WebHook, WebHookAlarmEnd, 0
    IniRead, WebHookCheckBoxMsgTradeStart, %ConfigFile%, WebHook, WebHookMsgTradeStart, 0
    IniRead, WebHookCheckBoxMsgTradeEnd, %ConfigFile%, WebHook, WebHookMsgTradeEnd, 0
    IniRead, WebHookCheckBoxScreenshotTrade, %ConfigFile%, WebHook, WebHookScreenshotTrade, 0

    GuiControl,, InputMsg, %SetingsMsg%
    GuiControl,, InputCur, %SetingsCur%
    GuiControl,, InputWebHook, %WebHookURL%
    GuiControl,, WebHookCheckBox, %WebHookCheckBox%
    GuiControl,, WebHookCheckBoxAlarmEnd, %WebHookCheckBoxAlarmEnd%
    GuiControl,, WebHookCheckBoxMsgTradeStart, %WebHookCheckBoxMsgTradeStart%
    GuiControl,, WebHookCheckBoxMsgTradeEnd, %WebHookCheckBoxMsgTradeEnd%
    GuiControl,, WebHookCheckBoxScreenshotTrade, %WebHookCheckBoxScreenshotTrade%
    return
}


LogMessage(TextToLog) {
    global LogTextData, MaxLogLines, hLogBox
    FormatTime, CurrentTime,, [HH:mm:ss]
    FullLine := CurrentTime " " TextToLog
    
    if (LogTextData = "") {
        LogTextData := FullLine
    } else {
        LogTextData := FullLine "`n" LogTextData
    }
    
    StringSplit, LinesArray, LogTextData, `n
    
    if (LinesArray0 > MaxLogLines) {
        NewText := ""
        Loop, %MaxLogLines% {
            NewText .= LinesArray%A_Index% "`n"
        }
        LogTextData := RTrim(NewText, "`n")
    }
    
    GuiControl, Log:, %hLogBox%, %LogTextData%
}

CreateLogOverlay() {
    global hLogBox
    Gui, Log:+AlwaysOnTop -Caption +ToolWindow +Disabled +E0x20 +LastFound
    Gui, Log:Color, 1A1A1A 
    WinSet, Transparent, 200
    Gui, Log:Font, s11 cFFFFFF, Consolas
    Gui, Log:Add, Text, w450 h180 +BackgroundTrans hwndhLogBox
    Gui, Log:Show, x1400 y800 w500 h173 Hide, MacroOverlayLogs
}

PrepareBitmapForOCR(pBitmap, Scale := 2.5) {
    Width := Gdip_GetImageWidth(pBitmap)
    Height := Gdip_GetImageHeight(pBitmap)

    pTempBitmap := Gdip_CreateBitmap(Width, Height, 0x26200A)
    G1 := Gdip_GraphicsFromImage(pTempBitmap)
    Gdip_DrawImage(G1, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height)
    Gdip_DeleteGraphics(G1)

    Gdip_LockBits(pTempBitmap, 0, 0, Width, Height, Stride, Scan0, BitmapData)

    Loop % Height {
        y := A_Index - 1
        RowOffset := Scan0 + (y * Stride)
        Loop % Width {
            x := A_Index - 1
            PixelAddr := RowOffset + (x * 4)

            B := NumGet(PixelAddr + 0, "UChar")
            G_val := NumGet(PixelAddr + 1, "UChar")
            R := NumGet(PixelAddr + 2, "UChar")

            MaxC := (R > G_val) ? ((R > B) ? R : B) : ((G_val > B) ? G_val : B)
            MinC := (R < G_val) ? ((R < B) ? R : B) : ((G_val < B) ? G_val : B)
            Chroma := MaxC - MinC
            AvgLum := (R + G_val + B) // 3
            IsColorText := (Chroma > 60)

            ; 2. Белый или светло-серый текст (яркость > 160)

            IsLightText := (AvgLum > 160)

            if (IsColorText || IsLightText) {
                NumPut(0xFF000000, PixelAddr + 0, "UInt")
            } else {
                NumPut(0xFFFFFFFF, PixelAddr + 0, "UInt")
            }
        }
    }

    Gdip_UnlockBits(pTempBitmap, BitmapData)

    NewWidth := Round(Width * Scale)
    NewHeight := Round(Height * Scale)
    pNewBitmap := Gdip_CreateBitmap(NewWidth, NewHeight, 0x21808)
    G2 := Gdip_GraphicsFromImage(pNewBitmap)
    Gdip_SetInterpolationMode(G2, 5)
    Gdip_DrawImage(G2, pTempBitmap, 0, 0, NewWidth, NewHeight, 0, 0, Width, Height)
    Gdip_DeleteGraphics(G2)

    Gdip_DisposeImage(pTempBitmap)
    return pNewBitmap
}




BinarizeBitmap(pBitmap, Threshold := 0.5, Invert := false) {
    Width := Gdip_GetImageWidth(pBitmap)
    Height := Gdip_GetImageHeight(pBitmap)
    
    pNewBitmap := Gdip_CreateBitmap(Width, Height)
    G := Gdip_GraphicsFromImage(pNewBitmap)
    
    Contrast := 50.0 
    

    R_w := 0.299 * Contrast
    G_w := 0.587 * Contrast
    B_w := 0.114 * Contrast
    
    if (Invert) {

        R_w := -R_w
        G_w := -G_w
        B_w := -B_w
        Offset := Threshold * Contrast + 0.5
    } else {
        Offset := -Threshold * Contrast + 0.5
    }
        VarSetCapacity(ColorMatrix, 100, 0)
    NumPut(R_w, ColorMatrix, 0, "Float"),  NumPut(R_w, ColorMatrix, 4, "Float"),  NumPut(R_w, ColorMatrix, 8, "Float")
    NumPut(G_w, ColorMatrix, 20, "Float"), NumPut(G_w, ColorMatrix, 24, "Float"), NumPut(G_w, ColorMatrix, 28, "Float")
    NumPut(B_w, ColorMatrix, 40, "Float"), NumPut(B_w, ColorMatrix, 44, "Float"), NumPut(B_w, ColorMatrix, 48, "Float")
    NumPut(1.0, ColorMatrix, 60, "Float") 
    NumPut(Offset, ColorMatrix, 80, "Float"), NumPut(Offset, ColorMatrix, 84, "Float"), NumPut(Offset, ColorMatrix, 88, "Float")
    NumPut(1.0, ColorMatrix, 96, "Float")
    
    DllCall("gdiplus\GdipCreateImageAttributes", "UPtr*", ImageAttr)
    DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "UPtr", ImageAttr, "Int", 1, "Int", 1, "UPtr", &ColorMatrix, "UPtr", 0, "Int", 0)
    DllCall("gdiplus\GdipDrawImageRectRect", "UPtr", G, "UPtr", pBitmap, "Float", 0, "Float", 0, "Float", Width, "Float", Height, "Float", 0, "Float", 0, "Float", Width, "Float", Height, "Int", 2, "UPtr", ImageAttr, "UPtr", 0, "UPtr", 0)
    
    DllCall("gdiplus\GdipDisposeImageAttributes", "UPtr", ImageAttr)
    Gdip_DeleteGraphics(G)
    
    return pNewBitmap
}

SpamChat(TextToSend) {
    if (isRunning){
        SetKeyDelay, 40, 40 

        SendEvent, {Enter Down}
        Sleep, 60
        SendEvent, {Enter Up}
        Sleep, 200

        SendEvent, {Text}%TextToSend%
        Sleep, 150 

        SendEvent, {Enter Down}
        Sleep, 60
        SendEvent, {Enter Up}
        Sleep, 200 
        
        if (IsFunc("LogMessage")) {
            LogMessage("Отправил сообщение в чат")
        }
    }
}

CleanOCRText(Text) {

    Text := RegExReplace(Text, "[\x{FEFF}\r]", "")
    Text := StrReplace(Text, "`t", "")
    Text := StrReplace(Text, ")", "]")
    Text := StrReplace(Text, "-", "")
    Text := StrReplace(Text, "x", "х")
   

    Text := RegExReplace(Text, "i)((?:^|\s)[xх]\s*\d*)[зЗ]", "${1}3")
    Text := RegExReplace(Text, "i)((?:^|\s)[xх]\s*\d*)[бБ]", "${1}6")
    Text := RegExReplace(Text, "i)((?:^|\s)[xх]\s*\d*)[оОoO]", "${1}0")
    Text := RegExReplace(Text, "i)((?:^|\s)[xх]\s*\d*)[чЧ]", "${1}4")
    Text := RegExReplace(Text, "i)((?:^|\s)[xх]\s*\d*)[вВ]", "${1}8")

    Text := RegExReplace(Text, "i)([xх\d]\s*)[аА]", "${1}2")
    Text := RegExReplace(Text, "[аА](\s*[\d\]])", "2$1")

    return Text
}

HBitmapFromScreen(X, Y, W, H) {
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    mDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "Ptr")
    hBM := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", W, "Int", H, "Ptr")
    oBM := DllCall("SelectObject", "Ptr", mDC, "Ptr", hBM, "Ptr")
    
    DllCall("BitBlt", "Ptr", mDC, "Int", 0, "Int", 0, "Int", W, "Int", H, "Ptr", hDC, "Int", X, "Int", Y, "UInt", 0x00CC0020)
    
    DllCall("SelectObject", "Ptr", mDC, "Ptr", oBM)
    DllCall("DeleteDC", "Ptr", mDC)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
    return hBM
}

ExitFullScreen() {
    if (isRunning){
        if WinExist("ahk_exe stalzone.exe") {
            WinActivate, ahk_exe stalzone.exe
            WinGet, Style, Style, ahk_exe stalzone.exe
            if !(Style & 0xC00000) {
                Send, {F11}
                Sleep, 500
            }
            WinRestore, ahk_exe stalzone.exe
        }
    }
}

NotificationCheck(X1, Y1, X2, Y2, Lang := "ru") {
    global isRunning
    if (!isRunning)
        return 2

    static pToken := Gdip_Startup()
    Width := X2 - X1
    Height := Y2 - Y1
    if (Width <= 0 || Height <= 0)
        return 2

    TempFile := A_ScriptDir . "\lib\OCR\NotificationLastScreen.png"
    pBitmap := Gdip_BitmapFromScreen(X1 . "|" . Y1 . "|" . Width . "|" . Height)
    Gdip_SaveBitmapToFile(pBitmap, TempFile)
    Gdip_DisposeImage(pBitmap)

    RecognizedText := ocr(TempFile, Lang)
    TrimRecognizedText := Trim(RecognizedText, " `t`r`n")
    ; FileDelete, %TempFile%

    if (InStr(TrimRecognizedText, "ПРИГЛАШЕНИЕ В МЕЖФРАКЦИОННЫЙ ОТРЯД") || InStr(TrimRecognizedText, "Отряд")) {
        LogMessage("Найдено предложение в отряд")
        Click, 850, 565
        Sleep, 1000
        return 1
    } 
    else if (InStr(TrimRecognizedText, "Торговля")) {
        LogMessage("Найдено предложение обмена")
        Click, 850, 565
        return 0
    } 
    else if (InStr(TrimRecognizedText, "Приглашение в Убежище")) {
        LogMessage("Отклонено приглашение в убежище")
        Click, 1065, 565
        Sleep, 1000
        return 1
    } 
    else if (InStr(TrimRecognizedText, "Поединок")) {
        LogMessage("Отклонено приглашение в поединок")
        Click, 1065, 565
        Sleep, 1000
        return 1
    } 
    else if (InStr(TrimRecognizedText, "Друзья")) {
        LogMessage("Отклонено приглашение в друзья")
        Click, 1065, 565
        Sleep, 1000
        return 1
    }

    return 2
}

SearchNotification() {
    global isRunning, isChecking
    if (!isRunning || !isChecking)
        return false

    ImagePath := "C:\HolyMacro\SearchImg\Trade.png"
    X1 := 745, Y1 := 420, X2 := 1165, Y2 := 470

    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *30 %ImagePath%
    if (ErrorLevel = 0) {
        Sleep, 200
        LogMessage("Найдено уведомление")
        Sleep, 200
        resultCheck := NotificationCheck(X1, Y1, X2, Y2)

        if (resultCheck == 0) {
            startTrade()
            return true 
        } 
        else if (resultCheck == 1) {
            stopSearching()
            startTrade()
            return true 
        } 
        else if (resultCheck == 2) {
            LogMessage("Неизвестное уведомление, продолжаем поиск...")
            return false
        }
    }
    return false
}

SearchingTrade() {
    global isRunning, isChecking
    while (isRunning && isChecking) {
        Sleep, 1000
        LogMessage("Поиск трейда...")
        Send, {Y}
        
        if (SearchNotification()) {
            Break
        }
    }
    return true
}

startSearching() {
    global isChecking := true
    SearchingTrade()
}

stopSearching() {
    global isChecking := false
    LogMessage("Поиск на паузе")
}

EnterPrice(Price) {
    global isRunning, isTradeRunning
    if (!isRunning || !isTradeRunning)
        return

    Price := Round(Price)

    Click, 905, 160
    Sleep, 500
    SendInput, ^a
    Sleep, 200
    SendInput, %Price%
    Sleep, 1000
    Click, 905, 160
    Sleep, 500

    Click, 600, 500
    Sleep, 500
}

TradeVerification() {
    loop{
        global isRunning, isTradeRunning
        if (!isRunning || !isTradeRunning)
            return false

        ImagePath := "C:\HolyMacro\SearchImg\gog.png"
        X1 := 315, Y1 := 535, X2 := 915, Y2 := 850

        ImageSearch, FoundX, FoundY, X1, Y1, X2, Y2, *30 %ImagePath%
        if (ErrorLevel = 0) {
            LogMessage("Человек подтвердил")
            Break
        }
    }
    Return true
    
}

CalculatingSumItem(itemStr, section := "Selected") {
    itemStr := Trim(itemStr, " `t`r`n")
    iniPath := A_ScriptDir . "\config\SelectedItems.ini"

    pos := InStr(itemStr, " x ", false, 0)
    if (!pos)
        pos := InStr(itemStr, " х ", false, 0)
    if (!pos)
        return 0

    itemName := Trim(SubStr(itemStr, 1, pos - 1))
    quantity := Trim(SubStr(itemStr, pos + 3))

    IniRead, price, %iniPath%, %section%, %itemName%, ERROR
    if (price = "ERROR" || price = "")
        return 0

    StringReplace, price, price, `,, ., All
    return price * quantity
}

CalculatingSumItems(Lang := "ru") {
    global isRunning, isTradeRunning
    ; if (!isRunning || !isTradeRunning)
    ;     return 0

    X1 := 0, Y1 := 605, X2 := 273, Y2 := 870
    InvertColors := false
    Scale := 3
    Width := X2 - X1
    Height := Y2 - Y1

    if (Width <= 0 || Height <= 0)
        return 0

    TempFile := A_ScriptDir . "\lib\OCR\CalculatingSumItemsLastScreen.png"
    GrandTotal := 0
    Sleep, 5000
    Loop, 3 {
        ; if (!isRunning || !isTradeRunning)
        ;     return 0

        pBitmap := Gdip_BitmapFromScreen(X1 . "|" . Y1 . "|" . Width . "|" . Height)
        pPrepared := PrepareBitmapForOCR(pBitmap, Scale)
        Gdip_DisposeImage(pBitmap)

        Gdip_SaveBitmapToFile(pPrepared, TempFile)
        Gdip_DisposeImage(pPrepared)

        RecognizedText := ocr(TempFile, Lang)
        ; FileDelete, %TempFile%

        TrimRecognizedText := Trim(RecognizedText, " `t`r`n")
        CurrentTotal := 0
        FoundAny := false

        Loop, Parse, TrimRecognizedText, `n, `r
        {
            Line := CleanOCRText(A_LoopField)
            if (Line = "")
                continue

            ItemSum := CalculatingSumItem(Line)
            LogMessage(Line . " Итоговая сумма: " . ItemSum)

            if (ItemSum > 0) {
                CurrentTotal += ItemSum
                FoundAny := true
            }
        }

        if (FoundAny) {
            GrandTotal := CurrentTotal
            break
        }
        Sleep, 300
    }

    LogMessage("Итоговая сумма сделки: " . GrandTotal)
    
    return GrandTotal
}

TradeCheck(Lang := "ru", TimeoutMs := 15000) {
    global isRunning, isTradeRunning
    if (!isRunning || !isTradeRunning)
        return false

    X1 := 325, Y1 := 85, X2 := 960, Y2 := 120
    Width := X2 - X1
    Height := Y2 - Y1
    if (Width <= 0 || Height <= 0)
        return false

    TempFile := A_ScriptDir . "\lib\OCR\TradeCheckLastScreen.png"
    Scale := 3
    StartTime := A_TickCount

    Sleep, 1000
    while (isRunning && isTradeRunning) {
        if (A_TickCount - StartTime > TimeoutMs) {
            LogMessage("Таймаут ожидания окна трейда")
            return false
        }

        pBitmap := Gdip_BitmapFromScreen(X1 . "|" . Y1 . "|" . Width . "|" . Height)
        pBitmapScaled := Gdip_CreateBitmap(Width * Scale, Height * Scale)
        G := Gdip_GraphicsFromImage(pBitmapScaled)
        Gdip_SetInterpolationMode(G, 7)
        Gdip_DrawImage(G, pBitmap, 0, 0, Width * Scale, Height * Scale, 0, 0, Width, Height)

        Gdip_SaveBitmapToFile(pBitmapScaled, TempFile)
        Gdip_DeleteGraphics(G)
        Gdip_DisposeImage(pBitmap)
        Gdip_DisposeImage(pBitmapScaled)

        RecognizedText := ocr(TempFile, Lang)
        TrimRecognizedText := Trim(RecognizedText, " `t`r`n")
        FileDelete, %TempFile%

        if (InStr(TrimRecognizedText, "Обмен между игроками")) {
            Sleep, 500
            LogMessage("Трейд найден")
            return true
        }

        Sleep, 250
    }
    return false
}

tradeBot() {
    global isRunning, isTradeRunning

    if (!isRunning || !isTradeRunning)
        return

    try {
        if (!TradeCheck())
            return

        Total := CalculatingSumItems()
        if (Total <= 0)
            return

        EnterPrice(Total)

        startTime := A_TickCount
        while (A_TickCount - startTime < 60000) {
            if (!isRunning || !isTradeRunning)
                return
            if (TradeVerification()) {
                Total2 := CalculatingSumItems()

                if (Total2 <= 0) {
                    return
                }
                else if (Total2 != Total) {
                    EnterPrice(Total2)
                    Total := Total2
                    startTime := A_TickCount 
                }
                else if (Total2 == Total) {
                    return
                }
            }

            Sleep, 1000
        }
    } finally {
        stopTrade()
    }
}


WaitForTradeVerification(timeoutMs) {
    startTime := A_TickCount
    while (A_TickCount - startTime < timeoutMs) {
        global isRunning, isTradeRunning
        if (!isRunning || !isTradeRunning)
            return false

        if (TradeVerification())
            return true

        Sleep, 1000
    }
    return false
}

startTrade() {
    global isTradeRunning
    if (!isTradeRunning) {
        isTradeRunning := true
        LogMessage("Начинаю трейд")
        Sleep, 1000
        tradeBot()
    }
}

stopTrade() {
    global isTradeRunning
    if (isTradeRunning) {
        isTradeRunning := false
        LogMessage("Заканчиваю трейд")
    }
}


MacroLoop() {

    if (isRunning){
        CalculatingSumItems()
        ; ExitFullScreen()
        ; Sleep, 2000

        ; if (!isTradeRunning){
        ;     startSearching()
        ; }


    }else {
        return
    }
}






ExitFunc() {
    global pToken
    Gdip_Shutdown(pToken)
}

~Esc::
ExitApp

GuiClose:
ExitApp
