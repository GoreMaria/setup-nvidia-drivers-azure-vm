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

if (!(Test-Path -Path $appsDir)) {
    New-Item -Path $appsDir -ItemType directory -Force
}


# ----- Unzip the NVidia driver file to the local path.
$localDriverPath = $appsDir + $nvidiaDriverSetupPath.Substring(0, $nvidiaDriverSetupPath.LastIndexOf('.'))
Unzip $nvidiaDriverSetupPath $localDriverPath

# ----- Install the NVidia certificate in the VM's TrustedPublisher store.
certutil.exe -f -addstore "TrustedPublisher" $nvidiaDriverCertPath

# ----- Silent install of NVidia driver -----
& $localDriverPath\setup.exe -s -noreboot -clean 

# ----- Sleep to allow the setup program to finish. -----
Start-Sleep -Seconds 120

# ----- NVidia driver installation requires a reboot. -----
Restart-Computer -Force
