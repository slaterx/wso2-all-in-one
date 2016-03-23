class mw_install {

    if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
            allow_virtual => $allow_virtual_packages,
        }
    }
 
# Present packages
    package { "bind-utils": ensure => "installed" }
    package { "cryptsetup-luks": ensure => "installed" }
    package { "dstat": ensure => "installed" }
    package { "ed": ensure => "installed" }
    package { "lsof": ensure => "installed" }
    package { "mlocate": ensure => "installed" }
    package { "mtr": ensure => "installed" }
    package { "net-tools": ensure => "installed" }
    package { "policycoreutils-python": ensure => "installed" }
    package { "rsync": ensure => "installed" }
    package { "screen": ensure => "installed" }
    package { "sos": ensure => "installed" }
    package { "strace": ensure => "installed" }
    package { "sysstat": ensure => "installed" }
    package { "tcp_wrappers": ensure => "installed" }
    package { "tcpdump": ensure => "installed" }
    package { "tcsh": ensure => "installed" }
    package { "telnet": ensure => "installed" }
    package { "traceroute": ensure => "installed" }
    package { "unzip": ensure => "installed" }
    package { "vim-enhanced": ensure => "installed" }
    package { "wget": ensure => "installed" }
    package { "yum": ensure => "installed" }
    package { "yum-plugin-changelog": ensure => "installed" }
    package { "yum-plugin-versionlock": ensure => "installed" }
    package { "zip": ensure => "installed" }

# Removed packages
    package { "alsa-firmware": ensure => "absent" }
    package { "alsa-lib": ensure => "absent" }
    package { "alsa-utils": ensure => "absent" }
    package { "alsa-tools-firmware": ensure => "absent" }
    package { "libsndfile": ensure => "absent" }
    package { "iprutils": ensure => "absent" }
    package { "ivtv-firmware": ensure => "absent" }
    package { "iwl100-firmware": ensure => "absent" }
    package { "iwl1000-firmware": ensure => "absent" }
    package { "iwl105-firmware": ensure => "absent" }
    package { "iwl135-firmware": ensure => "absent" }
    package { "iwl2000-firmware": ensure => "absent" }
    package { "iwl2030-firmware": ensure => "absent" }
    package { "iwl3160-firmware": ensure => "absent" }
    package { "iwl3945-firmware": ensure => "absent" }
    package { "iwl4965-firmware": ensure => "absent" }
    package { "iwl5000-firmware": ensure => "absent" }
    package { "iwl5150-firmware": ensure => "absent" }
    package { "iwl6000-firmware": ensure => "absent" }
    package { "iwl6000g2a-firmware": ensure => "absent" }
    package { "iwl6000g2b-firmware": ensure => "absent" }
    package { "iwl6050-firmware": ensure => "absent" }
    package { "iwl7260-firmware": ensure => "absent" }
    package { "java-1.8.0-openjdk-headless": ensure => "absent" }
    package { "java-1.8.0-openjdk": ensure => "absent" }
    package { "java-1.7.0-openjdk": ensure => "absent" }
    package { "java-1.7.0-openjdk-devel": ensure => "absent" }
    package { "bind": ensure => "absent" }
    package { "dhcp": ensure => "absent" }
    package { "dovecot": ensure => "absent" }
    package { "httpd": ensure => "absent" }
    package { "mcstrans": ensure => "absent" }
    package { "openldap-clients": ensure => "absent" }
    package { "openldap-servers": ensure => "absent" }
    package { "pulseaudio-libs": ensure => "absent" }
    package { "rsh": ensure => "absent" }
    package { "rsh-server": ensure => "absent" }
    package { "samba": ensure => "absent" }
    package { "setroubleshoot": ensure => "absent" }
    package { "squid": ensure => "absent" }
    package { "talk": ensure => "absent" }
    package { "talk-server": ensure => "absent" }
    package { "telnet-server": ensure => "absent" }
    package { "tftp": ensure => "absent" }
    package { "tftp-server": ensure => "absent" }
    package { "vsftpd": ensure => "absent" }
    package { "xorg-x11-server-common": ensure => "absent" }
    package { "ypbind": ensure => "absent" }
    package { "ypserv": ensure => "absent" }

