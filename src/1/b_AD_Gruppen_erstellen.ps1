#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Erstellen der AD-Gruppen von den Klassen
# Erstellungsdatum: 22.06.2023
# Version: 1.2
# Bemerkungen: -
#--------------------------------------------------------------------------------




# Import config
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")
# Import log
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "log.ps1")


function createADGroup {
    # OU Pfad definieren
    $fullPath = $config.OUKlasse + "," + $config.OUPath

    # Variable $errorOccured auf $false setzen
    $errorOccured = $false

    # Wenn OU $fullpath vorhanden, dann mache nichts
    try {
        Get-ADOrganizationalUnit -Identity $fullPath | Out-Null
    }
    # Wenn OU $fullpath nicht vorhanden (Fehler) OU erstellen
    catch {
        New-ADOrganizationalUnit -Name "Klassengruppen" -Path $config.OUPath
        # $errorOccured auf $true setzen für Logging
        $errorOccured = $true
    }

    # Wenn der Fehler aufgetreten ist, dann
    if ($errorOccured -eq $true) {
        # Logging
        Write-Log -Level INFO -Message "OU Klassengruppen erstellt"
        # $errorOccured zuruecksetzen auf $false
        $errorOccured = $false
    }
    # sonst
    else {
        # Logging 
        Write-Log -Level WARN -Message "OU Klassengruppen bereits vorhanden"
    }
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

        # Wenn AD Gruppe "BZTF_$class" vorhanden, dann mache nichts
        try {
            Get-ADGroup -Identity "BZTF_$class" | Out-Null
        }
        # Wenn AD Gruppe "BZTF_$class" nicht vorhanden, dann erstellen Gruppe "BZTF_$class" in $fullpath
        catch {
            New-ADGroup -Name "BZTF_$class" -SamAccountName "BZTF_$class" -GroupCategory Distribution -GroupScope Global -DisplayName "BZTF_$class" -Path $fullPath -Description "Schueler der Klasse $class" 
            # $errorOccured auf $true setzen für Logging
            $errorOccured = $true
        }
        
        # Wenn $errorOccured = $true, dann
        if ($errorOccured -eq $true) {
            # Logging
            Write-Log -Level INFO -Message "Klassengruppe $class erstellt"
            # errorOccured zuruecksetzen auf $false
            $errorOccured = $false
        }
        # Wenn Fehler nicht aufgetreten, dann
        else {
            # Logging
            Write-Log -Level WARN -Message "Klassengruppe $class bereits vorhanden"
        }
    }
}

createADGroup