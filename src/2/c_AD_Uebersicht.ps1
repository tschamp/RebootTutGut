#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: einzelne User Verwalten im AD
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: funktioniert noch nicht so ganz
#--------------------------------------------------------------------------------

<#
- Übersicht über alle AD-Benutzer:
für welche kein Passwort gesetzt ist
Passwort läuft nie ab
deaktivierte/gesperrte AD-Benutzer
#>


function Show-NoPassword {
    Get-ADUser -filter {PaswordNotRequired -eq $true} | Select-Object Name
    
}

function Show-NeverExpire{
    Get-ADUser -filter {Enabled -eq $TRUE -and PasswordNeverExpires -eq $TRUE} ` -Properties PasswordLastSet | Select-Object Name, PasswordLastSet | ` Sort-Object -Property Name -Descending | Format-Table
}

function Show-deaktivated {
    Get-ADUser -filter {Enabled -eq $false} | Select-Object Name PasswordLastSet
}



Write-Output "Welche Aktion moechten Sie ausfuehren?"
Write-Output "1. Konten welches kein Paswort hat"
Write-Output "2. Konten welche das Passwort nicht abläuft"
Write-Output "3. Konten welche gesperrt sind"
Write-Output "4. Alles anzeigen"



while ($action -notin 1, 2, 3, 4) {

    $action = Read-Host "Geben Sie die entsprechende Zahl fuer die gewuenschte Aktion ein"

switch ($action) {
    '1' {
        Write-Host "Benutzer mit keinem Passwort:"
        Write-Host "-------------------------"
        Write-Host ""    
        Show-NoPassword}
    '2' {
        Write-Host "Benutzer bei dem das Passwort nicht ablaeuft"
        Write-Host "-------------------------"
        Write-Host ""
        Show-NeverExpire}
    '3' {
        Write-Host "Benutzer, welche deaktiviert sind"
        Write-Host "-------------------------"
        Write-Host ""
        Show-deaktivated}
    '4'  {
    Write-Host "Benutzer mit keinem Passwort:"
    Write-Host "-------------------------"
    Write-Host ""
    Show-NoPassword
    
    Write-Host "Benutzer bei dem das Passwort nicht abläuft"
    Write-Host "-------------------------"
    Write-Host ""
    Show-NeverExpire

    Write-Host "Benutzer, welche deaktiviert sind"
    Write-Host "-------------------------"
    Write-Host ""
    Show-Deactivated}
    default { Write-Host "Ungueltige Auswahl. Probiers nochmal" }
}
}