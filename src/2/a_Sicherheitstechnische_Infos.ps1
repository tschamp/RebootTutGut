#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Eine interne Config File, für Pfäde und konstanten
# Erstellungsdatum: 04.05.2023
# Version: 1.0
# Bemerkungen: -
#--------------------------------------------------------------------------------

#Passwortalter

    #Variable um die UserListe einzulesen 
    $Users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword

    #Ablaufdatum der Passwörter aanzeigen
    $Users | Select-Object Name, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, PasswordLastSet


