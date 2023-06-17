#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: einzelne User Verwalten im AD
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: funktioniert noch nicht so ganz
#--------------------------------------------------------------------------------


Import-Module ActiveDirectory
## wichtig
## ist der pfad für config datei
## pfad ist so kompliziert damit er von überall funktioniert, also auch vom main oder als eigenes skript
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")



## Für einzelne AD-Benutzer:
## Konto entsperren
## Konto aktivieren
## Passwort neu setzen





function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
 EINZELNE USER VERWALTUNG
 ----------------------------------------------------------------------
 Welche Aktion moechtest du ausfuehren? Gib die entsprechende Nummer ein:
[1] Konto entsperren
[2] Konto aktivieren
[3] Passwort neu setzen
[E] Zum Hauptmenue
[X] Programm beenden
"@
    $selection = Read-Host "Auswahl"
    switch ($selection) {
        '1' {
            Write-Host "Das Skript um einen Benutzer zu entsperren wird ausgeführt"
            Start-Sleep -Seconds 0.5
            $adUser = getADUser
            unlockADUser -username $adUser
            
        }
        '2' {
            $adUser = getADUser
            activateADUser -username $adUser
        }

        '3' {
            $adUser = getADUser
            resetADpwd -username $adUser
        }

        'E' {
            $Host.UI.RawUI.ForegroundColor = "Yellow"
            Write-Host "Wechsle zum Hauptmenue..."
            . "$($config["mainScriptPath"])"
            
            Start-Sleep -Seconds 5
        }

        'X' {
            $Host.UI.RawUI.ForegroundColor = "Red" 
            Write-Host "Programm wird beendet."
        }
        default {
            Write-Host "Ungültige Auswahl."
            Clear-Console
        }
    }
}

function Clear-Console {
    $Host.UI.RawUI.ForegroundColor = "Yellow"
    Start-Sleep -Seconds 1.25
    Clear-Host
    Show-MainMenu
}

function getADUser {
    $user = Read-Host = "Gebe den AD-Benutzernamen ein!" 
    return $user

}

function unlockADUser {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )
    $user = Get-ADUser -Identity $username
    if ($user) {
        if ($user.LockedOut) {
            $user | Unlock-ADAccount
            Write-Host "Das Konto für Benutzer $username wurde entsperrt."
            Start-Sleep -Seconds 5
            Clear-Console
        } else {
            Write-Host "Das Konto für Benutzer $username ist bereits entsperrt."
            Start-Sleep -Seconds 5
            Clear-Console
        }
    } else {
        Write-Host "Benutzer $username wurde nicht gefunden.."
        Start-Sleep -Seconds 5
        Clear-Console
    }
}


function activateADUser {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )
    # Code zum Aktivieren des AD-Benutzerkontos
    # Beispielcode:
    $user = Get-ADUser -Identity $username
    if ($user) {
        if (-not $user.Enabled) {
            $user | Enable-ADAccount
            Write-Host "Das Konto für Benutzer $username wurde aktiviert."
        } else {
            Write-Host "Das Konto für Benutzer $username ist bereits aktiviert."
        }
    } else {
        Write-Host "Benutzer $username wurde nicht gefunden."
    }
}


function resetADpwd {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )

    $user = Get-ADUser -Identity $username
    if ($user) {
        do {
            $newPassword = Read-Host "Gib das neue Passwort für den Benutzer $username ein" -AsSecureString
            $confirmPassword = Read-Host "Gib das neue Passwort erneut ein" -AsSecureString

            if ($newPassword -ne $confirmPassword) {
                Write-Host "Die Passwörter stimmen nicht überein. Bitte versuche es erneut."
            }
        } while ($newPassword -ne $confirmPassword)

        try {
            $user | Set-ADAccountPassword -NewPassword $newPassword -Reset
            Write-Host "Das Passwort für den Benutzer $username wurde erfolgreich zurückgesetzt."
        } catch {
            Write-Host "Fehler beim Zurücksetzen des Passworts: $_"
        }
    } else {
        Write-Host "Benutzer $username wurde nicht gefunden."
    }
}



Clear-Console