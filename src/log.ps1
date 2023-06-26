
# Import config
# Import config
. ".\config.ini.ps1"



function Write-Log {
    # Erlaubt es diese Funktion wie ein Cmdlet zu nutzen
    [CmdletBinding()]

    # Parameter setzen
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "WARN", "ERROR")]
        [String]
        $Level = "INFO",

        [Parameter(Mandatory = $true)]
        [String]
        $Message
    )

    # Eingabe des Level zu Grossbuchstaben machen
    $Level = $Level.ToUpper()

    # Zeitstempfel generieren
    $stamp = (Get-Date).toString("yyyy-MM-dd HH:mm:ss")
    # Linie schreiben mit $stamp, $Level und $Message
    $line = "[$stamp] [$Level] - $Message"

    # Ordner "log" erstellen, falls bereits existiert, Fehler nicht ausgeben
    New-Item log -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    # Datei "all.log" erstellen, falls bereits existiert, Fehler nicht ausgeben
    New-Item $($config["AllLog"])-ErrorAction SilentlyContinue | Out-Null
    # Datei "info.log" erstellen, falls bereits existiert, Fehler nicht ausgeben
    New-Item $($config["InfoLog"]) -ErrorAction SilentlyContinue | Out-Null
    # Datei "warn.log" erstellen, falls bereits existiert, Fehler nicht ausgeben
    New-Item $($config["WarnLog"]) -ErrorAction SilentlyContinue | Out-Null
    # Datei "error.log" erstellen, falls bereits existiert, Fehler nicht ausgeben
    New-Item $($config["ErrorLogs"]) -ErrorAction SilentlyContinue | Out-Null

    # Linie zu "all.log" hinzufuegen
    Add-Content $($config["AllLog"]) -Value $line
    # Log-Nachricht in Konsole ausgeben
    Write-Host $Message

    # Wenn Level
    switch ($Level) {
        # INFO, Linie zu "info.log" hinzufuegen
        INFO {
            Add-Content $($config["InfoLog"]) -Value $line
        }
        # WARN, Linie zu "warn.log" hinzufuegen
        WARN {
            Add-Content $($config["WarnLog"])-Value $line
        }
        # ERROR, Linie zu "error.log" hinzufuegen
        ERROR {
            Add-Content $($config["ErrorLogs"]) -Value $line
        }
    }
}
