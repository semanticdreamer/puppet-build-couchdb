class build-couchdb::daemon {

    case $build-couchdb::daemon {
        true: {
            exec { "install daemon":
               command  => "ln -s /home/vagrant/build-couchdb/build/etc/init.d/couchdb /etc/init.d/couchdb",
               path     => [ "/bin/" ],
               creates  => "/etc/init.d/couchdb",
               subscribe => Exec["build couchdb"]
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