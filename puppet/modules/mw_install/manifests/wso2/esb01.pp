class mw_install::wso2::esb01 {

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
    $reg_remote_instance = "https://wso2-all-in-one:9451/registry"

    # port/hostname configuration
    $hostname = "wso2-all-in-one"
    $mgt_hostname = "wso2-all-in-one"
    $port_offset = "0"
    $port_http = "8280"
    #$port_proxy_http = "80"
    $port_https = "9443"
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

    # Clustering / etc
    #$product_profile = "worker"
    $clustering = "false"
    $cluster_sub_domain = "mgt"

    # SMTP configuration
    $smtp_host = "wso2-all-in-one"
    $smtp_port = "25"
    $smtp_starttls_enable = "false"
    $smtp_auth_enable = "false"
    #$smtp_user = "synapse.demo.0"
    #$smtp_password = "mailpassword"
    $smtp_from = "wso2esb01@wso2-all-in-one"

    ##### Configurable parameters ends here #####

    mw_install::filecopy { "wso2esb-4.9.0_wso2esb01":
        file          => "wso2esb-4.9.0",
        origin        => "/opt/wso2",
        destination   => "/opt/wso2/wso2esb01",
        user          => "root",
        group         => "root",
        require       => Class['mw_install::wso2::base']
    } -> 

    # Deploys the MySQL JDBC driver
    file { "/opt/wso2/wso2esb01/repository/components/lib/mysql-connector-java-5.1.38-bin.jar":
        mode    => 644,
        owner   => "root",
        group   => "root",
        source  => '/vagrant/_downloads/mysql-connector-java-5.1.38-bin.jar',
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # WSO2ESB startup script
    file { '/opt/wso2/wso2esb01/bin/wso2server.sh':
        mode    => 755,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/bin/wso2server.sh.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # Template for the master datasource configuration
    file { '/opt/wso2/wso2esb01/repository/conf/datasources/master-datasources.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/datasources/master-datasources.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # Template for conf/user-mgt.xml
    file { '/opt/wso2/wso2esb01/repository/conf/user-mgt.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/user-mgt.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # Template for conf/carbon.xml
    file { '/opt/wso2/wso2esb01/repository/conf/carbon.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/carbon.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # Template for conf/registry.xml
    file { '/opt/wso2/wso2esb01/repository/conf/registry.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/registry.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } -> 

    # Template for conf/axis2/axis2.xml
    # TODO: Clustering should be configurable and enabled/disabled in this file
    file { '/opt/wso2/wso2esb01/repository/conf/axis2/axis2.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/axis2/axis2.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    } ->

    # Template for conf/tomcat/catalina-server.xml'
    file { '/opt/wso2/wso2esb01/repository/conf/tomcat/catalina-server.xml':
        mode    => 644,
        owner   => "root",
        group   => "root",
        content => template('mw_install/wso2esb01/repository/conf/tomcat/catalina-server.xml.erb'),
        #require => File["/opt/wso2/wso2esb01"],
    }

}
