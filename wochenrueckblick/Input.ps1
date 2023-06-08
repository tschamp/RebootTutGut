Import-Module ActiveDirectory

# Zeit in Minuten eingeben
$accountLockoutDuration = Read-Host "Geben Sie die Sperrdauer in Minuten ein"

# Maximale Passwortversuche eingeben
$maximumPasswordAttempts = Read-Host "Geben Sie die maximale Anzahl der Passwortversuche ein"

# Konvertiere die Eingabe in numerische Werte
$accountLockoutDuration = [int]$accountLockoutDuration
$maximumPasswordAttempts = [int]$maximumPasswordAttempts

# Ändere die Einstellungen für die Standarddomänenrichtlinie
Set-ADDefaultDomainPasswordPolicy -Identity "reboottutgut.local" -LockoutThreshold $maximumPasswordAttempts -LockoutDuration (New-TimeSpan -Minutes $accountLockoutDuration)

# Zeige die eingegebenen Werte an
Write-Host "Die Einstellungen fuer die Benutzersperrung wurden erfolgreich aktualisiert."
Write-Host "Sperrdauer: $accountLockoutDuration Minuten"
Write-Host "Maximale Passwortversuche: $maximumPasswordAttempts"
