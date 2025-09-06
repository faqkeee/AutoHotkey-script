#Persistent
SetTitleMatchMode, 2


; Config

captchaResultPath := "C:\Users\illya\Desktop\farm_winter\fold\result.txt"
captchaWidth := 450  
captchaHeight := 70  
screenWidth := A_ScreenWidth
screenHeight := A_ScreenHeight

captchaX := (screenWidth - captchaWidth) // 2 - 10
captchaY := (screenHeight - captchaHeight) // 2 - 30

captchaFolder := "C:\Users\illya\Desktop\farm_winter\fold"
captchaPath := captchaFolder . "\captcha.png"

;OCR
ocrPath := "C:\Program Files\Tesseract-OCR\tesseract.exe"

;nircmd
nircmdPath := "D:\Prog\nircmd.exe"  



FoundPixel(pixel) { ; farm
    Sleep 300
    Send 6
    Sleep 300
    PixelSearch, foundXBulmu%pixel%, foundYBulmu%pixel%, 277, 450, 1683, 659, 0xD90A5A, 65, Fast
    if (ErrorLevel = 0) {
        MouseMove foundXBulmu%pixel%, foundYBulmu%pixel%
        Click
        Sleep 500
        Send, q
    }
}

PutMage(Pixel1, a) { ; mage
    PixelSearch, mage%Pixel1%X, mage%Pixel1%Y, 195, 201, 1561, 904, 0x00F400, 50, Fast
    if (ErrorLevel = 0) {
        mage%Pixel1%X := mage%Pixel1%X + %a%
        mage%Pixel1%Y := mage%Pixel1%Y + %a%
        Sleep 1000
        MouseMove, mage%Pixel1%X, mage%Pixel1%Y 
        Sleep 300
        Click
        Sleep 300
        Send, q
        Sleep 1000
    }
}

Upgrade(X, Y) {
    Click, %X%, %Y%
    Sleep 500
    Click, 414, 642
    Sleep 300
    Click, 1862, 1010
}

UpgradeMax(X, Y) {
    Click, %X%, %Y%
    Sleep 1000
    Loop, 7 {
        Click, 414, 642
        Sleep 4000
    }
    Click, 1862, 1010
}


; Optimized Upgrade Logic


UpgradeBulmuTowers() {
    local bulmuCount := 5
    Loop, 3 {
        Loop, %bulmuCount% {
            index := A_Index
            Upgrade(foundXBulmu%index%, foundYBulmu%index%)
            Sleep, (A_Index = bulmuCount ? 1000 : 500)
        }
    }
}

UpgradeMageTowers() {
    local mageCount := 6
    Loop, %mageCount% {
        index := A_Index
        Upgrade(mage%index%X, mage%index%Y)
        Sleep, 500
    }
}

UpgradeMageMaxRounds(rounds := 12, waitTime := 10000) {
    local mageCount := 6
    Loop, %rounds% {
        Loop, %mageCount% {
            index := A_Index
            UpgradeMax(mage%index%X, mage%index%Y)
            Sleep, 500
        }
        Sleep, %waitTime%
    }
}


; Main


WinActivate, Roblox
SetTimer, CheckImage1, 100
GoSub, MainCode 

