VAGRANTFILE_API_VERSION = "2"

custom_props = File.expand_path("../vagrant_custom_properties", __FILE__)
load custom_props

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = $base_box
  config.vm.box_url = $base_box_url
  config.vm.box_version = "1.0.1"
  config.vm.network :private_network, ip: $ip
  config.vm.hostname = $host + ".local"

  # Mount/Sync extra folder '_opt' in host with '/opt' in guest
  # suitable to deploy *.car or other artifacts to servers or checking log files
  config.ssh.sudo_command = "sudo %c"
  #config.vm.synced_folder "_opt_wso2esb01/", "/opt/wso2/wso2esb01", create: false
  #config.vm.synced_folder "_opt_wso2esb02/", "/opt/wso2/wso2esb02", create: false
  #config.vm.synced_folder "_opt_wso2as521/", "/opt/wso2/wso2as521", create: false
  #config.vm.synced_folder "_opt_wso2am01/", "/opt/wso2/wso2am01", create: false
  #config.vm.synced_folder "_opt_wso2am02/", "/opt/wso2/wso2am02", create: false
  #config.vm.synced_folder "_opt_wso2greg01/", "/opt/wso2/wso2greg01", create: false
  #config.vm.synced_folder "_opt_wso2greg02/", "/opt/wso2/wso2greg02", create: false
  #config.vm.synced_folder "_opt_wso2dss01/", "/opt/wso2/wso2dss01", create: false
  #config.vm.synced_folder "_opt_wso2dss02/", "/opt/wso2/wso2dss02", create: false
  #config.vm.synced_folder "_opt_wso2is01/", "/opt/wso2/wso2is01", create: false
  #config.vm.synced_folder "_opt_wso2is02/", "/opt/wso2/wso2is02", create: false
  #config.vm.synced_folder "_opt_wso2das01/", "/opt/wso2/wso2das01", create: false
  #config.vm.synced_folder "_opt_wso2das02/", "/opt/wso2/wso2das02", create: false
  config.vm.synced_folder "_opt_wso2", "/opt/wso2", create: true



  # ==================================== #
  # WSO2 STACK FOR DEVELOPMENT (SERVERS) #
  # ==================================== #

  config.vm.define "wso2allinone" do |wso2allinone|

    # ESB-01 (offset +0)
    wso2allinone.vm.network "forwarded_port", guest: 9443, host: 9443
    wso2allinone.vm.network "forwarded_port", guest: 8280, host: 8280
    wso2allinone.vm.network "forwarded_port", guest: 8243, host: 8243

    # ESB-02 (offset +2)
    wso2allinone.vm.network "forwarded_port", guest: 9445, host: 9445
    wso2allinone.vm.network "forwarded_port", guest: 8282, host: 8282
    wso2allinone.vm.network "forwarded_port", guest: 8245, host: 8245

    # AS 5.2.1 (offset +30)
    wso2allinone.vm.network "forwarded_port", guest: 9473, host: 9473
    wso2allinone.vm.network "forwarded_port", guest: 8310, host: 8310
    
    # AM-01 (offset +4)
    wso2allinone.vm.network "forwarded_port", guest: 9447, host: 9447
    wso2allinone.vm.network "forwarded_port", guest: 8284, host: 8284

    # AM-02 (offset +6)
    wso2allinone.vm.network "forwarded_port", guest: 9449, host: 9449
    wso2allinone.vm.network "forwarded_port", guest: 8286, host: 8286

    # GREG-01 (offset +8)
    wso2allinone.vm.network "forwarded_port", guest: 9451, host: 9451

    # GREG-02 (offset +10)
    wso2allinone.vm.network "forwarded_port", guest: 9453, host: 9453

    # DSS-01 (offset +12)
    wso2allinone.vm.network "forwarded_port", guest: 9455, host: 9455
    wso2allinone.vm.network "forwarded_port", guest: 8292, host: 8292

    # DSS-02 (offset +14)
    wso2allinone.vm.network "forwarded_port", guest: 9457, host: 9457
    wso2allinone.vm.network "forwarded_port", guest: 8294, host: 8294

    # IS-01 (offset +16)
    wso2allinone.vm.network "forwarded_port", guest: 9459, host: 9459
    wso2allinone.vm.network "forwarded_port", guest: 8296, host: 8296

    # IS-02 (offset +18)
    wso2allinone.vm.network "forwarded_port", guest: 9461, host: 9461
    wso2allinone.vm.network "forwarded_port", guest: 8298, host: 8298

    # DAS-01 (offset +20)
    wso2allinone.vm.network "forwarded_port", guest: 9463, host: 9463
    wso2allinone.vm.network "forwarded_port", guest: 8300, host: 8300

    # DAS-02 (offset +22)
    wso2allinone.vm.network "forwarded_port", guest: 9465, host: 9465
    wso2allinone.vm.network "forwarded_port", guest: 8302, host: 8302

    # MySQL Port (No offset)
    wso2allinone.vm.network "forwarded_port", guest: 3306, host: 3306

    wso2allinone.vm.provider "virtualbox" do |vb|
      # Enable operations from VirtualBox GUI
      #vb.gui = true

      vb.name = $host
      vb.customize ["modifyvm", :id, "--memory", "8192"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ostype", "RedHat_64"]
      vb.customize ["modifyvm", :id, "--acpi", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]

      ### Bootstrap centos and binaries
      wso2allinone.vm.provision :shell, :path => "shell/bootstrap.sh"

      ### Install WSO2
      wso2allinone.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "site.pp"
        puppet.module_path = "puppet/modules"
        #puppet.options = '--parser future'
      end
    end

  end

end
