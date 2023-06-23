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


# Macht mit einem Taskplanner täglich einen Log von den Vorgaben
function Daily-Log {

    [Parameter(Mandatory = $true)]
    [DateTime]$ScheduledTime


    # Pfade konfigurieren
    $LogFilePath = $config["dailylogPath"]
    
    $ErrorActionPreference = "Stop"
    
    # Alle Benutzer aus dem Active Directory abrufen
    $users = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount -ErrorAction Stop
    
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
Press-AnyKey

    
}

# 
# Funktion zum Ändern des Zeitpunkts für das tägliche Log
function Change-LogTime {
  
}


# Skript um jetzt direkt einen Log zu erstellen im Verzeichnis  $($config["manualLogPath"]
function manualLog {

    $LogFilePath = $config["manualLogPath"]
   
    $ErrorActionPreference = "Stop"
    
    # Alle Benutzer aus dem Active Directory abrufen
    $users = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount -ErrorAction Stop
    
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
    
    Write-Host "AD-Informationen für alle Benutzer wurden manuell protokolliert." -ForegroundColor Green

    Press-AnyKey
    
}

# Gibt Infos Heraus, welche Daten man im Daily log mittels Planner momentan speichert
# -> Passwortalter, Datum der letzten Anmeldung, Anzahl der Logins
function infoDailyLog {
    Press-AnyKey
   
}














Clear-Console