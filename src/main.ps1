#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Alle Skripts mit Switch-Case zusammenführen und von hier aus 
# starten
# Erstellungsdatum: 30.05.2023
# Version: 1.5
# Bemerkungen: super
#--------------------------------------------------------------------------------

. ".\config.ini.ps1"



function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
    $($config["art1"])
 AD BENUTZER VERWALTUNG - Strainovic & Schreiber
 ----------------------------------------------------------------------
 Welche Aktion moechtest du ausfuehren? Gib die entsprechende Nummer ein:
[1] Gruppenfunktionen
[2] Userfunktionen
[X] Programm beenden
"@
    $selection = Read-Host "Auswahl"
    switch ($selection) {
        '1' {
            Show-GroupFunctionsMenu
        }
        '2' {
            Show-UserFunctionsMenu
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
    Start-Sleep -Seconds 1.5
    Clear-Host
    Show-MainMenu
}



function Show-GroupFunctionsMenu {
    $Host.UI.RawUI.ForegroundColor = "Green"
    Write-Host @"
 -------------------------------------------------------------
 $($config["art2"])
 -------------------------------------------------------------

[1] Alle AD-Accounts mit XML erstellen
[2] Alle AD-Accounts mit XML deaktivieren
[3] Erstellen der dazugehörigen Gruppen
[4] Löschen der dazugehörigen Gruppen
[E] Zum Hauptmenu
[X] Programm beenden

------------------------------------------------------------
"@
    $decision = Read-Host "Aktion"
    switch ($decision) {
        '1' {
            Write-Host "Option Alle Accounts mit XML erstellen wurde gewählt"
            xmlToCsv AD-User-Erstellen
        }
        '2' {
            Write-Host "Option Alle Accounts mit XML deaktivieren wurde gewählt"
            xmlToCsv AD-User-Deaktivieren
        }
        '3' {
            Write-Host "Option Gruppen erstellen mit XML wurde gewählt"
            xmlToCsv AD-Gruppen-Erstellen assignADUserToADGroup
        }
        '4' {
            Write-Host "Option Gruppen deaktivieren mit XML wurde gewählt"
            xmlToCsv AD-Gruppen-Deaktivieren assignADUserToADGroup
        }
        'E' {
            $Host.UI.RawUI.ForegroundColor = "Yellow"
            Write-Host "Wechsle zum Hauptmenue..."
            Clear-Console
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

function Show-UserFunctionsMenu {
    $Host.UI.RawUI.ForegroundColor = "Green"
    Write-Host @"
    
 -------------------------------------------------------------
 $($config["art3"])
 -------------------------------------------------------------

[1] Sicherheitstechnische Informationen loggen
[2] Einzelne User Verwaltung 
[3] Uebersicht aller AD-User
[E] Zum Hauptmenu 
[X] Programm beenden

------------------------------------------------------------

"@
    $decision = Read-Host "Aktion:"
    switch ($decision) {
        '1' {
            Write-Host "Option Sicherheitstechnische Infos wurde gewählt"
            AD-Sicherheitsinformationen
        }
        '2' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            AD-User-Verwaltung
        }
        '3' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            AD-User-Uebersicht
        }
        'E' {
            $Host.UI.RawUI.ForegroundColor = "Yellow"
            Write-Host "Wechsle zum Hauptmenue..."
            Clear-Console
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


function AD-User-Erstellen {
    Write-Host "Rufe das AD-User-Erstellungsskript auf..."
    . "$($config["createUsers"])"
}

function AD-User-Deaktivieren {
    Write-Host "Rufe das AD-User-Deaktivierungsskript auf..."
    . "$($config["deactivateUsers"])"
}

function AD-Gruppen-Erstellen {
    Write-Host "Rufe das AD-Gruppen-Erstellungsskript auf..."
    . "$($config["createGroups"])"
}

function AD-Gruppen-Deaktivieren {
    Write-Host "Rufe das AD-Gruppen-Deaktivierungsskript auf..."
    . "$($config["deactivateGroups"])"
}

function AD-Sicherheitsinformationen {
    Write-Host "Rufe das AD-Sicherheitsinformationenskript auf..."
    . "$($config["securityLogs"])"
}

function AD-User-Verwaltung {
    Write-Host "Rufe das AD-User-Verwaltungsskript auf..."
    . "$($config["manageUser"])"
}

function AD-User-Uebersicht {
    Write-Host "Rufe das AD-User-Uebersichtskript auf..."
    . "$($config["overviewUser"])"
}
## ruft die funktion konsole aus, in dieser wird dann das main menu ausgerufen und so weiter dies das ananas
Clear-Console
