define mw_install::tgzinstaller ($tgz_url, $tgz_filename, $install_dir, $store_dir, $user, $group) {
    $tgz_full_url = "${tgz_url}/${tgz_filename}"
    $tgz_foldername = "${name}"
    $destination = "${install_dir}/${tgz_foldername}"
    $tgz_file_abs_path = "${store_dir}/${tgz_filename}"

    # extract downloaded tgz file into $install_dir
    exec { "extract_${tgz_file_abs_path}":
        cwd     => $install_dir,
        command => "/bin/tar xfz ${tgz_file_abs_path}",
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