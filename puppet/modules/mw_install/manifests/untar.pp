define mw_install::untar ($tar_path, $tar_filename, $install_dir, $store_dir, $user, $group) {
    $tar_full_path = "${tar_path}/${tar_filename}"
    $tar_foldername = "${name}"
    $destination = "${install_dir}/${zip_foldername}"
    $tar_file_abs_path = "${store_dir}/${zip_filename}"
    $tar_time = "${uptime_seconds}"

    # extract downloaded zip file into $install_dir
    exec { "extract_${tar_full_path}":
        cwd     => $install_dir,
        command => "/bin/tar xfz ${tar_full_path}",
        creates => "${destination}",
        notify  => Exec["set_ownership_${tar_filename}"],
    }

    # set ownership for destination
    exec { "set_ownership_${tar_filename}":
        cwd         => $destination,
        command     => "/bin/chown -R ${user}:${group} .",
        notify      => Exec["set_permissions_${tar_filename}"],
        refreshonly => true,
    }

    # remove eventual write permissions for "others"
    exec { "set_permissions_${tar_filename}":
        cwd          => $destination,
        command      => "/bin/chmod -R o-w .",
        refreshonly  => true,
    }

} 