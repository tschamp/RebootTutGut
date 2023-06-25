# Pfad zur XML-Datei
$xmlFilePath = $($config["SchuelerXML"])

# Importieren der XML-Datei
$xml = [xml](Get-Content -Path $xmlFilePath)

# Active Directory-Modul importieren (falls nicht bereits geschehen)
Import-Module ActiveDirectory

# Durchlaufen der Benutzer in der XML-Datei
foreach ($user in $xml.SelectNodes("//S")) {
    # Extrahieren der Benutzerinformationen aus der XML
    $name = $user."Name"
    $vorname = $user."Vorname"
    $benutzername = $user."Benutzername"
    $klasse = $user."Klasse"
    $klasse2 = $user."Klasse2"

    # Erstellen des SamAccountNames für den Benutzer
    $samAccountName = $benutzername.Substring(0, [Math]::Min(20, $benutzername.Length))

    # Überprüfen, ob der Benutzer bereits existiert
    $existingUser = Get-ADUser -Filter {SamAccountName -eq $samAccountName}

    if ($existingUser) {
        # Benutzer existiert bereits, Aktualisieren der Eigenschaften
        Set-ADUser -Identity $existingUser -GivenName $vorname -Surname $name -Description $klasse
    }
    else {
        # Benutzer existiert nicht, Erstellen des neuen Benutzers
        $password = ConvertTo-SecureString -String "Passwort123" -AsPlainText -Force
        New-ADUser -SamAccountName $samAccountName -UserPrincipalName "$samAccountName@deine-domäne.de" -GivenName $vorname -Surname $name -Description $klasse -AccountPassword $password -Enabled $true -PassThru
    }

    # Benutzer zur zweiten Klasse hinzufügen (falls angegeben)
    if ($klasse2) {
        $group = Get-ADGroup -Filter {Name -eq $klasse2}
        if ($group) {
            Add-ADGroupMember -Identity $group -Members $samAccountName
        }
        else {
            Write-Warning "Die Gruppe '$klasse2' existiert nicht im Active Directory."
        }
    }
}
