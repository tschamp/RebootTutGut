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