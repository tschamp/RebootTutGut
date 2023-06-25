#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Erstellt täglich um 12 Uhr Security Info Logs
# Erstellungsdatum: 22.06.2023
# Version: 1.2
# Bemerkungen: -
#--------------------------------------------------------------------------------




Import-Module ActiveDirectory
## wichtig
## ist der pfad für config datei
## pfad ist so kompliziert damit er von überall funktioniert, also auch vom main oder als eigenes skript
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")



# Passwortalter
# Datum der letzten Anmeldung
# Anzahl der Logins





function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
 SECURITY LOGS
 ----------------------------------------------------------------------
 Welche Aktion moechtest du ausfuehren? Gib die entsprechende Nummer ein:
[1] Daily log aktualisieren
[2] Manuellen Log
[3] Infos zum Taeglichen Log
[E] Zum Hauptmenue
[X] Programm beenden
"@
    $selection = Read-Host "Auswahl"
    switch ($selection) {
        '1' {
            Write-Host "Das Skript um den Dailylog zu aktualisieren wird ausgefuehrt.."
            Start-Sleep -Seconds 0.5
            changeLogTime
            Press-AnyKey
            
        }
        '2' {
            Write-Host "Das Skript um einen manuellen Log zu machen wird ausgefuehrt"
            Start-Sleep -Seconds 0.5
            manualLog
            Press-AnyKey
        }

        '3' {
            Write-Host "Das Skript um Infos anzuzeigen wird ausgefuehrt"
            Start-Sleep -Seconds 0.5
            infoDailyLog 
            Press-AnyKey
        }

        'E' {
            $Host.UI.RawUI.ForegroundColor = "Yellow"
            Write-Host "Wechsle zum Hauptmenue..."
            . "$($config["mainScriptPath"])"
            
            Start-Sleep -Seconds 5
        }

        'X' {
            $Host.UI.RawUI.ForegroundColor = "Red" 
            Write-Host "Programm wird beendet."
            
        }
        default {
            Write-Host "Ungültige Auswahl."
            Clear-Console
        }
    }
}

function Clear-Console {
    $Host.UI.RawUI.ForegroundColor = "Yellow"
    Start-Sleep -Seconds 1.25
    Clear-Host
    Show-MainMenu
}

function Press-AnyKey {
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host "
    ----------------------------------------------------------------
    Druecken Sie eine beliebige Taste, um zum Menu zurueckzukehren."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Console
}

function Standard-Log {
    param (
        [string]$FunctionName
    )

    $logFile =  $($config["succesfulLog"])


    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp | Folgende Funktion wurde korrekt ausgeführt: $FunctionName"

    Add-Content -Path $logFile -Value $logEntry
}
function Error-Log {
    param (
        [string]$FunctionName,
        [string]$ErrorMessage
    )

    $logFile =  $($config["errorLog"])
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp | Es gab einen Fehler bei der Funktion $FunctionName. Fehlermeldung: $ErrorMessage"

    Add-Content -Path $logFile -Value $logEntry
}

# Macht mit einem Taskplanner täglich einen Log von den Vorgaben
function dailyLog {

    [Parameter(Mandatory = $true)]
    [DateTime]$ScheduledTime


    # Pfade konfigurieren
    $LogFilePath = $config["dailylogPath"]
    
    $ErrorActionPreference = "Stop"
    
    # Alle Benutzer aus dem Active Directory abrufen
    $users = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount -ErrorAction Stop
    
    try {
    # Für jeden Benutzer Informationen protokollieren
    foreach ($user in $users) {
        $username = $user.SamAccountName
        
        # Passwortalter ermitteln
        $passwordAge = (Get-Date) - $user.PasswordLastSet
        
        # Datum der letzten Anmeldung ermitteln
        $lastLogonDate = $user.LastLogonDate
        
        # Anzahl der Logins ermitteln
        $logonCount = $user.LogonCount
        
        # Protokollieren der Informationen in die Logdatei
        $logEntry = "Benutzername: $username | Passwortalter: $passwordAge | Datum der letzten Anmeldung: $lastLogonDate | Anzahl der Logins: $logonCount"
        Add-Content -Path $LogFilePath -Value $logEntry
    }
    
    Write-Host "AD-Informationen für alle Benutzer wurden protokolliert." -ForegroundColor Green



# Erstelle bzw. aktualisiere den Task im Windows Task Scheduler
$TaskName = "ADUserInfoLogging"
$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -Command `"Log-ADUserInfo -LogFilePath '$LogFilePath'`""
$TaskTrigger = New-ScheduledTaskTrigger -Daily -At "12:00 PM"
$TaskSettings = New-ScheduledTaskSettingsSet
$TaskSettings.DeleteExpiredTaskAfter = "PT0S"
$TaskPrincipal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel HighestAvailable
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Settings $TaskSettings -Principal $TaskPrincipal -Force

Write-Host "Task wurde erstellt bzw. aktualisiert." -ForegroundColor Green

Standard-Log -FunctionName "dailyLog"

}

catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
    Error-Log -FunctionName "dailyLog" -ErrorMessage $errorMessage
}


Press-AnyKey
}

    




# Skript um jetzt direkt einen Log zu erstellen im Verzeichnis  $($config["manualLogPath"]
function manualLog {

    $LogFilePath = $config["manualLogPath"]
   
    $ErrorActionPreference = "Stop"
    
    # Alle Benutzer aus dem Active Directory abrufen
    $users = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount -ErrorAction Stop
    
    try {
    # Für jeden Benutzer Informationen protokollieren
    foreach ($user in $users) {
        $username = $user.SamAccountName
        
        # Passwortalter ermitteln
        $passwordAge = (Get-Date) - $user.PasswordLastSet.Date
        
        # Datum der letzten Anmeldung ermitteln
        $lastLogonDate = $user.LastLogonDate
        
        # Anzahl der Logins ermitteln
        $logonCount = $user.LogonCount
        
        # Protokollieren der Informationen in die Logdatei
        $logEntry = "Benutzername: $username | Passwortalter: $passwordAge | Datum der letzten Anmeldung: $lastLogonDate | Anzahl der Logins: $logonCount"
        Add-Content -Path $LogFilePath -Value $logEntry
    }
    
    Write-Host "AD-Informationen für alle Benutzer wurden manuell protokolliert." -ForegroundColor Green
    Standard-Log -FunctionName "manualLog"

}

catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
    Error-Log -FunctionName "manualLog" -ErrorMessage $errorMessage
}

    Press-AnyKey
    
}

# Gibt Infos Heraus, welche Daten man im Daily log mittels Planner momentan speichert
# -> Passwortalter, Datum der letzten Anmeldung, Anzahl der Logins
function infoDailyLog {
    try {
        Write-Host "Es werden folgende Infos von AD Benutzer geloggt:"
        Write-Host " 
        Passwortalter
        Datum der letzten Anmeldung
        Anzahl der Logins"
        Standard-Log -FunctionName "infoDailyLog"

    }

    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
        Error-Log -FunctionName "infoDailyLog" -ErrorMessage $errorMessage
    }
    Press-AnyKey
   
}














Clear-Console