#
# Cookbook Name:: 123456-testcustomer-app
# Recipe:: web
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

# For building web nodes.
site1 = 'example.com'
site2 = 'testing.com'

node.default['apache']['sites'][site1]['port'] = 80
node.default['apache']['sites'][site1]['cookbook'] = '123456-testcustomer-app'
node.default['apache']['sites'][site1]['template'] = "apache/sites/#{site1}.erb"
node.default['apache']['sites'][site1]['server_name'] = site1
node.default['apache']['sites'][site1]['server_alias'] = "test.#{site1} www.#{site1}"
node.default['apache']['sites'][site1]['docroot'] = "/var/www/#{site1}"
node.default['apache']['sites'][site1]['tomcathost'] = node['tomcat']['host']
node.default['apache']['sites'][site1]['tomcatport'] = node['tomcat']['port']
node.default['apache']['sites'][site1]['errorlog'] = "#{node['apache']['log_dir']}/#{site1}-error.log"
node.default['apache']['sites'][site1]['customlog'] = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
node.default['apache']['sites'][site1]['loglevel'] = 'warn'

node.default['apache']['sites'][site2]['port'] = 80
node.default['apache']['sites'][site2]['cookbook'] = '123456-testcustomer-app'
node.default['apache']['sites'][site2]['template'] = "apache/sites/#{site2}.erb"
node.default['apache']['sites'][site2]['server_name'] = site2
node.default['apache']['sites'][site2]['server_alias'] = "test.#{site2} www.#{site2}"
node.default['apache']['sites'][site2]['docroot'] = "/var/www/#{site2}"
node.default['apache']['sites'][site2]['tomcathost'] = node['tomcat']['host']
node.default['apache']['sites'][site2]['tomcatport'] = node['tomcat']['port']
node.default['apache']['sites'][site2]['errorlog'] = "#{node['apache']['log_dir']}/#{site2}-error.log"
node.default['apache']['sites'][site2]['customlog'] = "#{node['apache']['log_dir']}/#{site2}-access.log combined"
node.default['apache']['sites'][site2]['loglevel'] = 'warn'

# Allow port 80 traffic
add_iptables_rule('INPUT', '-m tcp -p tcp --dport 80 -j ACCEPT', 50, 'Allow http')

include_recipe 'tomstack::apache'
