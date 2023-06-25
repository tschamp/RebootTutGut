# Pfad zur XML-Datei
$xmlFilePath = $($config["SchuelerXML"])

# Importieren der XML-Datei
$xml = [xml](Get-Content -Path $xmlFilePath)


# Durchlaufe alle Objekte in der XML
foreach ($obj in $xml.Objs.Obj) {
    # Extrahiere die Werte für Name, Vorname, Benutzername, Klasse und Klasse2
    $values = $obj.MS.S -split ';'

    # Erstelle den Gruppennamen basierend auf der Klasse
    $klasse = $values[3]
    $gruppenname = "Gruppe_$klasse"

    # Erstelle die Gruppe, falls sie noch nicht existiert
    if (-not (Get-ADGroup -Filter "Name -eq '$gruppenname'")) {
        New-ADGroup -Name $gruppenname -GroupScope Global
    }

    # Füge den Benutzer zur Gruppe hinzu
    $benutzername = $values[2]
    Add-ADGroupMember -Identity $gruppenname -Members $benutzername
}
