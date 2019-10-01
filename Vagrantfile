# -*- mode: ruby -*-
# Copyright 2018-2019 the .Net Foundation
# Licensed under the MIT License

begin
  base_box = File.read('.cfg_base_box').strip()
rescue Errno::ENOENT
  raise 'configure this box by recording the base box name in ".cfg_base_box" (see README.md)'
end

Vagrant.configure("2") do |config|
  config.vm.box = base_box
  config.vm.guest = :windows
  config.vm.boot_timeout = 1200
  config.vm.graceful_halt_timeout = 1200
  config.vm.communicator = 'winrm'
  config.winrm.username = "IEUser"
  config.winrm.password = "Passw0rd!"

  config.vm.provision "stage0",
                      type: "shell",
                      binary: true,
                      privileged: true,
                      upload_path: "C:\\Windows\\Temp",
                      path: "provision_stage0.ps1"

  config.vm.provision "stage1",
                      type: "shell",
                      run: "never", # we tell them to do it manually
                      binary: true,
                      privileged: true,
                      upload_path: "C:\\Windows\\Temp",
                      path: "provision_stage1.ps1"

  config.vm.network :forwarded_port,
                    guest: 26993,
                    host: 26993
end
