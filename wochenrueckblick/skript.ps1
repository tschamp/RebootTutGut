# Active Directory importieren
Import-Module ActiveDirectory

# Zeit der Sperrung (minuten)
$gesperrtDauer = Read-Host "Sperrdauer in Minuten: "

# Maximale Passwortversuche eingeben
$maxPasswordVersuche = Read-Host "Maximale Passwort versuche: "

# Wichtig! User Input in einen Integer umwandeln
$gesperrtDauer = [int]$accountLockoutDuration
$maxPasswordVersuche = [int]$maximumPasswordAttempts

# Ändere die Einstellungen von Domänerichtlinie
Set-ADDefaultDomainPasswordPolicy -PasswordHistoryCount $maxPasswordVersuche 
-LockoutDuration (New-TimeSpan -Minutes $gesperrtDauer)

# Zeige die eingegebenen Werte an
Write-Host "Die Einstellungen für die Benutzersperrung wurden erfolgreich aktualisiert."
Write-Host "Sperrdauer: $gesperrtDauer Minuten"
Write-Host "Maximale Passwortversuche: $maxPasswordVersuche 
