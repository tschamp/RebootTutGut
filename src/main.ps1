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
 
 
 
 $selection = Read-Host "Welche Aktion möchtest du ausführen? Gib die entsprechende Nummer ein:
 Bulkfunktionen: 
 1. AD-User erstellen
 2. AD-User deaktivieren


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
     default {
         Write-Host "Ungültige Auswahl."
     }
 }
 