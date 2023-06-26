#--------------------------------------------------------------------------------
# Autor: David Strainovic & Timo Schreiber
# Funktion des Skripts: Eine interne Config File, für Pfäde und konstanten
# Erstellungsdatum: 04.05.2023
# Version: 1.0
# Bemerkungen: -
#--------------------------------------------------------------------------------



# HashTable der Variable $config mit den Keys und Values.
$config = @{
    mainScriptPath = "./main.ps1"
    SchuelerXML  = ".\files\schueler.xml"
    SchuelerCSV  = ".\files\schueler.csv"
    InitPw       = "bztf.001"
    OUPath       = "CN=schueler,DC=reboottutgut,DC=local"
    OULernende   = "Lernende"
    OUKlasse     = "Klassengruppen"
    LogFileUser  = "C:\tmp\users.log"
    LogFileGroup = "C:\tmp\groups.log"
    ClassFolder  = "C:\BZTF\Klassen"
    
    # Einzelne Skripts
    createUsers = "1\a_AD_User_erstellen.ps1"
    deactivateUsers = "1\a_AD_User_deaktivieren.ps1"
    createGroups = "1\b_AD_Gruppen_erstellen.ps1"
    deactivateGroups = "1\b_AD_Gruppen_deaktivieren.ps1"

    securityLogs = "2\a_Sicherheitstechnische_Infos.ps1"
    manualLogPath = "..\logs\manual.log"
    dailyLogPath = "..\logs\daily.log"
    logOnly = "2\a_dailyLogOnly.ps1"
    manageUser = "2\b_einzelne_AD_User_Verwalten.ps1"
    overviewUser = "2\c_AD_Uebersicht"

    #log
    succesfulLog = "..\logs\succesful.log"
    errorLog = "..\logs\error.log"

    # hacker
    art1 = 
    "  _____      _                 _     _______    _      _____       _   
    |  __ \    | |               | |   |__   __|  | |    / ____|     | |  
    | |__) |___| |__   ___   ___ | |_     | |_   _| |_  | |  __ _   _| |_ 
    |  _  // _ \ '_ \ / _ \ / _ \| __|    | | | | | __| | | |_ | | | | __|
    | | \ \  __/ |_) | (_) | (_) | |_     | | |_| | |_  | |__| | |_| | |_ 
    |_|  \_\___|_.__/ \___/ \___/ \__|    |_|\__,_|\__|  \_____|\__,_|\__|
                                                                          
                                                                          "

    art2 = "
    _____                                   
    / ____|                                  
   | |  __ _ __ _   _ _ __  _ __   ___ _ __  
   | | |_ | '__| | | | '_ \| '_ \ / _ \ '_ \ 
   | |__| | |  | |_| | |_) | |_) |  __/ | | |
    \_____|_|   \__,_| .__/| .__/ \___|_| |_|
                     | |   | |               
                     |_|   |_|               
    "

    art3 = "
    _    _               
    | |  | |              
    | |  | |___  ___ _ __ 
    | |  | / __|/ _ \ '__|
    | |__| \__ \  __/ |   
     \____/|___/\___|_|   
                          
                          
    "
  
}