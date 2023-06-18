#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Übersicht AD User
# Erstellungsdatum: 04.05.2023
# Version: 1.2
# Bemerkungen: funktioniert noch nicht so ganz
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




function Show-NoPassword {
    $users = Get-ADUser -Filter {PasswordNeverExpires -eq $true -and PasswordNotRequired -eq $true} -Properties Name, SamAccountName

    if ($users) {
        Write-Host "Benutzer ohne Passwort:"
        $users | Format-Table Name, SamAccountName -AutoSize
    } else {
        Write-Host "Keine Benutzer ohne Passwort gefunden."
    }

    Press-AnyKey
}


function Show-NeverExpire {
    $users = Get-ADUser -Filter {PasswordNeverExpires -eq $true} -Properties Name, SamAccountName

    if ($users) {
        Write-Host "Benutzer, bei denen das Passwort nicht abläuft:"
        $users | Format-Table Name, SamAccountName -AutoSize
    } else {
        Write-Host "Keine Benutzer gefunden, bei denen das Passwort nicht abläuft."
    }

    Press-AnyKey
}


function Show-DeactivatedandLocked {
    $lockedUsers = Search-ADAccount -LockedOut | Get-ADUser -Properties Name, SamAccountName
    $disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties Name, SamAccountName

    $users = $lockedUsers + $disabledUsers

    if ($users) {
        Write-Host "Gesperrte und deaktivierte Benutzer:"
        $users | Format-Table Name, SamAccountName -AutoSize
    } else {
        Write-Host "Keine gesperrten oder deaktivierten Benutzer gefunden."
    }

    Press-AnyKey
}




Clear-Console


