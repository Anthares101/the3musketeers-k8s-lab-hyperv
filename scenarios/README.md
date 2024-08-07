# Scenarios

All the scenarios have 2 Ansible playbooks, one to install the scenario and another for uninstalling it. You should be able to install different scenerarios at once without issues.

**More scenarios will be added in the future! Pull requests are also welcome!**

## Pre-requisites

Inside WSL, move to this directory and execute these commands to prepare your Ansible environment:
```bash
ansible-galaxy install -r requirements.yaml
sudo apt install sshpass
```

## Installing or uninstalling scenarios

Again from inside WSL, choose a scenario and move to its directory in order to install/uninstall it:
```bash
# Install command
ansible-playbook install.yaml

# Uninstall command
ansible-playbook uninstall.yaml
```