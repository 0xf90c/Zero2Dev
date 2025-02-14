# Trying bypass restrictions temporarily, if user is not admin
powershell -ExecutionPolicy Bypass -File install.ps1

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
    "3" = @{ Name = "Telegram"; ID = "Telegram.TelegramDesktop" }
    "4" = @{ Name = "Git"; ID = "Git.Git" }
    "5" = @{ Name = "Visual Studio Code"; ID = "Microsoft.VisualStudioCode" }
    "6" = @{ Name = "Rust"; ID = "Rustlang.Rustup" }
    "7" = @{ Name = "WinRAR"; ID = "RARLab.WinRAR" }
    "8" = @{ Name = "Transmission"; ID = "Transmission.Transmission" }
    "9" = @{ Name = "Rufus"; ID = "Rufus.Rufus" }
    "10" = @{ Name = "Zoom"; ID = "Zoom.Zoom" }
    "11" = @{ Name = "Steam"; ID = "Valve.Steam" }
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
            winget install --id $appId --scope user --silent --accept-source-agreements --accept-package-agreements | Tee-Object -FilePath "install_log.txt"
        }
    } else {
        Write-Host "Invalid selection: $index" -ForegroundColor Red
    }
}

Write-Host "`nInstallation process completed!" -ForegroundColor Cyan
