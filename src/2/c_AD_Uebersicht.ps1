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
            Write-Host "-User ohne Ablauf des Passworts wurde gewählt..-"
            Start-Sleep -Seconds 0.5
            Show-Deactivated
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




function Show-NoPassword {
    Get-ADUser -filter {PaswordNotRequired -eq $true} | Select-Object Name
    
}

function Show-NeverExpire{
    Get-ADUser -filter {Enabled -eq $TRUE -and PasswordNeverExpires -eq $TRUE} ` -Properties PasswordLastSet | Select-Object Name, PasswordLastSet | ` Sort-Object -Property Name -Descending | Format-Table
}

function Show-Deactivated {
    Get-ADUser -filter {Enabled -eq $false} | Select-Object Name PasswordLastSet
}


