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
    # Pfade konfigurieren
    $logPath = $config["logPath"]
   
}

# Dieses Skript ändert den Zeitpunkt des Dailylogs von den security infos von den AD Nutzern wie:
# Passwortalter, Datum der letzten Anmeldung, Anzahl der Logins
# Daily logs werden mit planner gemacht, diese führt man nicht direkt als funktion aus weil es mit dem TaskPlanner gemacht wird

# Der Wert von Dieser Funktion wird bei der Funktion dailyLog dann gegeben und dort geändert!!

# Funktion zum Ändern des Zeitpunkts für das tägliche Log
function Change-LogTime {
    $Host.UI.RawUI.ForegroundColor = "Green"
    Write-Host @"
Gib den neuen Zeitpunkt für das tägliche Log ein (HH:MM:SS):
"@
    $newTime = Read-Host "Zeitpunkt"
    $taskTime = Get-Date $newTime -ErrorAction SilentlyContinue
    if ($taskTime -eq $null) {
        Write-Host "Ungültiges Zeitformat. Der Standardzeitpunkt 12:00:00 wird verwendet."
        $taskTime = Get-Date -Hour 12 -Minute 0 -Second 0
    }
    $taskTime
}


# Skript um jetzt direkt einen Log zu erstellen im Verzeichnis  $($config["manualLogPath"]
function manualLog {
    Press-AnyKey
    
}

# Gibt Infos Heraus, welche Daten man im Daily log mittels Planner momentan speichert
# -> Passwortalter, Datum der letzten Anmeldung, Anzahl der Logins
function infoDailyLog {
    Press-AnyKey
   
}














Clear-Console