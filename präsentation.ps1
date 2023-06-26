# Parameter für die Anzahl der zulässigen falschen Passworteingaben
$anzahlFehler = 5

# Verbindung zum Active Directory herstellen
Import-Module ActiveDirectory

# Alle Benutzerobjekte abrufen
$alleBenutzer = Get-ADUser -Filter *

# Für jeden Benutzer das Sperrverhalten überprüfen und aktualisieren
foreach ($benutzer in $alleBenutzer) {
    # Überprüfen, ob das Konto "password never expires" hat
    if ($benutzer.PasswordNeverExpires) {
        Write-Host "Das Konto $($benutzer.SamAccountName) hat 'password never expires' aktiviert. Es wird übersprungen."
        continue
    }

    # Anzahl der aktuellen falschen Passworteingaben erhöhen
    $anzahlFalscheEingaben = $benutzer.BadPwdCount + 1

    # Überprüfen, ob die Anzahl der falschen Passworteingaben das Limit erreicht hat
    if ($anzahlFalscheEingaben -ge $anzahlFehler) {
        # Benutzerkonto sperren
        Set-ADAccountPassword -Identity $benutzer.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "DummyPassword" -Force)
        Write-Host "Das Benutzerkonto $($benutzer.SamAccountName) wurde gesperrt."
    } else {
        # Anzahl der falschen Passworteingaben aktualisieren
        Set-ADUser -Identity $benutzer.SamAccountName -ChangePasswordAtLogon $true
        Write-Host "Falsche Passworteingabe für Benutzer $($benutzer.SamAccountName). Anzahl der Fehler: $anzahlFalscheEingaben"
    }
}
