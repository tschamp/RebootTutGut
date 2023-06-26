#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Deaktivieren der AD-User
# Erstellungsdatum: 22.06.2023
# Version: 1.3
# Bemerkungen: -
#--------------------------------------------------------------------------------

# Import config
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")
# Import log
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "log.ps1")

function deactivateADUserAccount {
    # Definieren von OU Pfad $fullpath
    $fullPath = $($config["OULernende"]) + "," + $($config["OUPath"])
    # Foreach $user in $fullPath (OU Lernende)
    foreach ($user in ((Get-ADUser -Filter "*" -SearchBase $fullPath).SamAccountName)) {
        # $userExists auf $false setzen (Default)
        $userExists = $false

        # Csv importieren mit Delimiter ";"
        import-Csv $($config["SchuelerCSV"])  -Delimiter ";" | foreach {
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
            # Wenn $user uebereinstimmt mit einem der User der CSV dann 
            if ($user -eq "$username") {
                # $userExists auf $true setzen
                $userExists = $true
            }
        }
        # Wenn der User nicht im CSV existiert, dann
        if ($userExists -eq $false) {
            # User $user deaktivieren
            Disable-ADAccount -Identity $user
            #$ Logging
            Write-Log -Level INFO "Benutzer $user deaktiviert"
        }

    }
}


deactivateADUserAccount