<#
.DESCRIPTION
My baseline structure
Customize as needed
#>

# ////////////////// Data //////////////////

$greet = @"
Welcome, Bro! Keep up the great work in becoming an elite Red Teamer and Security Researcher.
Study hard and stay motivated!
"@

$user = $env:USERPROFILE

# Common directories
$onedrive = "$user\OneDrive"
$infosec = "$onedrive\Study\Cybersecurity"
$pentest = "$onedrive\\Study\Cybersecurity\Pentest\kali_pentest"
$swe = "$onedrive\Study\Computer_science\Software_engineering"
$notes = "$onedrive\Notes"
$scripts = "$onedrive\Scripts"
$psScript = "$onedrive\Scripts\Powershell\Scripts"
$documents = "$onedrive\MyDocuments"

$files = "$onedrive\Notes\Program.txt",
         "$onedrive\Notes\Intern.txt",
         "$onedrive\Scripts\Powershell\Modules\SetupModule.psm1"

# Process to start (first step up)

$processes = Get-Process | Where-Object {
$_.MainWindowHandle -ne 0 -and  # Process has a main window
$_.MainWindowTitle.Trim() -ne ""  # Main window has a title
} | Select-Object -ExpandProperty Name

$runningProcesses = Get-Process | Select-Object -ExpandProperty Name

# In case somes processes don't appear based on the latter conditions or you want to add some, put the missing ones manually here
$addedProcesses = "VMware", "Code", "GNS3"

# ////////////////// Functions //////////////////

function Greeting {
    Write-Output $greet
}

# Location Command
function GoTo {
    param ([string]$Locate = $onedrive)
    Set-Location $Locate
}

# Run Processes

function UpdateStartingApps {
    while (1) {
        $UserInput = Read-Host "> Update starting Apps ? [y/n]"
        if ($UserInput -eq 'y') {
            Write-Output "Open every apps that you want them to start automatically, and close the unwanted (check backgrounds apps too)."
            Read-Host -Prompt "> When done press Enter to continue..."
            $processes | Out-File "$user\processes.txt"
            Write-Output "Processes Updated!`nThey will start automatically when tiggered using the module 'StartApps' function or the batch script ..."
            break
        }
        elseif ($UserInput -eq 'n') {
            Write-Output "Enjoy !!!"
            break
        }
        else {
            Write-Output "Input Error!"
        }
    }

}

function StartApps {
    param ([float]$WaitTime = 5)
    $runningProcesses
    foreach ($process in "$user\processes.txt", $addedProcesses) {
        if ($process -notin $runningProcesses) {
            Start-Process -FilePath $process -ErrorAction SilentlyContinue
            Start-Sleep -Seconds $WaitTime
        }
    }

    foreach ($file in $files) {
        if (Test-Path -LiteralPath $file) {
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
    foreach ($process in $runningProcesses) {
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
