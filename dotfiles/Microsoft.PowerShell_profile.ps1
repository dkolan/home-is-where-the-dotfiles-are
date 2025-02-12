# Oh My Posh Config
oh-my-posh init pwsh --config 'C:\i2dev\dkolan\.env\.oh-my-posh\dracula.omp.json' | Invoke-Expression

# Oh My Posh Extensions
Import-Module posh-git
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Git Aliases
Import-Module git-aliases -DisableNameChecking

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function Run-CMakeAndReplace {
    $sourceDir = "clang_build"

    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G "Ninja" -B $sourceDir

    $sourceFile = "clang_build\compile_commands.json"
    $destinationDir = "build"
    $destinationFile = "$destinationDir\compile_commands.json"

    if (!(Test-Path -Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir
    }

    Copy-Item -Path $sourceFile -Destination $destinationFile -Force
    Remove-Item -Path $sourceDir -Recurse -Force -ErrorAction SilentlyContinue

    (Get-Content -Path $destinationFile) -replace "clang_build", "build" | Set-Content -Path $destinationFile
}

Set-Alias compCmd Run-CMakeAndReplace

# zoxide needs to be at end
Invoke-Expression (& { (zoxide init powershell | Out-String) })