MainCode:
Loop {
    Sleep, 20000
    Click 51, 1012  
    Sleep, 500
    MouseMove, 951, 500  

    a := 0, b := 0, aa := 0, bb := 0

    while (a != 6) {
        Send, {WheelDown 2}
        Sleep 1000
        a++
    }
    Click 1185, 729
    while (b != 12) {
        Send, {WheelUp 2}
        Sleep 100
        b++
    }
    Sleep 1000
    Click 1288, 247
    Sleep 1000

    while (bb != 20) {
        Send, {WheelUp 2}
        Sleep 100
        bb++
    }   
    Sleep 500
    MouseMove, 958, 635
    Sleep 500
    while (aa != 20) {
        Send, {WheelDown 2}
        Sleep 100
        aa++
    }
    Sleep 500
    Send, {Esc}
    Sleep 1000
    Click 806, 203
    Sleep 1000
    Click 1339, 369
    Sleep 1000
    Click 1339, 369
    Sleep 1000
    Send, {Esc}
    Sleep 1000
    
    sear := False
    while (!sear) {
        CoordMode, Pixel, Screen
        PixelSearch, Px, Py, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, 0x00698A, 0, Fast RGB
        if (ErrorLevel = 0) {
            MouseMove, Px, Py
            Sleep 500
            Click, Right, 2
            sear := True
        }
    }

    Sleep 2000
    Send, {Esc}         
    Sleep 1000
    Click 806, 203
    Sleep 1000
    Click 1339, 369
    Sleep 1000
    Send, {Esc}         
    Sleep 1000
    Click 1721, 48
    Sleep 20000

    ; place units
    pixel := 1
    while (pixel <= 6) {
        FoundPixel(pixel) 
        pixel++
    }

    Sleep 400
    Send 4
    Sleep 1000

    Pixel1 := 1
    a := 10
    while (Pixel1 <= 6) {
        PutMage(Pixel1, a)
        Pixel1++
        a += 15
    }

    ; Upgrades 
    UpgradeBulmuTowers()
    UpgradeMageTowers()
    UpgradeMageTowers()
    UpgradeMageMaxRounds(12)

    Sleep, 1000000
}
Return


; Captcha & Image Check


CheckImage1:
    ImageSearch, NextX, NextY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\illya\Desktop\farm_winter\next.png
    if (ErrorLevel = 0) {
        SetTimer, CheckImage1, Off
        Sleep, 300
        MouseMove, NextX, NextY 
        Click
        Sleep, 3000
        Click 935, 514
        Sleep, 3000
        Click 935, 514
        Sleep, 3000
        Click 935, 514
        Sleep, 3000
        Click 935, 514

        ImageSearch, retX, retY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\illya\Desktop\farm_winter\return_to_lobby.png
        if (ErrorLevel = 0) {
            Sleep, 300
            MouseMove, retX, retY
            Click
            Sleep, 50000
            MouseMove 166, 505
            Sleep, 500
            Click
            SetTimer, CheckImage1, On
            Sleep, 6000
            Send, {a down}
            Sleep 15000
            Send, {a up}
            Sleep 5000
            Click 1071, 582
            Sleep 5000

            CaptureCaptcha(captchaX, captchaY, captchaWidth, captchaHeight, captchaPath, nircmdPath)
            RunWait, %ocrPath% "%captchaPath%" "%captchaFolder%\result" 2>%captchaFolder%\error_log.txt 
            FileRead, captchaText, %captchaResultPath%
            StringTrimRight, captchaText, captchaText, 1

            if (captchaText != "") {
                Sleep 1000
                MouseMove, 969, 603
                Click, left
                SendInput, %captchaText%
                Sleep 2000
                Click 806, 684
                Sleep 2000
                Send, {d down}
                Sleep 3000
                Send, {d up}
                Sleep 2000
                Send, {a down}
                Sleep 6000
                Send, {a up}
                Sleep 2000
                Click 1071, 582
                Sleep 5000

                CaptureCaptcha(captchaX, captchaY, captchaWidth, captchaHeight, captchaPath, nircmdPath)
                RunWait, %ocrPath% "%captchaPath%" "%captchaFolder%\result" 2>%captchaFolder%\error_log.txt 
                FileRead, captchaText, %captchaResultPath%
                StringTrimRight, captchaText, captchaText, 1

                if (captchaText != "") {
                    Sleep 5000
                    MouseMove, 969, 603
                    Click, left
                    SendInput, %captchaText%
                    Sleep 2000
                    Click 806, 684
                    Sleep 3000
                }
            }

            CaptureCaptcha(x, y, width, height, outputFile, nircmdPath) {
                RunWait, %nircmdPath% savescreenshot %outputFile% %x% %y% %width% %height%
            }
        }
        Reload
        SetTimer, MainCode, -1
    }
Return


; Exit Hotkey

^q::ExitApp  
