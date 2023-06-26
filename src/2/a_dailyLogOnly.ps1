
Import-Module ActiveDirectory

$LogFilePath = "C:\temp\daily.log"
        $ADUsers = Get-ADUser -Filter * -Properties PasswordLastSet, LastLogonDate, LogonCount

        # Aktuelles Ausführungsdatum generieren
        $ExecutionDate = Get-Date -Format "yyyy-MM-dd"

        # Header mit aktuellem Ausführungsdatum erstellen
        $Header = 
"
----------------------------------------------------------------------------------------------------------------------------
Benutzername,Passwortgesetzt am,Datum der letzten Anmeldung,Anzahl der Logins -> Log wurde automatisch erstellt am: $ExecutionDate
----------------------------------------------------------------------------------------------------------------------------"

        # Header und Logeinträge zur Logdatei hinzufügen
        $Header | Out-File -FilePath $LogFilePath -Append -Encoding UTF8

        foreach ($User in $ADUsers) {
            # Benutzername abrufen
            $Username = $User.SamAccountName

            # Passwortalter berechnen
            $PasswordAge = $User.PasswordLastSet

            # Datum der letzten Anmeldung abrufen
            $LastLoginDate = $User.LastLogonDate

            # Anzahl der Logins abrufen
            $LoginCount = $User.LogonCount

            # Aktuellen Logeintrag zusammenstellen
            $LogEntry = "$Username,$PasswordAge,$LastLoginDate,$LoginCount"

            # Logeintrag zur Logdatei hinzufügen
            $LogEntry | Out-File -FilePath $LogFilePath -Append -Encoding UTF8
        }


     

