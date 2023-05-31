#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Eine interne Config File, für Pfäde und konstanten
# Erstellungsdatum: 04.05.2023
# Version: 1.0
# Bemerkungen: -
#--------------------------------------------------------------------------------



# HashTable der Variable $config mit den Keys und Values.
$config = @{
    SchuelerXML  = "files\schueler.xml"
    InitPw       = "bztf.001"
    OUPath       = "OU=schueler,DC=reboottutgut,DC=local"
    OULernende   = "Lernende"
    OUKlasse     = "Klassengruppen"
    LogFileUser  = "C:\tmp\users.log"
    LogFileGroup = "C:\tmp\groups.log"
    ClassFolder  = "C:\BZTF\Klassen"
}