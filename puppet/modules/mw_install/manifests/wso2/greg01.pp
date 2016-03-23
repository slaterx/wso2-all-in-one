class mw_install::wso2::greg01 {

    if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
            allow_virtual => $allow_virtual_packages,
        }
    }

    ##### Configurable parameters starts here #####

    # JVM tunning
    $jvm_xms = "256m"
    $jvm_xmx = "512m"

    # database and registry configuration
    $db_user = "wso2_app"
    $db_password = "wso2_app"
    $reg_datasource = "jdbc/WSO2RegistryDB"
    $reg_db_url = "jdbc:mysql://wso2-all-in-one:3306/reg_db"
    $usermgt_datasource = "jdbc/WSO2UserMgtDB"
    $usermgt_db_url = "jdbc:mysql://wso2-all-in-one:3306/user_mgt_db"
    $idn_datasource = "jdbc/WSO2IdentityDB"
    $idn_db_url = "jdbc:mysql://wso2-all-in-one:3306/idn_greg_db"

    # port/hostname configuration
    $hostname = "sit-greg-esb.intnp.wd.govt.nz"
    $mgt_hostname = "sit-greg-esb.intnp.wd.govt.nz"
    $port_offset = "0"
    #$port_http = "8080"
    #$port_proxy_http = "80"
    $port_https = "9451"
    #$port_proxy_https = "443"

    # SVN deployment
    $dep_sync_enabled = "false"
    $dep_sync_auto_commit = "false"
    $dep_sync_auto_checkout = "true"
    $dep_sync_repository_type = "svn"
    $dep_sync_svn_url = "http://svnrepo.example.com/repos/"
    $dep_sync_svn_user = "username"
    $dep_sync_svn_password = "password"
    $dep_sync_svn_append_tenant_id = "true"

    ##### Configurable parameters ends here #####

    # Deploys WSO2GREG 5.1.0
    mw_install::filecopy { "wso2greg-5.1.0_wso2greg01":
        file          => "wso2greg-5.1.0",
        origin        => "/opt/wso2",
        destination   => "/opt/wso2/wso2greg01",
        user          => "root",
        group         => "root",
        require       => Class['mw_install::wso2::base']
    } -> 

    # Deploys the MySQL JDBC driver
    file { "/opt/wso2/wso2greg01/repository/components/lib/mysql-connector-java-5.1.38-bin.jar":
        mode    => 644,
        owner   => "root",
        group   => "root",
        source  => '/vagrant/_downloads/mysql-connector-java-5.1.38-bin.jar',
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # WSO2GREG startup script
    file { '/opt/wso2/wso2greg01/bin/wso2server.sh':
        mode    => 755,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2greg-5.1.0/bin/wso2server.sh.erb'),
        #require => File["/opt/wso2/wso2greg01"],
    }  -> 

    # Template for the master datasource configuration
    file { '/opt/wso2/wso2greg01/repository/conf/datasources/master-datasources.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2greg-5.1.0/repository/conf/datasources/master-datasources.xml.erb'),
        #require => File["/opt/wso2/wso2greg01"],
    }  -> 

    # Template for conf/user-mgt.xml
    file { '/opt/wso2/wso2greg01/repository/conf/user-mgt.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2greg-5.1.0/repository/conf/user-mgt.xml.erb'),
        #require => File["/opt/wso2/wso2greg01"],
    }  -> 

    # Template for conf/carbon.xml
    file { '/opt/wso2/wso2greg01/repository/conf/carbon.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2greg-5.1.0/repository/conf/carbon.xml.erb'),
        #require => File["/opt/wso2/wso2greg01"],
    }  -> 

    # Template for conf/tomcat/catalina-server.xml'
    file { '/opt/wso2/wso2greg01/repository/conf/tomcat/catalina-server.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2greg-5.1.0/repository/conf/tomcat/catalina-server.xml.erb'),
        #require => File["/opt/wso2/wso2greg01"],
    }  

}
