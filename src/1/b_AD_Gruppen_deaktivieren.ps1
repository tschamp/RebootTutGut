
# Import config
. .\code\config.ps1
# Import log
. .\code\log.ps1

function deleteADGroup {
    # fullPath definieren (OU Klassengruppe) 
    $fullPath = $config.OUKlasse + "," + $config.OUPath
    # F�r jede Gruppe in $fullPath (OU Klassenablage)
    foreach ($group in ((Get-ADGroup -Filter "*" -SearchBase $fullPath).Name)) {
        # $groupExists auf $false setzen
        $groupExists = $false

        # Csv importieren mit Delimiter ";"
        import-Csv $config.SchuelerCsv -Delimiter ";" | foreach {
            # Vorname von CSV in Variable $vorname speichern
            $vorname = ($_.Vorname)
            # Name von CSV in Variable $nachname speichern
            $nachname = ($_.Name)
            # Benutzername von CSV in Variable $username speichern
            $username = ($_.Benutzername)
            # Klasse von CSV in Variable $class speichern
            $class = ($_.Klasse)
            # Klasse2 von CSV in Variable $class speichern
            $class2 = ($_.Klasse2)
            
            # Wenn Gruppe $group uebereinstimmt, mit "BZTF_$class" (Klasse aus CSV), dann
            if ($group -eq "BZTF_$class") {
                # $groupExists wird auf $true gestzt
                $groupExists = $true
            }
        }
        # Wenn eine keine der Klassen uebereingestummen hat ($groupExists = $false), dann
        if ($groupExists -eq $false) {
            # Gruppe $group loeschen
            Remove-ADGroup -Identity $group
            # Logging
            Write-Log -Level INFO "Klassengruppe $group deaktiviert"
        }
    }
}