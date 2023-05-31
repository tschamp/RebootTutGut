#Geben Sie den Pfad zur Import-CSV-Datei ein.
$ADUsers = Import-csv C:\scripts\newusers.csv

foreach ($User in $ADUsers)
{

       $Username    = $User.username
       $Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
    $Department = $User.department
       $OU           = $User.ou

       #Überprüfen, ob das Benutzerkonto bereits in AD vorhanden ist.
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #Wenn ein Benutzer existiert, erstelle kein neues Benutzerkonto
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              #Wenn ein Benutzer nicht existiert, dann erstelle ein neues Benutzerkonto. 
          
        #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the"-UserPrincipalName" variable
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@yourdomain.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}