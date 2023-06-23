#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Alle Skripts mit Switch-Case zusammenführen und von hier aus 
# starten
# Erstellungsdatum: 30.05.2023
# Version: 1.5
# Bemerkungen: super
#--------------------------------------------------------------------------------

Import-Module -Name .\src\config.ini.ps1

Import-Module -name .\src\1\a_AD_User_erstellen.ps1
Import-Module -name .\src\1\a_AD_User_deaktivieren.ps1
Import-Module -name .\src\1\b_AD_Gruppen_erstellen.ps1
Import-Module -name .\src\1\b_AD_Gruppen_deaktivieren.ps1


Import-Module -name .\src\2\a_Sicherheitstechnische_Infos.ps1
Import-Module -name .\src\2\b_einzelne_AD_User_Verwalten.ps1
Import-Module -name .\src\2\c_AD_Uebersicht.ps1



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
            a_AD_User_erstellen
        }
        '2' {
            Write-Host "Option Alle Accounts mit XML deaktivieren wurde gewählt"
            a_AD_User_deaktivieren
        }
        '3' {
            Write-Host "Option Gruppen erstellen mit XML wurde gewählt"
            b_AD_Gruppen_erstellen
        }
        '4' {
            Write-Host "Option Gruppen deaktivieren mit XML wurde gewählt"
            b_AD_Gruppen_deaktivieren
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
            a_Sicherheitstechnische_Infos
        }
        '2' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            b_einzelne_AD_User_Verwalten
        }
        '3' {
            Write-Host "Option Benutzerverwaltung wurde gewählt"
            c_AD_Uebersicht
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




## ruft die funktion konsole aus, in dieser wird dann das main menu ausgerufen und so weiter dies das ananas
Clear-Console
