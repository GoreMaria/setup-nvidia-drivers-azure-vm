The repository contains the assets to accompany the blog post at [http://michaelscollier.com/](https://michaelcollier.wordpress.com/2017/08/04/how-to-setup-nvidia-driver-on-nv-series-azure-vm).

Be sure to use obtain the NVIDIA driver setup file from [Set up GPU drivers for N-series VMs running Windows Server](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/n-series-driver-setup). Save the file to your the 'assets' directory.

Modify the deploy.ps1 file to use your Azure subscription ID, and desired resource group and storage account. The script will create the resource group and storage account. The script will also upload the NVIDIA driver setup file to the designated storage account.

### Resources ###
[Set up GPU drivers for N-series VMs running Windows Server](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/n-series-driver-setup)