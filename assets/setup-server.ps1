<# Custom Script for Windows to install a file from Azure Storage #>
param(
    [string] $nvidiaDriverSetupPath
)

# ----- Silent install of NVidia driver -----
& ".\$nvidiaDriverSetupPath" -s -noreboot -clean

# ----- Sleep to allow the setup program to finish. -----
Start-Sleep -Seconds 120

# ----- NVidia driver installation requires a reboot. -----
Restart-Computer -Force
