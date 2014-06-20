# See the community elasticsearch cookbook for examples
#
# http://github.com/elasticsearch/cookbook-elasticsearch/tree/master/attributes
#

normal[:elasticsearch]['discovery.zen.ping.multicast.enabled'] = 'false'
normal[:elasticsearch]['bootstrap.mlockall'] = 'true'
normal[:elasticsearch]['network.host'] = '_local_'
