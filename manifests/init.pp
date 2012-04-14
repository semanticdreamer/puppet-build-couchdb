class build-couchdb($install_dir = '/home/vagrant',
                    $build_user = 'vagrant',
                    $bind_address = '0.0.0.0',
                    $end_admin_party = true,
                    $admin_user = 'admin',
                    $admin_pwd = 'admin',
                    $daemon = true) {

   include couchdb::build,
           couchdb::daemon,
           couchdb::adminparty

}