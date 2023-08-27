$user = "path/to/user/directory"

# ////////////////// Data //////////////////

# Greeting Message
$greet = @"
Welcome, Bro! Keep up the great work in becoming an expert in offensive security.
Study hard and stay motivated!
"@

# Common directories
$onedrive = "$user\OneDrive"
$powershell = "$onedrive\Scripts\Powershell"
$swe = "$onedrive\Study\Computer_science\Software_engineering"
$cyber = "$onedrive\Study\Computer_science\Cybersecurity"
$projets = "$onedrive\Study\Computer_science\Software_engineering\Projects"
$documents = "$onedrive\MyDocuments"

# Process to start
$processes = "msedge", "taskmgr", "explorer", "pycharm64", "VirtualBox", "code", "chrome" # Those have to be in the path variable to work properly
$files = "$onedrive\Schedule\Program.txt",
         "$onedrive\Schedule\Study_map.txt",
         "$onedrive\Schedule\Note.txt",
         "$onedrive\Scripts\Powershell\Modules\SetupModule.psm1",
         "$onedrive\Others\brouillon.txt"

# ////////////////// Functions //////////////////

function Greeting {
    Write-Output $greet
}

# Location Command
function GoToLocation {
    param ([string]$Locate = $onedrive)
    Set-Location $Locate
}

# Run Processes

function StartApps {
    param ([float]$WaitTime = 5)
    $runningProcesses = Get-Process | Select-Object -ExpandProperty Name
    foreach ($process in $processes) {
        if ($process -notin $runningProcesses) {
            Start-Process -FilePath $process -ErrorAction SilentlyContinue
            Start-Sleep -Seconds $WaitTime
        }
    }

    foreach ($file in $files) {
        if (Test-Path $file) {
            Start-Process -FilePath $file -ErrorAction SilentlyContinue
        }
    }
}

function MemoryCheck {
    param (
        [float]$MinMemory = 2.5,
        [float]$TimeGap = 120
    )

    while ($true) {
        $availableMemory = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB
        $date = Get-Date -Format "hh:mm:s"
        if ($availableMemory -lt $MinMemory) {
            $message = "Warning: Available memory is less than $MinMemory GB ($availableMemory)"
            $title = "Low Memory"
            Write-Output "" $title $message $date ""
        }
        else {
            Write-Output "" "Nothing wrong ($availableMemory)" $date ""
        }
        Start-Sleep -Seconds $TimeGap
    }
}

function StopApps {
    foreach ($process in $processes) {
        $runningProcess = Get-Process -Name $process -ErrorAction SilentlyContinue
        if ($runningProcess) {
            Stop-Process -Id $runningProcess.Id -Force
        }
    }
    Stop-Process -Name notepad
}

function Restart {
    param ([float]$WaitTime = 10)
    StopApps
    Start-Sleep -Seconds $WaitTime
    Restart-Computer -Force
}

# ////////////////// Exports //////////////////

Export-ModuleMember -Function *
Export-ModuleMember -Variable *
