#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Alle Skripts mit Switch-Case zusammenführen und von hier aus 
# starten
# Erstellungsdatum: 30.05.2023
# Version: 1.5
# Bemerkungen: super
#--------------------------------------------------------------------------------


function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
 AD BENUTZER VERWALTUNG - Strainovic & Schreiber
 ----------------------------------------------------------------------
 Welche Aktion möchtest du ausführen? Gib die entsprechende Nummer ein:
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
 GRUPPEN FUNKTIONEN WURDEN GEWAEHLT
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
            AD-User-Erstellen
            Clear-Console
        }
        '2' {
            Write-Host "Option Alle Accounts mit XML deaktivieren wurde gewählt"
            AD-User-Deaktivieren
            Clear-Console
        }
        '3' {
            Write-Host "Option Gruppen erstellen mit XML wurde gewählt"
            AD-Gruppen-Erstellen
            Clear-Console
        }
        '4' {
            Write-Host "Option Gruppen deaktivieren mit XML wurde gewählt"
            AD-Gruppen-Deaktivieren
            Clear-Console
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
 USER FUNKTIONEN WURDEN GEWAEHLT
 -------------------------------------------------------------

[1] Sicherheitstechnische Informationen loggen
[2] Einzelne User Verwaltung 
[3] Übersicht aller AD-User
[E] Zum Hauptmenu 
[X] Programm beenden

------------------------------------------------------------

"@
    $decision = Read-Host "Aktion:"
    switch ($decision) {
        '1' {
            Write-Host "Option Sicherheitstechnische Infos wurde gewählt"
            AD-Sicherheitsinformationen
            Clear-Console
        }
        '2' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            AD-User-Verwaltung
            Clear-Console
        }
        '3' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            AD-User-Uebersicht
            Clear-Console
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
    . "src\1\a_AD_User_erstellen.ps1"
}

function AD-User-Deaktivieren {
    Write-Host "Rufe das AD-User-Deaktivierungsskript auf..."
    . "src\1\a_AD_User_deaktivieren.ps1"
}

function AD-Gruppen-Erstellen {
    Write-Host "Rufe das AD-Gruppen-Erstellungsskript auf..."
    . "src\1\b_AD_Gruppen_erstellen.ps1"
}

function AD-Gruppen-Deaktivieren {
    Write-Host "Rufe das AD-Gruppen-Deaktivierungsskript auf..."
    . "src\1\b_AD_Gruppen_deaktivieren.ps1"
}

function AD-Sicherheitsinformationen {
    Write-Host "Rufe das AD-Sicherheitsinformationenskript auf..."
    . "src\2\a_Sicherheitstechnische_Infos.ps1"
}

function AD-User-Verwaltung {
    Write-Host "Rufe das AD-User-Verwaltungsskript auf..."
    . "src\2\b_einzelne_AD_User_Verwalten.ps1"
}

function AD-User-Uebersicht {
    Write-Host "Rufe das AD-User-Uebersichtskript auf..."
    . "src\2\c_AD_Uebersicht.ps1"
}


## ruft die funktion konsole aus, in dieser wird dann das main menu ausgerufen und so weiter dies das ananas
Clear-Console
