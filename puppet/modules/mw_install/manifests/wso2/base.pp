class mw_install::wso2::base {

    if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
            allow_virtual => $allow_virtual_packages,
        }
    }

    # Ensures /usr/java exists (will be used in several java-related installs later on)
    file { '/usr/java':
        ensure => directory,
        mode => 755,
        owner   => "root",
        group   => "root",
    }

    # Ensures /opt/wso2 exists (this is where the WSO2 prodcuts will be installed)
    file { '/opt/wso2':
        ensure => directory,
        mode => 755,
        owner   => "root",
        group   => "root",
    }
    file { '/opt/wso2/patches':
        ensure => directory,
        mode => 755,
        owner   => "root",
        group   => "root",
    }

    # Used to save packages installed locally
    file { '/opt/Datacom':
        ensure => directory,
        mode   => 755,
        owner  => "root",
        group  => "root",
    }
    file { '/opt/Datacom/Apache':
        ensure => directory,
        mode   => 755,
        owner  => "root",
        group  => "root",
    }
    file { '/opt/Datacom/Oracle':
        ensure => directory,
        mode   => 755,
        owner  => "root",
        group  => "root",
    }
    file { '/opt/Datacom/WSO2':
        ensure => directory,
        mode   => 755,
        owner  => "root",
        group  => "root",
    }
 

    # Enables "Unlimited Strenght" for JCE
    mw_install::unzip { "UnlimitedJCEPolicy":
        zip_path     => "/vagrant/_downloads",
        zip_filename => "UnlimitedJCEPolicyJDK7.zip",
        install_dir  => "/usr/java",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    } -> 

    file { "/usr/java/default/lib/security/local_policy.jar":
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => '/usr/java/UnlimitedJCEPolicy/local_policy.jar',
    } -> 

    file { "/usr/java/default/lib/security/US_export_policy.jar":
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => '/usr/java/UnlimitedJCEPolicy/US_export_policy.jar',
    }

    # Installs Apache Ant 1.9.6
    mw_install::untar { "apache-ant-1.9.6":
        tar_path     => "/vagrant/_downloads",
        tar_filename => "apache-ant-1.9.6-bin.tar.gz",
        install_dir  => "/usr/java",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    }
    file { '/usr/java/apache-ant':
        ensure => link,
        target => "/usr/java/apache-ant-1.9.6",
    }
    file { "ant.sh":
        name   => '/etc/profile.d/ant.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/ant.sh',
    }

    # Installs Apache Maven 3.3.9
    mw_install::untar { "apache-maven-3.3.9":
        tar_path     => "/vagrant/_downloads",
        tar_filename => "apache-maven-3.3.9-bin.tar.gz",
        install_dir  => "/usr/java",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    }
    file { '/usr/java/apache-maven':
        ensure => link,
        target => "/usr/java/apache-maven-3.3.9",
    }
    file { "maven.sh":
        name   => '/etc/profile.d/maven.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/maven.sh',
    }

    # Installs Apache ActiveMQ 5.12.3
    mw_install::untar { "apache-activemq-5.12.3":
        tar_path     => "/vagrant/_downloads",
        tar_filename => "apache-activemq-5.12.3-bin.tar.gz",
        install_dir  => "/usr/java",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    }
    file { '/usr/java/apache-activemq':
        ensure => link,
        target => "/usr/java/apache-activemq-5.12.3",
    }
    
    # Define JAVA_HOME and add JDK bin to $PATH
    file { "java.sh":
        name   => '/etc/profile.d/java.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/java.sh',
    }

    file { "activemq.sh":
        name   => '/etc/profile.d/activemq.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/activemq.sh',
    }

    # Deploys WSO2ESB 4.9.0 Binaries
    mw_install::unzip { "wso2esb-4.9.0":
        zip_path     => "/vagrant/_downloads",
        zip_filename => "wso2esb-4.9.0.zip",
        install_dir  => "/opt/wso2",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    } 

    # Deploys WSO2GREG 5.1.0 Binaries
    mw_install::unzip { "wso2greg-5.1.0":
        zip_path     => "/vagrant/_downloads",
        zip_filename => "wso2greg-5.1.0.zip",
        install_dir  => "/opt/wso2",
        store_dir    => "/vagrant/_downloads",
        user         => "root",
        group        => "root",
    } 

}
