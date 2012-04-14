class build-couchdb::adminparty {

    case $build-couchdb::end_admin_party {
        true: {
            exec { "create couchdb admin user '${build-couchdb::admin_user}:${build-couchdb::admin_pwd}'":
               command  => "curl -X PUT http://localhost:5984/_config/admins/${build-couchdb::admin_user} -d '\"${build-couchdb::admin_pwd}\"' > ./admins_${build-couchdb::admin_user}_created",
               path     => [ "/usr/bin/" ],
               cwd      => "${build-couchdb::install_dir}/build-couchdb",
               creates  => "${build-couchdb::install_dir}/build-couchdb/admins_${build-couchdb::admin_user}_created",
               unless   => "/usr/bin/test -f ${build-couchdb::install_dir}/build-couchdb/admins_${build-couchdb::admin_user}_created",
               require  => Service["couchdb"]
            }
        }
    }

}