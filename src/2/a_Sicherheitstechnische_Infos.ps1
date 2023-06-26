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
            dailyLog
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

    try {
# Vorgegebene Werte
$taskName = "MeineAufgabe"
$scriptPath = $($config["logOnly"])

# Benutzer nach der Ausführungszeit fragen
$triggerTime = Read-Host "Wann sollen die Informationen geloggt werden? (im Format 'HH:mm'):"

# Überprüfen, ob eine Aufgabe mit dem angegebenen Namen bereits vorhanden ist
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($existingTask) {
    # Eine vorhandene Aufgabe wurde gefunden, diese löschen
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Neue Aufgabe erstellen
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At $triggerTime
$settings = New-ScheduledTaskSettingsSet
$task = Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings

# Aufgabe sofort ausführen
Start-ScheduledTask -TaskName $taskName

Write-Host "Die Task wurde erfolgreich erstellt um Logdaten zu speichern"
Standard-Log -FunctionName "dailyLog"

}

catch{
    $errorMessage = $_.Exception.Message
    Write-Host "Es gab einen Fehler beim Ausführen."
    Error-Log -FunctionName "dailyLog" -ErrorMessage $errorMessage
}


Press-AnyKey


}
    




# Skript um jetzt direkt einen Log zu erstellen im Verzeichnis  $($config["manualLogPath"]
function manualLog {
    try { 
        $LogFilePath = $($config["manualLogPath"])
        $ADUsers = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount

        # Aktuelles Ausführungsdatum generieren
        $ExecutionDate = Get-Date -Format "yyyy-MM-dd"

        # Header mit aktuellem Ausführungsdatum erstellen
        $Header = 
"
------------------------------------------------------------------------------------------------
Benutzername,Passwortgesetzt am,Datum der letzten Anmeldung,Anzahl der Logins -> $ExecutionDate
------------------------------------------------------------------------------------------------"

        # Header und Logeinträge zur Logdatei hinzufügen
        $Header | Out-File -FilePath $LogFilePath -Append -Encoding UTF8

        foreach ($User in $ADUsers) {
            # Benutzername abrufen
            $Username = $User.SamAccountName

            # Passwortalter berechnen
            $PasswordAge = $User.PasswordLastSet

            # Datum der letzten Anmeldung abrufen
            $LastLoginDate = $User.LastLogonDate

            # Anzahl der Logins abrufen
            $LoginCount = $User.LogonCount

            # Aktuellen Logeintrag zusammenstellen
            $LogEntry = "$Username,$PasswordAge,$LastLoginDate,$LoginCount"

            # Logeintrag zur Logdatei hinzufügen
            $LogEntry | Out-File -FilePath $LogFilePath -Append -Encoding UTF8
        }

        Write-Host "Die AD-Benutzerinformationen wurden erfolgreich zur Logdatei '$LogFilePath' hinzugefügt."
        Standard-Log -FunctionName "manualLog"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen."
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
        Write-Host "Es gab einen Fehler beim Ausführen."
        Error-Log -FunctionName "infoDailyLog" -ErrorMessage $errorMessage
    }
    Press-AnyKey
   
}














Clear-Console