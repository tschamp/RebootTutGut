# Ändere die Farbe auf Rot
$Host.UI.RawUI.ForegroundColor = "Green"

# Bulk Funktionen unter Punkt 1a

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
 
 
 
 $selection = Read-Host "Welche Aktion möchtest du ausführen? Gib die entsprechende Nummer ein:
 Bulkfunktionen: 
 1. AD-User erstellen
 2. AD-User deaktivieren
 3. AD-Gruppen erstellen
 4. AD-Gruppen deaktivieren
 
 Sicherheitsfunktionen:
 5. technische Informationen der Benutzer
 6. einzelne User Verwaltung
 7. Übersicht aller AD Benutzer


 "
 
 switch ($selection) {
     1 {

         AD-User-Erstellen
     }
     2 {
         AD-User-Deaktivieren
     }
     3 {
          AD-Gruppen-Erstellen
     }
     4 {
          AD-Gruppen-Deaktivieren
     }
     5 {
        AD-Sicherheitsinformationen

     }
     6 {
        AD-User-Verwaltung
     }


     default {
         Write-Error "Ungültige Auswahl."
     }
 }
 