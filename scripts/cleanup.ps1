If((test-path -PathType container tmp)) {
    Remove-Item -LiteralPath "tmp" -Force -Recurse
}

If ("T3MSwitch" -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $FALSE) {
    Remove-VMSwitch -SwitchName "T3MSwitch" -Force
}

If ("10.10.20.0/24" -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $FALSE) {
    Remove-NetNat -Confirm:$false -Name "T3MNetwork"
}
