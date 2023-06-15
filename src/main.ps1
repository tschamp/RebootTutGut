#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Alle Skripts mit Switch-Case zusammenführen und von hier aus 
# starten
# Erstellungsdatum: 30.05.2023
# Version: 1.5
# Bemerkungen: super
#--------------------------------------------------------------------------------

# Ändere die Farbe auf Grün
$Host.UI.RawUI.ForegroundColor = "Green"


function AD-User-Erstellen {
     Write-Host "Rufe das AD-User-Erstellungsskript auf..."
     . "src\1\a_AD_User_erstellen.ps1"
 }
 
 function AD-User-Deaktivieren {
     Write-Host "Rufe das AD-User-Deaktivierungsskript auf..."
     . "src\1\a_AD_User_deaktivieren.ps1"
 }

 function AD-Gruppen-Erstellen{
     Write-Host "Rufe das AD-Gruppen-Erstellungsskript auf..."
     . "src\1\b_AD_Gruppen_erstellen.ps1"
 }

 function AD-Gruppen-Deaktivieren{
     Write-Host "Rufe das AD-Gruppen-Deaktivierungsskript auf..."
     . "src\1\b_AD_Gruppen_deaktivieren.ps1"
 }

 function AD-Sicherheitsinformationen{
    Write-Host "Rufe das AD-Sicherheitsinformationenskript auf..."
    . "src\2\a_Sicherheitstechnische_Infos.ps1"
}

function AD-User-Verwaltung{
    Write-Host "Rufe das AD-User-Verwaltungsskript auf..."
    . "src\2\b_einzelne_AD_User_Verwalten.ps1"
}

function AD-User-Uebersicht{
    Write-Host "Rufe das AD-User-Uebersichtskript auf..."
    . "src\2\c_AD_Uebersicht.ps1"
}
 
 
 
 
 $selection = Read-Host "
 AD BENUTZER VERWALTUNG - Strainovic & Schreiber
 ----------------------------------------------------------------------
 Welche Aktion möchtest du ausführen? Gib die entsprechende Nummer ein:
[1] Gruppenfunktionen
[2] Userfunktionen
 


 "
 
 switch ($selection) {
     1 {

         Write-Host"
         -------------------------------------------------------------
         GRUPPEN FUNKTIONEN WURDEN GEWAEHLT
         -------------------------------------------------------------

         [1] Alle AD-Accounts mit XML erstellen
         [2] Alle AD-Accounts mit XMl deaktivieren

         [3] Erstellen der dazugehörigen Gruppen
         [4] Löschen der dazugehörigen Gruppen

         [E] Zum Hauptmenu 
         [X] Programm beenden

         ------------------------------------------------------------ 
"
         $decision2 = Read-Host "Aktion:"
         switch ($decision2) {
            '1' { 
                Write-Host "Option Alle Accounts mit XML erstellen wurde gewählt"
                AD-User-Erstellen
            }

            '2' {
                Write-Host "Option Alle Accounts mit XML deaktivieren wurde gewählt"
                AD-User-Deaktivieren
            }

            '3'{
                Write-Host "Option Gruppen erstellen mit XML"
                AD-Gruppen-Erstellen
            }

            '4'{
                Write-Host "Option Gruppen deaktivieren mit XML"
                AD-Gruppen-Deaktivieren
            }
            'X' {
                Write-Host "Programm wird beendet"
            }


            Default {Write-Error "Ungültige Auswahl."}
         }
         
     }
     2 {
        Write-Host"
         -------------------------------------------------------------
         USER FUNKTIONEN WURDEN GEWAEHLT
         -------------------------------------------------------------

         [1] Sicherheitstechnische Informationen loggen
         [2] Einzelne User Verwaltung 
         [3] Übersicht aller AD-User


         [E] Zum Hauptmenu 
         [X] Programm beenden

         ------------------------------------------------------------ 
         
         
         "
         $decision3 = Read-Host "Aktion:"
         switch ($decision3) {
            '1' { 
                Write-Host "Option Sicherheitstechnische Infos wurden gewählt"
                AD-Sicherheitsinformationen
            }

            '2' {
                Write-Host "Option Benutzerverwaltung wurde ausgewählt"
                AD-User-Verwaltung
            }

            '3'{
                Write-Host "Option Benutzerverwaltung wurde ausgewählt"
                AD-User-Uebersicht
            }
            'X' {
                Write-Host "Programm wird beendet"
            }


            Default {Write-Error "Ungültige Auswahl."}
         }
     }
     

     default {
         Write-Error "Ungültige Auswahl."
     }
 }
 