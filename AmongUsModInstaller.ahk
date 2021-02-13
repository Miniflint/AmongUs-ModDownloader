;---------------------------------------------------------------MAIN------------------------------------------------------
            if (fileExist( "C:\Program Files (x86)\Steam\steamapps\common\Among Us"),D)
            {
                AmongUsPathSteam = C:\Program Files (x86)\Steam\steamapps\common
                GETUSERINPUT(AmongUsPathSteam)
            }
            else if (FileExist("C:\Program Files\Epic Games\Among Us"),D)
            {
                AmongUsPathEpic = C:\Program Files\Epic Games
                GETUSERINPUT(AmongUsPathEpic)
            }
            else if (FileExist("D:\SteamLibrary\steamapps\common\Among Us"),D)
            {
                AmongUsPathDriverD = C:\Program Files\Epic Games
                GETUSERINPUT(AmongUsPathDriverD)
            }
            else if !(FileExist("D:\SteamLibrary\steamapps\common\Among Us"),D)
            {
                
                msgbox, 0, Une fenetre va arriver, selectionnez le dossier dans lequel se trouve among us `nPAS LE DOSSIER AMONG US`nPAS LE DOSSIER AMONG US`nPAS LE DOSSIER AMONG US`nPAS LE DOSSIER AMONG US
                FileSelectFolder, NothingFound,,, selectionnez le dossier dans lequel among us se trouve `nPAS LE DOSSIER AMONG US`nPAS LE DOSSIER AMONG US
                if NothingFound =
                    msgbox, tu n'a pas selectionner de dossier.
                else
                GETUSERINPUT(NothingFound)
            }
;-------------------------------------------------------------------------------GET USER INPUT-----------------------------------------------------------------------------------------------
    GETUSERINPUT(AmongUsPath)
    {     
            InputBox, UserInput, Mode a telecharger, mettre le lien github du mod a telecharger (page d'acceuil)sans V1.1 ou autre`n`n`n`n`nEXEMPLE : https://github.com/[NOM-Utilisateur]/[Nom-Projet] ,,600,250,,,,,https://github.com/Woodi-dev/Among-Us-Sheriff-Mod
            if ErrorLevel
                MsgBox, le bouton annuler a ete appuyer
            if else (UserInput = )
                MsgBox, Rien n'a ete selectioner
            else
            {
                ;--------------------get User Input--------------
                    UrlFile = %UserInput%/releases/latest
                    linkStart = %UserInput%/releases/download/
                ;-----------Change User Input-----------------
                    StringTrimLeft, test, linkStart, 18
                    AfterRex := RegExReplace(test, "/", "\/")
                    RexStrim = a href="%AfterRex%\K[^"]+\.(zip|rar|7z)
                    regExStr = %RexStrim%
                ;------------search the .zip|rar|7z file--------
                    v:=urlDownloadToVar(UrlFile)
                    regExMatch(v,regExStr,linkEnd)
                    File = %LinkStart%%linkEnd%
                ;---------send it to test-------
                    ChangeName(AmongUsPath, File, linkEnd)
            }
    }
;------------------------------------------------------------GET LAST NAME---------------------------------------------
    ChangeName(AmongUsPath, wowa,lastname)
    {
        FullURL = %wowa%
        StringGetPos, pos, FullURL , /, R
        pos++
        StringTrimLeft, lastpart, FullURL, %pos%
        AmongUsDownloader(AmongUsPath, FullURL, lastpart)
    }
;---------------------------------------------------------------------------GET AMONG US PATH - REMPLACE NAME - DOWNLOAD ---------------------------------------------------------------
    AmongUsDownloader(AmongUsPath,FullURL, lastpart)
    {
        PathAmongUS = %AmongUsPath%
        AmongUsFullPath = %PathAmongUS%\%lastpart%
        ;-------------------------------------CODE---------------------------------------
            NewStr := StrReplace(lastpart, ".", A_SPACE)
            FileCopyDir, %PathAmongUS%\Among Us, %AmongUsFullPath%
            UrlDownloadToFile, %FullURL%, %AmongUsFullPath%\%lastpart%
            Unzip(AmongUsFullPath, lastpart)
            FileCreateShortcut, %AmongUsFullPath%\among us.exe, %A_Desktop%\%NewStr%.lnk
            FileDelete, %AmongUsFullPath%\%lastpart%
            EndMsg(NewStr)
    }
    Return
;-----------------------------------------------------------UNZIP PART-----------------------------------------------------
    Unzip(NothingFoundVar2, lastpart)
    {
        7zipFolderZIPED = %NothingFoundVar2%\Temp7z
        FileCreateDir, %7zipFolderZIPED%
        if !(fileExist("C:\Program Files\7-Zip\7z.exe"))
        {
            DeleteZIP = 1
            UrlDownloadToFile, https://www.7-zip.org/a/7z1900-x64.exe, %7zipFolderZIPED%\7z1900.exe
            FileAppend, 
            (
                cd %7zipFolderZIPED%
                    7z1900.exe /S
            ), %7zipFolderZIPED%\SilentInstall.bat
            RunWait %7zipFolderZIPED%\SilentInstall.bat,, hide
        }
        FileAppend, 
        (
            cd C:\Program Files\7-Zip\
                7z x "%NothingFoundVar2%\%lastpart%" -o"%NothingFoundVar2%"
        ), %7zipFolderZIPED%\Tempbat.bat
        RunWait %7zipFolderZIPED%\Tempbat.bat,, hide
        If(DeleteZIP = 1)
        {
            FileAppend, 
            (
                cd C:\Program Files\7-Zip\
                    uninstall.exe
            ), %7zipFolderZIPED%\SilentUninstall.bat
            RunWait %7zipFolderZIPED%\SilentUninstall.bat,, hide
        }
        FileRemoveDir, %7zipFolderZIPED%, 1
    }
    Return
;------------------------------------Mod SEARCH--------------------------------
    urlDownloadToVar(url,raw:=0,userAgent:="",headers:=""){
        if (!regExMatch(url,"i)https?://"))
            url:="https://" url
        try {
            hObject:=comObjCreate("WinHttp.WinHttpRequest.5.1")
            hObject.open("GET",url)
            if (userAgent)
                hObject.setRequestHeader("User-Agent",userAgent)
            if (isObject(headers)) {
                for i,a in headers {
                    hObject.setRequestHeader(i,a)
                }
            }
            hObject.send()
            return raw?hObject.responseBody:hObject.responseText
        } catch e
            return % e.message
    }

;---------------------------------END MESSAGE----------------------------
    EndMsg(NewStr)
        {
        MsgBox, 4, installation complétée,Installation Reussie ! `n  `nVeux-tu ouvrir le mode?
            IfMsgBox, Yes
            {
                run %A_Desktop%\%NewStr%.lnk
            }
            Else
            {
                msgbox, ok :(
            }
    }
Return
