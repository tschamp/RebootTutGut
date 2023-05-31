# Importiere die Config.ini.ps1-Datei
# config datei für die relativen Pfade
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

    # Überprüfen, ob der AD-Account vorhanden ist
    if (Get-ADUser -Filter "SamAccountName -eq '$benutzername'") {
        Write-Host "Der Benutzer '$benutzername' existiert. Der Account wird deaktiviert."
        # Deaktivieren des AD-Accounts
        Set-ADUser -Identity $benutzername -Enabled $false
    }
    else {
        Write-Host "Der Benutzer '$benutzername' existiert nicht."
    }
}
