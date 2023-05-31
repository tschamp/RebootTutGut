# Importiere die Config.ini.ps1-Datei
# config datei fpr die relativen Pfade
. "src/config.ini.ps1"

# XML-Datei einlesen
$xml = [xml](Get-Content -Path @($config["SchuelerXML"]))

# Durch die Objekte in der XML-Datei iterieren
foreach ($obj in $xml.Objs.Obj) {
    # Benutzerdetails aus dem XML-Objekt extrahieren
    $name = $obj.MS.S -split ';' | Select-Object -Index 0
    $vorname = $obj.MS.S -split ';' | Select-Object -Index 1
    $benutzername = $obj.MS.S -split ';' | Select-Object -Index 2
    $klasse = $obj.MS.S -split ';' | Select-Object -Index 3
    $klasse2 = $obj.MS.S -split ';' | Select-Object -Index 4

    # Überprüfen, ob der AD-Account bereits vorhanden ist
    if (Get-ADUser -Filter "SamAccountName -eq '$benutzername'") {
        Write-Host "Der Benutzer '$benutzername' existiert bereits. Der Account wird deaktiviert."
        # Deaktivieren des AD-Accounts
        Set-ADUser -Identity $benutzername -Enabled $false
    }
    else {
        Write-Host "Der Benutzer '$benutzername' existiert nicht. Der Account wird erstellt."
        # Benutzer in Active Directory erstellen
        $password = ConvertTo-SecureString -String "Passwort123!" -AsPlainText -Force
        New-ADUser -SamAccountName $benutzername -Name "$vorname $name" -GivenName $vorname -Surname $name -UserPrincipalName "$benutzername@domain.com" -Enabled $true -PasswordNeverExpires $true -AccountPassword $password -Path "OU=Pfad\zur\OU"
    }
}
