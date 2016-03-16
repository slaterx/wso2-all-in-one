# '/home/vagrant/_downloads' symlink created to load and share external files
file { "CREATING_SYMLINK_TO_DOWNLOADS":
  path   => '/home/vagrant/_downloads',
  ensure => 'link',
  target => '/vagrant/_downloads',
}

include base_install