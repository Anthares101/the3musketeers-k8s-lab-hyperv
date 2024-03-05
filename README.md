# K8S lab on Hyperv (WIP)

## Pre-requisites

1. Enable Hyper-V:
   ```
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
   Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform
   Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
   ```
2. Windows Subsystem for Linux (WSL):
   ```
   wsl --install -d ubuntu
   wsl --set-version ubuntu 1
   ```
3. Vagrant (Inside WSL):
   ```
   echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.bashrc
   echo 'export VAGRANT_DEFAULT_PROVIDER=hyperv' >> ~/.bashrc
   source ~/.bashrc
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install vagrant -y
   ```
4. Install this Vagrant plugin (Inside WSL):
   ```
   vagrant plugin install vagrant-reload
   ```

## Deploy

Vagrant is gonna start three Ubuntu machines alongside a NAT switch called T3MSwitch with the
IP range 10.10.20.0/24, you may need to tweak this a bit if you have conflicts.

Put the repository directory anywhere **outside** WSL, for some reason Vagrant hates to be launched in WSL directories:
```bash
# When asked, choose the default Switch or any other with a DHCP server attached
vagrant up
```

## Clean up

If you want to just get rid of everything execute these commands:
1. Remove machines:
   ```
   vagrant destroy -f
   ```
2. In Powershell as administrator remove networking stuff:
   ```
   Remove-VMSwitch -SwitchName "T3MSwitch" -Force
   Remove-NetNat -Confirm:$false -Name "T3MNetwork"
   ```
3. Uninstall Hyper-V:
   ```
   Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
   Disable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform
   Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
   ```
