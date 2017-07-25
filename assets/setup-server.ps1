<# Custom Script for Windows to install a file from Azure Storage #>
param(
    [string] $nvidiaDriverSetupPath,
    [string] $nvidiaDriverCertPath
)


# Helper function to unzip files
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip {
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


# ----- Create a local directory for the files -----
$appsDir = "C:\assets\"
New-Item -Path $appsDir -ItemType directory


# ----- Setup NVidia drivers -----

# Copy driver file to the local directory (c:\assets\nvidia....\)
$driverPath = $appsDir + $nvidiaDriverSetupPath.Substring(0, $nvidiaDriverSetupPath.LastIndexOf('.'))
Copy-Item $nvidiaDriverSetupPath $appsDir
Unzip $appsDir$nvidiaDriverSetupPath $driverPath

# Install the NVidia cert
Copy-Item $nvidiaDriverCertPath $appsDir
certutil.exe -f -addstore "TrustedPublisher" $appsDir$nvidiaDriverCertPath

# Silent install of NVidia driver
#& $driverPath\setup.exe -noreboot -clean -noeula -nofinish -passive
& $driverPath\setup.exe -s -noreboot -clean 

# Sleep to allow the setup program to finish.
Start-Sleep -Seconds 120

# NVidia driver installation requires a reboot.
Restart-Computer -Force


