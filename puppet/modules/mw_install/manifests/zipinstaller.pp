define mw_install::zipinstaller ($zip_url, $zip_filename, $install_dir, $store_dir, $user, $group) {
    $zip_full_url = "${zip_url}/${zip_filename}"
    $zip_foldername = "${name}"
    $destination = "${install_dir}/${zip_foldername}"
    $zip_file_abs_path = "${store_dir}/${zip_filename}"

    # download zip file to $store_dir
    exec { "$zip_file_abs_path":
        cwd     => $store_dir,
        command => "/usr/bin/wget -q ${zip_full_url}",
        creates => $zip_file_abs_path,
        notify  => Exec["extract_${zip_file_abs_path}"],
        require => File["${install_dir}", "${store_dir}"],
    }

    # extract downloaded zip file into $install_dir
    exec { "extract_${zip_file_abs_path}":
        cwd     => $install_dir,
        command => "/usr/bin/unzip -q ${zip_file_abs_path}",
        creates => "${destination}",
        notify  => Exec["set_ownership_${destination}"],
    }

    # set ownership for destination
    exec { "set_ownership_${destination}":
        cwd         => $destination,
        command     => "/bin/chown -R ${user}:${group} .",
        notify      => Exec["set_permissions_${destination}"],
        refreshonly => true,
    }

    # remove eventual write permissions for "others"
    exec { "set_permissions_${destination}":
        cwd          => $destination,
        command      => "/bin/chmod -R o-w .",
        refreshonly  => true,
    }

} 