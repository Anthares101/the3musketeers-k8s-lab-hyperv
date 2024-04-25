# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  
  # Setup new NAT switch
  config.trigger.before :up do |trigger|
    trigger.info = "Creating 'T3MSwitch' Hyper-V switch if it does not exist..."
    trigger.run = {privileged: "true", inline: "powershell.exe -ep bypass -File scripts/create-nat-hyperv-switch.ps1"}
  end

  # Clean tmp directory
  config.trigger.after :destroy do |trigger|
    trigger.info = "Cleaning tmp directory if necessary..."
    trigger.run = {privileged: "true", inline: "powershell.exe -ep bypass -File scripts/delete-tmp.ps1"}
  end
  
  config.vm.synced_folder '.', '/vagrant', disabled: true


  # Machine images
  ubuntu2204 = "generic/ubuntu2204"

  # Types of connection
  com_ssh = "ssh"

  # VM configuration (Make sure IPs are in the range 10.10.20.0/24, the gateway is 10.10.20.1)
  vms = [
         {name: "athos", ip: "10.10.20.2", box: ubuntu2204, communicator:com_ssh},
         {name: "porthos", ip: "10.10.20.3", box: ubuntu2204, communicator:com_ssh},
         {name: "aramis", ip: "10.10.20.4", box: ubuntu2204, communicator:com_ssh}
        ]

  vms.each do |vm|
    config.vm.define vm[:name] do |box|
      box.vm.box = vm[:box]
      box.vm.hostname = vm[:name]
      box.vm.box_check_update = false
      box.vm.communicator = vm[:communicator]
      box.vm.network "public_network", :bridge => 'Default Switch'

      box.vm.provider "hyperv" do |hv|
        hv.vmname = "t3m_#{vm[:name]}"
        hv.cpus = 2
        hv.memory = "2048"
        hv.enable_enhanced_session_mode = true 
      end
	  
      # Hack to avoid selecting the Switch manually
      box.trigger.before :reload do |trigger|
        trigger.info = "Static IP configuration ready"
        trigger.run = {privileged: "true", inline: "powershell.exe -ep bypass -File scripts/static-ip-set.ps1 t3m_#{vm[:name]}"}
      end
      
      config.trigger.after :"VagrantPlugins::HyperV::Action::SetName", type: :action do |trigger|
        trigger.info = "If Static IP set force VM to use T3MSwitch switch"
        trigger.run = {privileged: "true", inline: "powershell.exe -ep bypass -File scripts/set-hyperv-switch.ps1 t3m_#{vm[:name]}"}
      end
      
      box.vm.provision "shell", path: "./scripts/configure-static-ip.sh", args: [vm[:ip]]
      box.vm.provision :reload

      box.vm.provision "ansible" do |ansible| 
        ansible.compatibility_mode = "2.0"
        ansible.limit = "#{vms[0][:name]}, #{vms[1][:name]}, #{vms[2][:name]}"
        ansible.playbook = "ansible/#{vm[:name]}.yaml"
      end
    end
  end

end
