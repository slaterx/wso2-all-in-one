define mw_install::filecopy ($file, $origin, $destination, $user, $group) {
    $file_abs_orig = "${origin}/${file}"
    $file_abs_dest = "${destination}"

    # copy file $file from $origon to $destination
    exec { "$file_abs_dest":
        command => "/bin/cp -r -f ${file_abs_orig} ${destination}/",
        creates => $file_abs_dest,
        notify  => Exec["set_ownership_${file_abs_dest}"],
    }

    # set ownership for destination
    exec { "set_ownership_${file_abs_dest}":
        command     => "/bin/chown -R ${user}:${group} $file_abs_dest",
        notify      => Exec["set_permissions_${file_abs_dest}"],
        refreshonly => true,
    }

    # remove eventual write permissions for "others"
    exec { "set_permissions_${file_abs_dest}":
        command     => "/bin/chmod -R o-w $file_abs_dest",
        refreshonly => true,
    }

} 