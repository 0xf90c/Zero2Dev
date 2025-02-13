🚀 Windows Setup Script
An automated Windows setup script that installs essential tools and configures a development environment using winget.

📌 Features
✅ Automated Software Installation – Install selected apps via winget.
✅ No Admin Required – Runs without admin privileges.
✅ Checks & Skips Installed Apps – Prevents redundant installations.
✅ Configures Development Tools – Sets up PowerShell profile, Windows Terminal, and more.
✅ Git & Dotfiles Support – Clones and configures dotfiles.

🔧 Installation
Download the script
powershell
Копировать
Редактировать
git clone https://github.com/yourusername/WinSetupScript.git
cd WinSetupScript
Run the script
powershell
Копировать
Редактировать
powershell -ExecutionPolicy Bypass -File install.ps1
🛠️ Software Installed
Includes:

Git, VS Code, Rust, Volta, Starship, Just
Windows Terminal, PowerShell customizations
Other developer tools