#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Eine interne Config File, für Pfäde und konstanten
# Erstellungsdatum: 04.05.2023
# Version: 1.0
# Bemerkungen: -
#--------------------------------------------------------------------------------



# HashTable der Variable $config mit den Keys und Values.
$config = @{
    SchuelerCsv  = "C:\tmp\PSProjekt\schueler.csv"
    InitPw       = "bztf.001"
    OUPath       = "OU=BZTF,DC=bztf,DC=local"
    OULernende   = "Lernende"
    OUKlasse     = "Klassengruppen"
    LogFileUser  = "C:\tmp\users.log"
    LogFileGroup = "C:\tmp\groups.log"
    ClassFolder  = "C:\BZTF\Klassen"
}