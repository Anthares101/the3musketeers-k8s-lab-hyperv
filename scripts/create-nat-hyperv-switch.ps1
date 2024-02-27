# See: https://www.petri.com/using-nat-virtual-switch-hyper-v

If ("T3MSwitch" -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $FALSE) {
    'Creating Internal-only switch named "T3MSwitch" on Windows Hyper-V host...'

    New-VMSwitch -SwitchName "T3MSwitch" -SwitchType Internal
}
else {
    '"T3MSwitch" for static IP configuration already exists; skipping'
}

If ("10.10.20.1" -in (Get-NetIPAddress | Select-Object -ExpandProperty IPAddress) -eq $FALSE) {
    'Registering new IP address 10.10.20.1 on Windows Hyper-V host...'

    New-NetIPAddress -IPAddress 10.10.20.1 -PrefixLength 24 -InterfaceAlias "vEthernet (T3MSwitch)"
}
else {
    '"10.10.20.1" for static IP configuration already registered; skipping'
}

If ("10.10.20.0/24" -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $FALSE) {
    'Registering new NAT adapter for 10.10.20.0/24 on Windows Hyper-V host...'

    New-NetNAT -Name "T3MNetwork" -InternalIPInterfaceAddressPrefix 10.10.20.0/24
}
else {
    '"10.10.20.0/24" for static IP configuration already registered; skipping'
}
