#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Übersicht AD User
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: geht 100%
#--------------------------------------------------------------------------------

Import-Module ActiveDirectory
## wichtig
## ist der pfad für config datei
## pfad ist so kompliziert damit er von überall funktioniert, also auch vom main oder als eigenes skript
. (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "config.ini.ps1")

<#
- Übersicht über alle AD-Benutzer:
für welche kein Passwort gesetzt ist
Passwort läuft nie ab
deaktivierte/gesperrte AD-Benutzer
#>

function Show-MainMenu {
    $Host.UI.RawUI.ForegroundColor = "Green" 
    Write-Host @"
 USER UEBERSICHT
 ----------------------------------------------------------------------
 Welche Aktion moechtest du ausfuehren? Gib die entsprechende Nummer ein:
[1] User ohne Passwort
[2] User bei denen das Passwort nicht abläuft
[3] deaktivierte & gesperrte User
[E] Zum Hauptmenue
[X] Programm beenden
"@
    $selection = Read-Host "Auswahl"
    switch ($selection) {
        '1' {
            Write-Host "-User ohne Passwort wurde gewählt..-"
            Start-Sleep -Seconds 0.5
            Show-NoPassword
            
        }
        '2' {
            Write-Host "-User ohne Ablauf des Passworts wurde gewählt..-"
            Start-Sleep -Seconds 0.5
            Show-NeverExpire
        }

        '3' {
            Write-Host "-User mit Sperrungen wurde gewählt..-"
            Start-Sleep -Seconds 0.5
            Show-DeactivatedandLocked
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
            Write-Host "Ungueltige Auswahl."
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
        [string]$FunctionName,
        [string]$ErrorMessage
    )

    $logFile =  $($config["errorLog"])
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp | Es gab einen Fehler bei der Funktion $FunctionName. Fehlermeldung: $ErrorMessage"

    Add-Content -Path $logFile -Value $logEntry
}


function Show-NoPassword {
    $users = Get-ADUser -Filter {PasswordNeverExpires -eq $true -and PasswordNotRequired -eq $true} -Properties Name, SamAccountName
try {
    if ($users) {
        Write-Host "Benutzer ohne Passwort:"
        $users | Out-GridView 

    } else {
        Write-Host "Keine Benutzer ohne Passwort gefunden."

    }
    Standard-Log -FunctionName "Show-NoPassword"
} 

catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
    Error-Log -FunctionName "Show-NoPassword" -ErrorMessage $errorMessage
}

Press-AnyKey
}



function Show-NeverExpire {

try {
    $users = Get-ADUser -Filter {PasswordNeverExpires -eq $true} -Properties Name, SamAccountName

    if ($users) {
        Write-Host "Benutzer, bei denen das Passwort nicht abläuft:"
        $users | Out-GridView 
    } else {
        Write-Host "Keine Benutzer gefunden, bei denen das Passwort nicht abläuft."
    }
    Standard-Log -FunctionName "Show-NeverExpire"

}

catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
    Error-Log -FunctionName "Show-NeverExpire" -ErrorMessage $errorMessage
}


    Press-AnyKey
}


function Show-DeactivatedandLocked {

    try {
        $lockedUsers = Search-ADAccount -LockedOut | Get-ADUser -Properties Name, SamAccountName
        $disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties Name, SamAccountName

        $users = @()

        if ($lockedUsers) {
            $users += $lockedUsers
        }

        if ($disabledUsers) {
            $users += $disabledUsers
        }

        if ($users) {
            Write-Host "Gesperrte und deaktivierte Benutzer:"
            $users | Out-GridView 
        } else {
            Write-Host "Keine gesperrten oder deaktivierten Benutzer gefunden."
        }

        Standard-Log -FunctionName "Show-DeactivatedandLocked"
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Es gab einen Fehler beim Ausführen: $errorMessage"
        Error-Log -FunctionName "Show-DeactivatedandLocked" -ErrorMessage $errorMessage
    }

    Press-AnyKey
}





Clear-Console


