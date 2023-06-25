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
            Write-Host "Das Skript um einen Benutzer zu entsperren wird ausgefuehrt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heisst der Benutzer"
            unlockADUser -username $adUser
            Press-AnyKey
            
        }
        '2' {
            Write-Host "Das Skript um einen Benutzer zu aktivieren wird ausgefuehrt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heisst der Benutzer"
            activateADUser -username $adUser
            Press-AnyKey
        }

        '3' {
            Write-Host "Das Skript um das Passwort zurueckzusetzen wird ausgefuehrt"
            Start-Sleep -Seconds 0.5
            $adUser = Read-Host "Wie heisst der Benutzer"
            resetADpwd -username $adUser
            Press-AnyKey
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

function Press-AnyKey {
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host "
    ----------------------------------------------------------------
    Druecken Sie eine beliebige Taste, um zum Menu zurueckzukehren."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Console
}

function Standard-Log {
    param (
        [string]$FunctionName
    )

    $logFile =  $($config["succesfulLog"])


    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp | Folgende Funktion wurde korrekt ausgeführt: $FunctionName"

    Add-Content -Path $logFile -Value $logEntry
}
function Error-Log {
    param (
        [string]$FunctionName
    )

    $logFile =  $($config["errorLog"])


    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp | Es gab einen Fehler bei der Funktion $FunctionName"

    Add-Content -Path $logFile -Value $logEntry
}



# Funktioniert nicht, entsperrt einfach nicht 
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
    } else {
        Write-Host "Benutzer $username wurde nicht gefunden."
    }
    Standard-Log -FunctionName "unlockADUser"

}

catch {
    Write-Host "Es gab einen Fehler beim Ausführen."

    Error-Log -FunctionName "unlockADUser"

}

    Press-AnyKey
}



# Funktioniert 100%
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
        Write-Host "Es gab einen Fehler beim Ausführen."
        Error-Log -FunctionName "activateADUser"
    }
   
    Press-AnyKey
}

# Funktioniert so
# aber das mit password policy ist komisch und geht nicht
function resetADpwd {
    param (
        [Parameter(Mandatory=$true)]
        [string]$username
    )
    try {
    $user = Get-ADUser -Identity $username
    if ($user) {
        $newPassword = Read-Host "Geben Sie das neue Passwort für Benutzer $username ein" -AsSecureString
        $confirmPassword = Read-Host "Bestätigen Sie das neue Passwort für Benutzer $username" -AsSecureString
        
        $newPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
        $confirmPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))
        
        if ($newPasswordPlain -eq $confirmPasswordPlain) {
            $newPasswordSecure = ConvertTo-SecureString -String $newPasswordPlain -AsPlainText -Force
            $user | Set-ADAccountPassword -NewPassword $newPasswordSecure -Reset
            Write-Host "Das Passwort für Benutzer $username wurde erfolgreich zurückgesetzt."
            $Host.UI.RawUI.ForegroundColor = "Blue"
            Write-Host "Achtung! Falls du eine Fehlermeldung siehst, erfüllt dein Passwort unseren Anforderungen nicht und wurde nicht zurückgesetzt"

        } else {
            Write-Host "Es gab einen Fehler! Du hast dich vertippt!"
        }
    } else {
        Write-Host "Benutzer $username wurde nicht gefunden."
    }
    Standard-Log -FunctionName "resetADpwd"


}

catch {
    Write-Host "Es gab einen Fehler beim Ausführen."
    Error-Log -FunctionName "resetADpwd"

}
    Press-AnyKey
}














Clear-Console