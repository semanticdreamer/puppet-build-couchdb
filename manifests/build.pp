class build-couchdb::build {

   Exec {
       unless => '/usr/bin/test -d ${build-couchdb::install_dir}/build-couchdb',
   }

   notice("install packages git-core make gcc zlib1g-dev libssl-dev rake")
   package {
       ['git-core', 'make', 'gcc', 'zlib1g-dev', 'libssl-dev', 'rake']:
       ensure => 'installed'
   }

   notice "\n\nNext step - build CouchDB from source.\n\n**** This process may take some time, so please be patient and relax...! ****\n\nIn case you're curious what's going on:\n\n1) fire up 2nd terminal and have a look at the working directory '${build-couchdb::install_dir}/build-couchdb',\n\n2) 'tail -f ${build-couchdb::install_dir}/build-couchdb/rake.log' to watch rake building couchdb...\n\n"
   exec { "build couchdb":
       command => "git clone git://github.com/iriscouch/build-couchdb && cd build-couchdb/ && git submodule init && git submodule update && sudo rake && sudo chown -R ${build-couchdb::build_user}:${build-couchdb::build_user} ${build-couchdb::install_dir}/build-couchdb",
       path    => [ "/usr/local/bin/", "/usr/local/sbin/", "/bin/", "/usr/bin/", "/usr/sbin/", "/usr/local/rvm/gems/ruby-1.9.2-p290/bin/" ],
       cwd     => $build-couchdb::install_dir,
       creates => "${build-couchdb::install_dir}/build-couchdb/build/bin/couchdb",
       require => Package['git-core', 'make', 'gcc', 'zlib1g-dev', 'libssl-dev', 'rake'],
       user    => "${build-couchdb::build_user}",
       timeout => "0"
   }

   exec { "set bind_address":
      command  => "sed -i 's/;bind_address = 127.0.0.1/bind_address = ${build-couchdb::bind_address}/' ${build-couchdb::install_dir}/build-couchdb/build/etc/couchdb/local.ini",
      path     => [ "/bin/" ],
      onlyif => "/bin/grep -qFx ';bind_address = 127.0.0.1' '${build-couchdb::install_dir}/build-couchdb/build/etc/couchdb/local.ini'",
      subscribe => Exec["build couchdb"]
   }

   exec { "set COUCHDB_USER":
       command  => "sed -i 's/(^COUCHDB_USER=.*)/COUCHDB_USER=${build-couchdb::build_user}/' ${build-couchdb::install_dir}/build-couchdb/build/etc/default/couchdb",
       path     => [ "/bin/" ],
       subscribe => Exec["build couchdb"]
   }

}