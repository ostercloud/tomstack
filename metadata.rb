name 'tomstack'
maintainer 'Rackspace US, Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides a full Tomcat stack'

version '0.4.7'

depends 'apt'
depends 'mysql'
depends 'database'
depends 'chef-sugar'
depends 'elasticsearch'
depends 'apache2'
depends 'tomcat', '= 0.15.12'
depends 'memcached'
depends 'openssl'
depends 'redisio'
depends 'varnish'
depends 'rackspace_gluster'
depends 'platformstack'
depends 'mongodb'
depends 'build-essential'
depends 'yum'
depends 'mysql-multi'