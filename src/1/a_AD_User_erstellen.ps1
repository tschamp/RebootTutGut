# Pfad zur XML-Datei
$xmlFilePath = "c.\users\timo.schreiber\documents\files\schueler.xml"

# XML-Datei lesen
$xmlData = Get-Content -Path $xmlFilePath

# XML-Daten analysieren und Benutzer erstellen
$xmlUsers = [xml]$xmlData

# Active Directory-Modul importieren
Import-Module ActiveDirectory

foreach ($userNode in $xmlUsers.S) {
    $userAttributes = $userNode.InnerText -split ";"

    $lastName = $userAttributes[0]
    $firstName = $userAttributes[1]
    $username = $userAttributes[2]
    $class = $userAttributes[3]

    # Passwort für den Benutzer generieren
    $password = ConvertTo-SecureString -String "Passwort123" -AsPlainText -Force

    # Benutzerkonto erstellen
    New-ADUser -SamAccountName $username `
               -GivenName $firstName `
               -Surname $lastName `
               -Name "$firstName $lastName" `
               -DisplayName "$lastName, $firstName" `
               -Description "Klasse: $class," `
               -Enabled $true `
               -AccountPassword $password
               -Path = "OU=schueler,DC=reboottutgut,DC=local"
}
