
# Import config
. ".\config.ini.ps1"
# Import log
. ".\log.ps1"

function xmlToCsv {
    # XML auslesen
    [xml] $SchuelerXML = Get-Content -Path $config.SchuelerXml
    # Logging
    Write-Log -Level INFO -Message "XML eingelesen"

    # CSV-Headers hinzufuegen
    $SchuelerXML.Objs.Obj.MS.S.N.GetValue(0) | Out-File -Encoding utf8 -FilePath $config.SchuelerCsv
    # Logging
    Write-Log -Level INFO -Message "CSV Headers hinzugefuegt"

    # anzahl zeilen zählen (default = 0)
    $total  = 0
    foreach ($line in $SchuelerXML.Objs.Obj.MS.S.InnerXML) {
        $total += 1
    }

    # momentane zeile (default = 1)
    $current = 1
    # Liste in die CSV-Datei schreiben
    # Hinweis: XML hat bereits ein CSV Format
    foreach ($line in $SchuelerXML.Objs.Obj.MS.S.InnerXML) {
        # in jeder Linie, Umlaute ersetzen
        $line = $line -ireplace 'ä', 'ae' -ireplace 'ö', 'oe' -ireplace 'ü', 'ue' -ireplace 'è', 'e' -ireplace 'é', 'e'
        # Jede Linie der Datei hinzufuegen
        $line | Out-File -Encoding utf8 -FilePath $config.SchuelerCsv -Append
        # Logging
        Write-Log -Level INFO -Message "$current/$total Linie zu CSV hinzugefuegt"
        # momentane zeile
        $current += 1
    }
    #Logging
    Write-Log -Level INFO -Message "XML zu CSV Konvertierung abgeschlossen"
}