# Disabled services
    service { 'NetworkManager' : ensure => stopped, enable => false, }
    service { 'avahi-daemon'   : ensure => stopped, enable => false, }
    service { 'chargen-dgram'  : ensure => stopped, enable => false, }
    service { 'chargen-stream' : ensure => stopped, enable => false, }
    service { 'cups'           : ensure => stopped, enable => false, }
    service { 'daytime-dgram'  : ensure => stopped, enable => false, }
    service { 'daytime-stream' : ensure => stopped, enable => false, }
    service { 'echo-dgram'     : ensure => stopped, enable => false, }
    service { 'echo-stream'    : ensure => stopped, enable => false, }
    service { 'nfslock'        : ensure => stopped, enable => false, }
    service { 'rpcbind'        : ensure => stopped, enable => false, }
    service { 'rpcgssd'        : ensure => stopped, enable => false, }
    service { 'rpcidmapd'      : ensure => stopped, enable => false, }
    service { 'rpcsvcgssd'     : ensure => stopped, enable => false, }
    service { 'tcpmux-server'  : ensure => stopped, enable => false, }

    # Enable puppet in the target host
    file { 'puppet_agent_config':
        name => '/etc/puppet/puppet.conf',
        owner => root,
        group => root,
        mode => 640,
        source => "puppet:///modules/mw_install/puppet.conf",
    }
    service { "puppet":
        ensure  => "running",
        enable  => "true",
        subscribe => File[puppet_agent_config],
    }

    # Enable SSH
    package { 'openssh-server': ensure => present, }
    service { "sshd":
        ensure  => "running",
        enable  => "true",
        require => Package["openssh-server"],
    }
    # add a notify to the file resource
    file { "sshd_config":
        name    => '/etc/ssh/sshd_config',
        notify  => Service["sshd"],
        mode    => 600,
        owner   => "root",
        group   => "root",
        source => "puppet:///modules/mw_install/sshd_config",
        require => Package["openssh-server"],
    }

    # Configure Network Time Protocol (NTP)
    package { 'ntp': ensure => installed, }
    service { "ntpd":
        ensure  => "running",
        enable  => "true",
        require => Package["ntp"],
    }
    file { "ntp_config":
        name    => '/etc/ntp.conf',
        notify  => Service["ntpd"],
        mode    => 600,
        owner   => "root",
        group   => "root",
        source => "puppet:///modules/mw_install/ntp.conf",
        require => Package["ntp"],
    }

    # Enable auditd Service
    package { 'audit': ensure => present, }
    service { 'auditd':
        subscribe => File[audit_rules],
        require => Package['audit'],
        ensure => "running",
        enable => "true",
    }

    file { 'audit_rules':
        name => '/etc/audit/rules.d/audit.rules',
        owner => root,
        group => root,
        mode => 640,
        source => "puppet:///modules/mw_install/audit.rules",
        require => Package['audit'],
    }

    file { '/etc/audit/auditd.conf':
        mode => '0640',
        require => Package["audit"],
        notify => Service["auditd"],
    }

    augeas{'Audit-max_log_file':
        context => "/files/etc/audit/auditd.conf",
        changes => "set max_log_file 100",
    }

    # Enable crond Daemon
    package { "cronie-anacron": ensure => "installed", }
    service { 'crond':
        ensure => running,
        enable => true,
    }

    # Restrict at/cron to Authorized Users
    file { '/etc/cron.allow':
        mode => 600,
        content => "root\n",
    }
    file { '/etc/cron.deny':
        ensure => absent,
    }
    file { '/etc/anacrontab' : mode => 600, require => Package['cronie-anacron'], }

    file { '/etc/cron.d'       : ensure => directory, mode => 700, }
    file { '/etc/cron.daily'   : ensure => directory, mode => 700, }
    file { '/etc/cron.hourly'  : ensure => directory, mode => 700, }
    file { '/etc/cron.monthly' : ensure => directory, mode => 700, }
    file { '/etc/cron.weekly'  : ensure => directory, mode => 700, }
    file { '/etc/crontab'      :                      mode => 600, }

    file { '/etc/at.allow': mode => 600, content => "root\n", }
    file { '/etc/at.deny': ensure => absent, }

    # Activate the rsyslog Service
    package { "rsyslog": ensure => "installed" }
    package { "rsyslog-gnutls": ensure => "installed" }
    service { 'rsyslog':
        ensure => running,
        enable => true,
        require => Package["rsyslog"],
    }

    # Configure logrotate
        package { 'logrotate':
        ensure => installed,
    }
    file { '/etc/logrotate.d/syslog':
        owner => "root",
        group => "root",
        mode => 644,
        source => "puppet:///modules/mw_install/syslog.logrotate",
    }
    file { '/var/log/boot.log':
        mode => 644,
        owner => "root",
        group => "root",
    }
    file { '/var/log/cron':
        owner => "root",
        group => "root",
        mode => 600,
    }

    # Enable local-only email server
    package { 'postfix': ensure => installed, }
    service { "postfix":
        ensure  => "running",
        enable  => "true",
        require => Package["postfix"],
    }
    
    augeas{ 'Configure-MTA':
        context => "/files/etc/postfix/main.cf",
        changes => "set inet_interfaces localhost",
    }
    augeas{ 'Limit-INET':
        context => "/files/etc/postfix/main.cf",
        changes => "set inet_protocols ipv4",
    }

    file { '/etc/group'   : mode => 644, }
    file { '/etc/gshadow' : mode => 000, }

    file { '/etc/passwd':
        owner => "root",
        group => "root",
        mode => 644,
    }
    user { 'root' : gid => 0, }

    file { '/etc/shadow':
        owner => "root",
        group => "root",
        mode => 000,
    }

    # Lock Inactive User Accounts
    augeas{ 'Lock-Inactive-Accounts':
        context => "/files/etc/default/useradd",
        changes => "set INACTIVE 35",
    }

    # Set Banner for Standard Login Services
    file { '/etc/issue':
        owner => "root",
        group => "root",
        mode => 644,
        source => "puppet:///modules/mw_install/etc_issue",
    }
    file { '/etc/issue.net' : ensure => link, target => "/etc/issue", }
    file { '/etc/motd'      : ensure => link, target => "/etc/issue", }

    # Set Password Rules
    augeas{ 'Set-Password-Change-Minimum':
        context => "/files/etc/login.defs",
        changes => "set PASS_MIN_DAYS 7",
    }
    augeas{ 'Set-Password-Expiring-Warning':
        context => "/files/etc/login.defs",
        changes => "set PASS_WARN_AGE 7",
    }
    augeas{ 'Set-Password-Expiration':
        context => "/files/etc/login.defs",
        changes => "set PASS_MAX_DAYS 90",
    }
    augeas{ 'Upgrade-Password-Hashing':
        context => "/files/etc/sysconfig/authconfig",
        changes => [ "set USESHADOW yes", "set PASSWDALGORITHM sha512", ],
    }

    mount { "/dev/shm":
        ensure => mounted,
        device => "tmpfs",
        fstype => "tmpfs",
        options => "defaults,nodev,nosuid,noexec",
        atboot => true,
        dump => 0, pass => 0,
    }

    # Disable ipv6
    file { '/etc/modprobe.d/ipv6-disable.conf':
        owner => "root",
        group => "root",
        mode => 644,
        source => "puppet:///modules/mw_install/ipv6-disable.conf",
    }
    augeas{ 'Disable-IPv6':
        context => "/files/etc/sysconfig/network",
        changes => [ "set NETWORKING_IPV6 no", "set IPV6INIT no", ],
    }

    augeas{ 'FILE-etc-sysctl-conf':
        incl => "/etc/sysctl.conf",
        lens => "Sysctl.lns",
        changes => [
            "set fs.suid_dumpable                           0",
            "set kernel.randomize_va_space                  2",
            "set net.ipv4.ip_forward                        0",
            "set net.ipv4.conf.all.send_redirects           0",
            "set net.ipv4.conf.default.send_redirects       0",
            "set net.ipv4.conf.all.accept_source_route      0",
            "set net.ipv4.conf.default.accept_source_route  0",
            "set net.ipv4.conf.all.accept_redirects         0",
            "set net.ipv4.conf.default.accept_redirects     0",
            "set net.ipv4.conf.all.secure_redirects         0",
            "set net.ipv4.conf.default.secure_redirects     0",
            "set net.ipv4.conf.all.log_martians             1",
            "set net.ipv4.conf.default.log_martians         1",
            "set net.ipv4.icmp_echo_ignore_broadcasts       1",
            "set net.ipv4.icmp_ignore_bogus_error_responses 1",
            "set net.ipv4.conf.all.rp_filter                1",
            "set net.ipv4.conf.default.rp_filter            1",
            "set net.ipv4.tcp_syncookies                    1",
            "set net.ipv6.conf.all.accept_ra                0",
            "set net.ipv6.conf.default.accept_ra            0",
            "set net.ipv6.conf.all.accept_redirects         0",
            "set net.ipv6.conf.default.accept_redirects     0",
            "set net.ipv6.conf.all.disable_ipv6             1",
            "set net.ipv4.tcp_keepalive_time              600",
            "set net.ipv4.tcp_keepalive_intvl              60",
            "set net.ipv4.tcp_keepalive_probes              3",
            "set net.ipv4.tcp_sack                          0",
        ],
    }

    # Restrict Core Dumps
    augeas{ "/etc/security/limits.conf":
        incl   => "/etc/security/limits.conf",
        lens   => "limits.lns",
        changes=> [ "set domain       '*'",
                    "set domain/type  hard",
                    "set domain/item  core",
                    "set domain/value 0",
        ]
    }

    # Set SELinux
    augeas{ 'Set-the-SELinux-State':
        context => "/files/etc/selinux/config",
        changes => "set SELINUX enforcing",
    }
    augeas{ 'Set-SELinux-Policy':
        context => "/files/etc/selinux/config",
        changes => "set SELINUXTYPE targeted",
    }

    # Add login timeout settings.
    file { "timeout-settings.sh":
        name   => '/etc/profile.d/timeout-settings.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/timeout-settings.sh',
    }

    # Add bash history timestamps.
    file { "history-timestamp.sh":
        name   => '/etc/profile.d/history-timestamp.sh',
        mode   => 644,
        owner  => "root",
        group  => "root",
        source => 'puppet:///modules/mw_install/history-timestamp.sh',
    }

    # Configure PAM
    file { "system-auth-ac":
        name    => '/etc/pam.d/system-auth-ac',
        mode    => 644,
        owner   => "root",
        group   => "root",
        source => 'puppet:///modules/mw_install/system-auth-ac',
    }
    file { "password-auth-ac":
        name    => '/etc/pam.d/password-auth-ac',
        mode    => 644,
        owner   => "root",
        group   => "root",
        source => 'puppet:///modules/mw_install/system-auth-ac',
    }

    # Enable iptables in the target host
    package { 'iptables':
        ensure => installed
    }
    file { 'iptables_config':
        name => '/etc/sysconfig/iptables',
        owner => root,
        group => root,
        mode => 600,
        source => "puppet:///modules/mw_install/iptables",
        require => Package['iptables'],
    }
    service { 'iptables':
        subscribe => File[iptables_config],
        require => Package['iptables'],
        ensure => "running",
        enable => "true",
    }

    # NON-CIS Add Host Details
    host { 'localhost.localdomain':
        ensure => 'present',
        target => '/etc/hosts',
        ip => '127.0.0.1',
        host_aliases => ['localhost'],
    }
    host { "$fqdn":
        ensure => 'present',
        target => '/etc/hosts',
        ip => "$ipaddress",
        host_aliases => "$hostname",
    }

# END
}