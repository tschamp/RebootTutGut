Import-Module ActiveDirectory

$maximumPasswordAttempts = 5
$accountLockoutDuration = New-TimeSpan -Minutes 30

Set-ADDefaultDomainPasswordPolicy -Identity "reboottutgut.local" -PasswordHistoryCount $maximumPasswordAttempts -LockoutDuration $accountLockoutDuration

Write-Host "Die Einstellungen fuer die Benutzersperrung wurden erfolgreich aktualisiert."

pause