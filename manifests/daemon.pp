class build-couchdb::daemon {

    case $build-couchdb::daemon {
        true: {
            exec { "install daemon":
               command  => "ln -s ${build-couchdb::install_dir}/build-couchdb/build/etc/init.d/couchdb /etc/init.d/couchdb",
               path     => [ "/bin/" ],
               creates  => "/etc/init.d/couchdb",
               subscribe => Exec["build couchdb"]
            }
            
            file {
                "/etc/init.d/couchdb":
                ensure  => "link",
                target  => "${build-couchdb::install_dir}/build-couchdb/build/etc/init.d/couchdb",
                require => Exec['install daemon']
            }
            
            service {
                'couchdb':
                ensure      => running,
                hasstatus   => true,
                hasrestart  => true,
                enable      => true,
                require     => File['/etc/init.d/couchdb'];
            }
        }
    }

}