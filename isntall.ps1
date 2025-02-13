# Trying bypass restrictions temporarily, if user is not admin
powershell -ExecutionPolicy Bypass -File isntall.ps1

# Check for Windows Updates
Write-Host "Checking for Windows updates..." -ForegroundColor Cyan
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

# Function to check if an app is already installed
function Is-AppInstalled {
    param (
        [string]$appId
    )
    $installedApps = winget list | Select-String -Pattern $appId
    return $installedApps -ne $null
}

# Function to simulate a progress bar
function Show-Progress {
    param ($Message)
    Write-Host "$Message"
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity "Installing..." -Status "$i% Completed" -PercentComplete $i
        Start-Sleep -Milliseconds 500
    }
}

# Define the applications and their winget IDs
$apps = @{
    "1" = @{ Name = "Google Chrome"; ID = "Google.Chrome" }
    "2" = @{ Name = "Mozilla Firefox"; ID = "Mozilla.Firefox" }
    "3" = @{ Name = "7-Zip"; ID = "7zip.7zip" }
    "4" = @{ Name = "Visual Studio Code"; ID = "Microsoft.VisualStudioCode" }
    "5" = @{ Name = "Git"; ID = "Git.Git" }
    "6" = @{ Name = "Node.js"; ID = "OpenJS.NodeJS" }
    "7" = @{ Name = "Python"; ID = "Python.Python.3" }
    "8" = @{ Name = "Docker Desktop"; ID = "Docker.DockerDesktop" }
    "9" = @{ Name = "Postman"; ID = "Postman.Postman" }
    "10" = @{ Name = "Spotify"; ID = "Spotify.Spotify" }
    "11" = @{ Name = "VLC Media Player"; ID = "VideoLAN.VLC" }
    "12" = @{ Name = "WinRAR"; ID = "RARLab.WinRAR" }
    "13" = @{ Name = "qBittorrent"; ID = "qBittorrent.qBittorrent" }
    "14" = @{ Name = "Notepad++"; ID = "Notepad++.Notepad++" }
    "15" = @{ Name = "PowerToys"; ID = "Microsoft.PowerToys" }
    "16" = @{ Name = "ShareX"; ID = "ShareX.ShareX" }
    "17" = @{ Name = "Malwarebytes"; ID = "Malwarebytes.Malwarebytes" }
    "18" = @{ Name = "Bitwarden"; ID = "Bitwarden.Bitwarden" }
    "19" = @{ Name = "Rufus"; ID = "Rufus.Rufus" }
    "20" = @{ Name = "CCleaner"; ID = "Piriform.CCleaner" }
    "21" = @{ Name = "HWMonitor"; ID = "CPUID.HWMonitor" }
    "22" = @{ Name = "Windows Subsystem for Linux (WSL)"; ID = "Microsoft.WSL" }
    "23" = @{ Name = "PuTTY"; ID = "PuTTY.PuTTY" }
    "24" = @{ Name = "Microsoft Office"; ID = "Microsoft.Office" }
    "25" = @{ Name = "LibreOffice"; ID = "TheDocumentFoundation.LibreOffice" }
    "26" = @{ Name = "Zoom"; ID = "Zoom.Zoom" }
    "27" = @{ Name = "Telegram"; ID = "Telegram.TelegramDesktop" }
    "28" = @{ Name = "Steam"; ID = "Valve.Steam" }
    "29" = @{ Name = "OBS Studio"; ID = "OBSProject.OBSStudio" }
}

# Display available apps
Write-Host "`nSelect the applications you want to install:" -ForegroundColor Cyan
foreach ($key in $apps.Keys) {
    Write-Host "$key) $($apps[$key].Name)"
}

# Get user selection
$selection = Read-Host "`nEnter the numbers of the apps you want to install (comma-separated, e.g., 1,3,5 or 'all' to install everything)"

# If the user selects "all", install all apps
if ($selection -eq "all") {
    $selectedApps = $apps.Keys
} else {
    $selectedApps = $selection -split "," | ForEach-Object { $_.Trim() }
}

# Process selected apps
foreach ($index in $selectedApps) {
    if ($apps.ContainsKey($index)) {
        $appName = $apps[$index].Name
        $appId = $apps[$index].ID

        if (Is-AppInstalled $appId) {
            Write-Host "$appName is already installed. Skipping..." -ForegroundColor Yellow
        } else {
            Write-Host "Installing $appName..." -ForegroundColor Green
            Show-Progress "Installing $appName..."
            Start-Process -NoNewWindow -Wait -FilePath "winget" -ArgumentList "install --id $appId --scope user --silent --accept-source-agreements --accept-package-agreements --verbose-logs"
        }
    } else {
        Write-Host "Invalid selection: $index" -ForegroundColor Red
    }
}

Write-Host "`nInstallation process completed!" -ForegroundColor Cyan
