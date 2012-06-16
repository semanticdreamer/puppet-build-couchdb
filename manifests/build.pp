class build-couchdb::build {

   Exec {
       unless => '/usr/bin/test -d ${build-couchdb::install_dir}/build-couchdb',
   }

   if ! defined(Package['git-core'])   { package { 'git-core':   ensure => installed } }
   if ! defined(Package['make'])       { package { 'make':       ensure => installed } }
   if ! defined(Package['gcc'])        { package { 'gcc':        ensure => installed } }
   if ! defined(Package['zlib1g-dev']) { package { 'zlib1g-dev': ensure => installed } }
   if ! defined(Package['libssl-dev']) { package { 'libssl-dev': ensure => installed } }
   if ! defined(Package['rake'])       { package { 'rake':       ensure => installed } }

   exec { "build couchdb":
       command => "git clone git://github.com/iriscouch/build-couchdb && cd build-couchdb/ && git submodule init && git submodule update && sudo rake && sudo chown -R ${build-couchdb::build_user}:${build-couchdb::build_user} ${build-couchdb::install_dir}/build-couchdb",
       path    => [ "/usr/local/bin/", "/usr/local/sbin/", "/bin/", "/usr/bin/", "/usr/sbin/" ],
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
       command  => "sed -i 's/COUCHDB_USER=couchdb/COUCHDB_USER=${build-couchdb::build_user}/' ${build-couchdb::install_dir}/build-couchdb/build/etc/default/couchdb",
       path     => [ "/bin/" ],
       onlyif => "/bin/grep -qFx 'COUCHDB_USER=couchdb' ${build-couchdb::install_dir}/build-couchdb/build/etc/default/couchdb",
       subscribe => Exec["build couchdb"]
   }

}