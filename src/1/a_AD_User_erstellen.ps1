#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Erstellen der AD-User
# Erstellungsdatum: 22.06.2023
# Version: 1.4
# Bemerkungen: -
#--------------------------------------------------------------------------------
# Import config
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")
# Import log
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "log.ps1")

function createADUserAccount {
    # $fullPath definieren
    $fullPath = $config.OULernende + "," + $config.OUPath
    # $errorOccured auf $false setzen
    $errorOccured = $false
    # Wenn OU $fullpath vorhanden, dann mache nichts
    try {
        Get-ADOrganizationalUnit -Identity $fullPath | Out-Null
    }
    # Wenn OU $fullpath nicht vorhanden, dann
    catch {
        # OU "Lernende" erstellen
        New-ADOrganizationalUnit -Name "Lernende" -Path $config.OUPath
        # $errorOccured auf $true setzen
        $errorOccured = $true
    }
    # Wenn $errorOccured = $true ist, dann
    if ($errorOccured -eq $true) {
        # Logging 
        Write-Log -Level INFO -Message "OU Lernende erstellt"
        # $errorOccured zuruecksetzen auf $false
        $errorOccured = $false
    }
    # Wenn $errorOccured nicht $true ist, dann
    else {
        # Logging
        Write-Log -Level WARN -Message "OU Lernende bereits vorhanden"
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


        # Wenn Benutzername groesser als 20 Zeichen, dann
        if ($username.length -gt 20) {
            $usernameLong = $username
            # Benutzername wird gekuerzt auf die ersten 20 Zeichen
            $username = $username.Remove(20)
            # Logging
            Write-Log -Level INFO -Message "Benutzername $usernameLong wurde auf $username gekuerzt"
        }
        # Wenn User $username vorhanden, dann mache nichts
        try {
            Get-ADUser -Identity $username | Out-Null
        }
        # Wenn User $username nicht vorhanden, dann
        catch {
            # User $username erstellen
            New-ADUser `
                -Name "$vorname $nachname" `
                -GivenName "$vorname" `
                -Surname "$nachname" `
                -SamAccountName "$username" `
                -UserPrincipalName "$username@bztf.ch" `
                -Path $fullPath `
                -AccountPassword $config.InitPw `
                -Enabled $true `
                -HomeDrive "H" `
                -HomeDirectory "C:\Home\$class\$username" `
                -ErrorAction SilentlyContinue
            # $errorOccured auf $true setzen
            $errorOccured = $true
        }
        # Wenn $errorOccured = $true, dann
        if ($errorOccured -eq $true) {
            # Logging
            Write-Log -Level INFO -Message "User $username erstellt"
            # $errorOccured zuruecksetzen auf $false
            $errorOccured = $false
        }
        # Wenn $errorOccured nicht = $true, dann 
        else {
            # Logging
            Write-Log -Level WARN -Message "User $username bereits vorhanden"
        }
    }
}


createADUserAccount 