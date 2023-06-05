#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: einzelne User Verwalten im AD
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: funktioniert noch nicht so ganz
#--------------------------------------------------------------------------------


function Unlock-ADUserAccount {
     param(
         [Parameter(Mandatory=$true)]
         [string]$Username
     )
 
     try {
         $user = Get-ADUser -Identity $Username
         $user | Unlock-ADAccount
         Write-Output "Das Konto '$Username' wurde entsperrt."
     }
     catch {
         Write-Error "Fehler: Das Konto '$Username' konnte nicht entsperrt werden."
     }
 }
 
 function Enable-ADUserAccount {
     param(
         [Parameter(Mandatory=$true)]
         [string]$Username
     )
 
     try {
         $user = Get-ADUser -Identity $Username
         $user | Enable-ADAccount
         Write-Output "Das Konto '$Username' wurde aktiviert."
     }
     catch {
         Write-Error "Fehler: Das Konto '$Username' konnte nicht aktiviert werden."
     }
 }
 
 function Reset-ADUserPassword {
     param(
         [Parameter(Mandatory=$true)]
         [string]$Username
     )
 
     try {
         $user = Get-ADUser -Identity $Username
         $newPassword = Read-Host -AsSecureString "Geben Sie das neue Passwort ein"
         $user | Set-ADAccountPassword -NewPassword $newPassword -Reset
         Write-Output "Das Passwort fuer das Konto '$Username' wurde zurueckgesetzt."
     }
     catch {
         Write-Error "Fehler: Das Passwort fuer das Konto '$Username' konnte nicht zurueckgesetzt werden."
     }
 }
 
 $targetUser = Read-Host "Geben Sie den Benutzernamen ein"
 
 Write-Output "Welche Aktion moechten Sie fuer den Benutzer '$targetUser' ausfuehren?"
 Write-Output "1. Konto entsperren"
 Write-Output "2. Konto aktivieren"
 Write-Output "3. Passwort zuruecksetzen"
 
 $action = Read-Host "Geben Sie die entsprechende Zahl fuer die gewuenschte Aktion ein"
 
 switch ($action) {
     '1' { Unlock-ADUserAccount -Username $targetUser }
     '2' { Enable-ADUserAccount -Username $targetUser }
     '3' { Reset-ADUserPassword -Username $targetUser }
     default { Write-Error"Ungueltige Auswahl." }
 }
 