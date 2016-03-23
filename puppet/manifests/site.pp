# '/home/vagrant/_downloads' symlink created to load and share external files
file { "CREATING_SYMLINK_TO_DOWNLOADS":
  path   => '/home/vagrant/_downloads',
  ensure => 'link',
  target => '/vagrant/_downloads',
}

include mw_install
include mw_install::wso2::base
include mw_install::wso2::esb01
include mw_install::wso2::esb02 
include mw_install::wso2::greg01
include mw_install::wso2::greg02