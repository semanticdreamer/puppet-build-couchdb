#Puppet Module build-couchdb

[Puppet][puppet] Module to build latest [CouchDB][couchdb] release from source using [build-couchdb][build-couchdb] wrapper to pull in [CouchDB][couchdb] (from official sources) and all of its dependencies.

Intended to be used (shared) with projects using [Puppet][puppet] to provision [Vagrant][vagrant] development environments.

Tested on Vagrant box [debian-6.0.4-squeeze-server][debian-6.0.4-squeeze-server].

##Installation - Add Puppet Module

Either `git clone` this repo to a `build-couchdb` directory under your Puppet `modules/` directory:

    git clone git@github.com:semanticdreamer/puppet-build-couchdb.git build-couchdb

... or add it as a submodule into your project's Puppet `modules/` directory, e.g. `puppet/modules/build-couchdb`:

	git submodule add git@github.com:semanticdreamer/puppet-build-couchdb.git ./puppet/modules/build-couchdb
	git submodule init && git submodule update

##Usage - Build CouchDB

Add the following to your project's site manifest file (e.g. `manifests/site.pp`):

    include build-couchdb

Optional, adjust module configuration to your needs by overwriting default class parameters - also in your project's site manifest file (e.g. `manifests/site.pp`)

    class { "build-couchdb":
        install_dir => '/home/vagrant',
        build_user => 'vagrant',
        bind_address => '0.0.0.0',
        end_admin_party => true,
        admin_user => 'admin',
        admin_pwd => 'admin',
        daemon => true
    }

##Credits

Impossible without [Build CouchDB][build-couchdb] - the most straightforward and reliable procedure to build official [CouchDB][couchdb] releases from source.

Partly inspired by [Puppet CouchDB Module][puppet-module-couchdb].

[puppet]: http://projects.puppetlabs.com/projects/puppet "Puppet"
[vagrant]: http://vagrantup.com/ "Vagrant"
[couchdb]: http://couchdb.apache.org/ "CouchDB"
[build-couchdb]: https://github.com/iriscouch/build-couchdb "Build CouchDB"
[puppet-module-couchdb]: https://github.com/Benjamin-Ds/puppet-module-couchdb "Puppet CouchDB Module"
[debian-6.0.4-squeeze-server]: https://github.com/semanticdreamer/veewee-vagrant-box-definitions "debian-6.0.4-squeeze-server"