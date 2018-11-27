# -*- mode: ruby -*-

begin
  base_box = File.read('msedgewin10-newssh-box/.cfg_base_box').strip()
  base_box['pristine'] = 'newssh'
rescue Errno::ENOENT
  raise 'configure this box by recording the base box name in "msedgewin10-newssh-box/.cfg_base_box" (see README.md)'
end

Vagrant.configure("2") do |config|
  config.vm.box = base_box

  config.vm.provision :file,
                      source: "wwtbash.bat",
                      destination: "/Windows/wwtbash.bat"

  config.vm.provision :shell,
                      binary: true,
                      privileged: false,
                      upload_path: "C:\\Windows\\Temp",
                      path: "provision.ps1"

  config.vm.network :forwarded_port,
                    guest: 26993,
                    host: 26993
end
