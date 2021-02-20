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
    IniFolderFile = C:\Users\%A_UserName%\AppData\Roaming\AmongUsStartingFolder.ini
    if !(FileExist(IniFolderFile))
    {
        FileSelectFolder, NothingFound,,, Select the folder where your among us mods are located
        StringGetPos, pos, NothingFound , \, R
        pos++
        StringTrimLeft, AfterNothingFound, NothingFound, %pos%
        if NothingFound = 
        {
            msgbox, you haven't selected any folder
            IniDelete, %IniFolderFile%, PathFolder
        }
        else if AfterNothingFound = Among Us
        {
            msgbox, you selected the among us folder, not WHERE the among us folder is located
            IniDelete, %IniFolderFile%, PathFolder
        }
        else
        {
            IniWrite, %NothingFound%, %IniFolderFile%, PathFolder, File
            GETUSERINPUT(NothingFound)
        }
    }
else
{
    IniRead, FromIniFolder, %IniFolderFile%, PathFolder, File, ERROR
    if FromIniFolder = ERROR
    {
        msgbox, 
        (
            There is an ERROR
            ini file is corrupted at this location : 
            %IniFolderFile%
            the file will be deleted, please open the script again
        )
        FileDelete, %IniFolderFile%
    }
    else
        GETUSERINPUT(FromIniFolder)
    }
}
GETUSERINPUT(AmongUsPath)
{     
    InputBox, UserInput, Enter the github link, Enter the github link from the mod to download`n`n`n`n`nEXEMPLE : https://github.com/[USERNAME]/[FILENAME] ,,600,250,,,,,%Clipboard%
    if ErrorLevel
        MsgBox, Something went wrong
    if else (UserInput = )
        MsgBox, You haven't selected anything
    else
    {
        UrlFile = %UserInput%/releases/latest
        linkStart = %UserInput%/releases/download/
        StringTrimLeft, test, linkStart, 18
        AfterRex := RegExReplace(test, "/", "\/")
        RexStrim = a href="%AfterRex%\K[^"]+\.(zip|rar|7z)
        regExStr = %RexStrim%
        v:=urlDownloadToVar(UrlFile)
        regExMatch(v,regExStr,linkEnd)
        File = %LinkStart%%linkEnd%
        ChangeName(AmongUsPath, File, linkEnd)
    }
}
ChangeName(AmongUsPath, wowa,lastname)
{
    FullURL = %wowa%
    StringGetPos, pos, FullURL , /, R
    pos++
    StringTrimLeft, lastpart, FullURL, %pos%
    AmongUsDownloader(AmongUsPath, FullURL, lastpart)
        
    }
AmongUsDownloader(AmongUsPath,FullURL, lastpart)
{
    PathAmongUS = %AmongUsPath%
    AmongUsFullPath = %PathAmongUS%\%lastpart%
    NewStr := StrReplace(lastpart, ".", A_SPACE)
    FileCopyDir, %PathAmongUS%\Among Us, %AmongUsFullPath%
    UrlDownloadToFile, %FullURL%, %AmongUsFullPath%\%lastpart%
    Unzip(AmongUsFullPath, lastpart)
    FileCreateShortcut, %AmongUsFullPath%\among us.exe, %A_Desktop%\%NewStr%.lnk
    FileDelete, %AmongUsFullPath%\%lastpart%
    EndMsg(NewStr)
}
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
EndMsg(NewStr)
{
    MsgBox, 4, Installation complete !,Do You wanna open the mod ?
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
