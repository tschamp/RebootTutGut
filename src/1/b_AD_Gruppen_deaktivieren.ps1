#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Deaktivieren der AD-Gruppen
# Erstellungsdatum: 22.06.2023
# Version: 1.4
# Bemerkungen: -
#--------------------------------------------------------------------------------
# Import config
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")
# Import log
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "log.ps1")


function deleteADGroup {
    # fullPath definieren (OU Klassengruppe) 
    $fullPath = $($config["OUKlasse"]) + "," + $($config["OUPath"])
    # F�r jede Gruppe in $fullPath (OU Klassenablage)
    foreach ($group in ((Get-ADGroup -Filter "*" -SearchBase $fullPath).Name)) {
        # $groupExists auf $false setzen
        $groupExists = $false

        # Csv importieren mit Delimiter ";"
        import-Csv $($config["SchuelerCSV"]) -Delimiter ";" | foreach {
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
function assignADUserToADGroup {
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
    
        # Wenn Benutzername groesser als 20 Zeichen, dann
        if ($username.length -gt 20) {
            $usernameLong = $username
            # Benutzername wird gekuerzt auf die ersten 20 Zeichen
            $username = $username.Remove(20)
            # Logging
            Write-Log -Level INFO -Message "Benutzername $usernameLong wurde auf $username gekuerzt"
        }
        
        # Definieren der Klassenbezeichnung
        $group = "BZTF_" + $class
    
        # Den Benutzer $username der Gruppe $group hinzufügen
        Add-ADGroupMember -Identity $group -Members $username
        # Logging Benutzer hinzugefuegt
        Write-Log -Level INFO -Message "User $username wurde zur Gruppe $group hinzugefuegt"
    
    }
}

deleteADGroup