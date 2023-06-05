# Parameter für den Benutzernamen und die Anzahl der zulässigen falschen Passworteingaben
$benutzername = "B.Johnson"
$anzahlFehler = 5

# Verbindung zum Active Directory herstellen
Import-Module ActiveDirectory

# Benutzerobjekt abrufen
$benutzer = Get-ADUser -Identity $benutzername

# Anzahl der aktuellen falschen Passworteingaben erhöhen
$anzahlFalscheEingaben = $benutzer.BadPwdCount + 1

# Überprüfen, ob die Anzahl der falschen Passworteingaben das Limit erreicht hat
if ($anzahlFalscheEingaben -ge $anzahlFehler) {
    # Benutzerkonto sperren
    Set-ADAccountPassword -Identity $benutzername -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "DummyPassword" -Force)
    Write-Host "Das Benutzerkonto $benutzername wurde gesperrt."
} else {
    # Anzahl der falschen Passworteingaben aktualisieren
    Set-ADUser -Identity $benutzername -ChangePasswordAtLogon $true
    Write-Host "Falsche Passworteingabe. Anzahl der Fehler: $anzahlFalscheEingaben"
}
