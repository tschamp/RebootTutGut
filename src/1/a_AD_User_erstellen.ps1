# Pfade zur XML-Datei und zum Active Directory-Modul
$xmlFilePath = $($config["SchuelerXML"])

# Importieren des Active Directory-Moduls
Import-Module ActiveDirectory

# Funktion zum Erstellen eines AD-Benutzerkontos
function Create-ADUser {
    param(
        [string]$Name,
        [string]$Vorname,
        [string]$Benutzername,
        [string]$Klasse,
        [string]$Klasse2
    )
    
    # Benutzerattribute festlegen
    $SamAccountName = $Benutzername
    $UserPrincipalName = "$SamAccountName@bztf.ch"
    $Password = ConvertTo-SecureString -String "Passwort123" -AsPlainText -Force
    
    # Benutzerobjekt erstellen und dem AD hinzufügen
    $userParams = @{
        SamAccountName = $SamAccountName
        UserPrincipalName = $UserPrincipalName
        Name = "$Vorname $Name"
        GivenName = $Vorname
        Surname = $Name
        Enabled = $true
        PasswordNeverExpires = $true
        AccountPassword = $Password
        Path = "CN=Schueler,DC=reboottutgut,DC=local"
    }
    New-ADUser @userParams
    
    # Klasse zuweisen
    $user = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'"
    Set-ADUser -Identity $user -Description "$Klasse, $Klasse2"
}

# XML-Datei einlesen und Benutzer erstellen
$xml = [xml](Get-Content $xmlFilePath)

foreach ($userNode in $xml.MS.S) {
    $name = $userNode."#Name"
    $vorname = $userNode."#Vorname"
    $benutzername = $userNode."#Benutzername"
    $klasse = $userNode."#Klasse"
    $klasse2 = $userNode."#Klasse2"
    
    Create-ADUser -Name $name -Vorname $vorname -Benutzername $benutzername -Klasse $klasse -Klasse2 $klasse2
}
