# K8S lab on Hyperv

WIP

## Pre-requisites

```
vagrant plugin install vagrant-reload
```

## Deploy

Vagrant is gonna start three Centos machines alongside a NAT switch called LTMSwitch with the
IP range 10.10.20.0/24, you may need to tweak this a bit if you have conflicts.

Deploy or destroy everything:
```powershell
vagrant up [--provision] # No ansible yet so avoid the parameter xd
vagrant destroy -f
```
