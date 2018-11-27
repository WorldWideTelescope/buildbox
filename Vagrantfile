# -*- mode: ruby -*-
# Copyright 2018 the .Net Foundation
# Licensed under the MIT License

begin
  base_box = File.read('msedgewin10-newssh-box/.cfg_base_box').strip()
  base_box['pristine'] = 'newssh'
rescue Errno::ENOENT
  raise 'configure this box by recording the base box name in "msedgewin10-newssh-box/.cfg_base_box" (see README.md)'
end

Vagrant.configure("2") do |config|
  config.vm.box = base_box

  config.vm.provision "file0",
                      type: "file",
                      source: "wwt-bash.bat",
                      destination: "/Windows/wwt-bash.bat"

  config.vm.provision "stage0",
                      type: "shell",
                      binary: true,
                      privileged: false,
                      upload_path: "C:\\Windows\\Temp",
                      path: "provision_stage0.ps1"

  config.vm.provision "stage1",
                      type: "shell",
                      run: "never", # we tell them to do it manually
                      binary: true,
                      privileged: false,
                      upload_path: "C:\\Windows\\Temp",
                      path: "provision_stage1.ps1"

  config.vm.network :forwarded_port,
                    guest: 26993,
                    host: 26993
end
