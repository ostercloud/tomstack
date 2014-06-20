#
# Cookbook Name:: 123456-testcustomer-app
# Recipe:: app
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# For building app nodes.
app2 = 'APP2'

node.default['tomcat']['apps'][app2]['warfile']['url'] = 'http://1518c556ba154ede3719-c95ab40bfe852544a8b5444ad1e4a375.r17.cf5.rackcdn.com/javaTestApp-JDK6-v.0.2.war'
node.default['tomcat']['apps'][app2]['warfile']['checksum'] = '6ffb50e465386ebf958680120d5819d6135b716a23ef95838b0611ec17095a7d'

# Allow web nodes to the tomcat port
node['123456-testcustomer']['web_nodes'].each do | web_node |
  add_iptables_rule('INPUT', "-m tcp -p tcp -i eth1 -s #{web_node}/32 --dport #{node['tomcat']['port']} -j ACCEPT", 50, 'Allow web to tomcat')
end

include_recipe 'tomstack::tomcat'
