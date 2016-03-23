define mw_install::unzip ($zip_path, $zip_filename, $install_dir, $store_dir, $user, $group) {
    $zip_full_path = "${zip_path}/${zip_filename}"
    $zip_foldername = "${name}"
    $destination = "${install_dir}/${zip_foldername}"
    $zip_file_abs_path = "${store_dir}/${zip_filename}"
    $zip_time = fqdn_rand(60)

    # extract downloaded zip file into $install_dir
    exec { "extract_${zip_full_path}":
        cwd     => $install_dir,
        command => "/usr/bin/unzip -oq ${zip_full_path}",
        creates => "${destination}",
        notify  => Exec["set_ownership_${zip_filename}"],
    }

    # set ownership for destination
    exec { "set_ownership_${zip_filename}":
        cwd         => $destination,
        command     => "/bin/chown -R ${user}:${group} .",
        notify      => Exec["set_permissions_${zip_filename}"],
        refreshonly => true,
    }

    # remove eventual write permissions for "others"
    exec { "set_permissions_${zip_filename}":
        cwd          => $destination,
        command      => "/bin/chmod -R o-w .",
        refreshonly  => true,
    }

} 