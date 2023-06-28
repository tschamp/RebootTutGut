#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: einzelne User Verwalten im AD
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: funktioniert noch nicht so ganz 
#--------------------------------------------------------------------------------

Import-Module ActiveDirectory

## wichtig
## ist der Pfad für die Konfigurationsdatei
## Der Pfad ist so kompliziert, damit er von überall funktioniert, also auch vom Hauptskript oder als eigenes Skript
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")

## Für einzelne AD-Benutzer:
## Konto entsperren
## Konto aktivieren
## Passwort zurücksetzen

function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
 EINZELNE USER VERWALTUNG
 ----------------------------------------------------------------------
 Welche Aktion möchtest du ausführen? Gib die entsprechende Nummer ein:
[1] Konto entsperren
[2] Konto aktivieren
[3] Passwort zurücksetzen
[E] Zum Hauptmenü
[X] Programm beenden
"@
    $selection = Read-Host "Auswahl"
    switch ($selection) {
        '1' {
            Write-Host "Das Skript zum Entsperren eines Benutzers wird ausgeführt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heißt der Benutzer"
            unlockADUser -username $adUser
            Press-AnyKey
        }
        '2' {
            Write-Host "Das Skript zum Aktivieren eines Benutzers wird ausgeführt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heißt der Benutzer"
            activateADUser -username $adUser
            Press-AnyKey
        }
        '3' {
            Write-Host "Das Skript zum Zurücksetzen des Passworts wird ausgeführt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heißt der Benutzer"
            resetADpwd -username $adUser
            Press-AnyKey
        }
        'E' {
            $Host.UI.RawUI.ForegroundColor = "Yellow"
            Write-Host "Wechsle zum Hauptmenü..."
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

function Press-AnyKey {
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host @"
    ----------------------------------------------------------------
    Drücke eine beliebige Taste, um zum Menü zurückzukehren.
"@
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Console
}

function Standard-Log {
    param (
        [string]$FunctionName
    )

    $logFile =  $($config["succesfulLog"])
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp | Die Funktion '$FunctionName' wurde erfolgreich ausgeführt."
    Add-Content -Path $logFile -Value $logEntry
}

function Error-Log {
    param (
        [string]$FunctionName,
        [string]$ErrorMessage
    )

    $logFile =  $($config["errorLog"])
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp | Bei der Funktion '$FunctionName' ist ein Fehler aufgetreten. Fehlermeldung: $ErrorMessage"
    Add-Content -Path $logFile -Value $logEntry
}

function unlockADUser {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )

    try {
        $user = Get-ADUser -Identity $username
        if ($user) {
            if ($user.LockedOut) {
                Unlock-ADAccount -Identity $user
                Write-Host "Das Konto für Benutzer $username wurde entsperrt."
            } else {
                Write-Host "Das Konto für Benutzer $username ist bereits entsperrt."
            }
        } 

        Standard-Log -FunctionName "unlockADUser"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen."
        Error-Log -FunctionName "unlockADUser" -ErrorMessage $errorMessage
    }
    Press-AnyKey
}

function activateADUser {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )

    try {
        $user = Get-ADUser -Identity $username
        if ($user) {
            if (-not $user.Enabled) {
                Enable-ADAccount -Identity $user
                Write-Host "Das Konto für Benutzer $username wurde aktiviert."
            } else {
                Write-Host "Das Konto für Benutzer $username ist bereits aktiviert."
            }
        } else {
            Write-Host "Benutzer $username wurde nicht gefunden."
        }
        Standard-Log -FunctionName "activateADUser"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen."
        Error-Log -FunctionName "activateADUser" -ErrorMessage $errorMessage
    }
    Press-AnyKey
}

function resetADpwd {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username
    )

    try {
	    $user = Get-ADUser -Identity $Username

            $newPassword = Read-Host "Gib das neue Passwort ein" -AsSecureString
            $confirmPassword = Read-Host "Bestätige das neue Passwort" -AsSecureString
            
            # Passwort überprüfen ob sie richtig sind
            $newPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
            $confirmPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))

            $passwordMatch = $newPasswordText -eq $confirmPasswordText
            
            if (-not $passwordMatch) {
                Write-Host "Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut."
                Press-AnyKey
            }
            Set-ADAccountPassword -Identity $user -NewPassword $newPassword
            Write-Host "Das Passwort für Benutzer '$user' wurde erfolgreich geändert."

        Standard-Log -FunctionName "resetADpwd"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen."
        Error-Log -FunctionName "resetADpwd" -ErrorMessage $errorMessage
    }
    Press-AnyKey

}


Clear-Console
