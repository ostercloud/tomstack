#
# Cookbook Name:: tomstack
# Recipe:: tomcat
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'
include_recipe 'tomcat'
include_recipe 'chef-sugar'
include_recipe 'platformstack::iptables'

# guard against search() on chef solo
if Chef::Config[:solo]
  mysql = 'localhost'
  bindip = '127.0.0.1'
else
  mysql = search('node', 'recipes:tomstack\:\:mysql_base'\
               " AND chef_environment:#{node.chef_environment}").first
  bindip = best_ip_for(mysql)
end

bindip = best_ip_for(mysql)

# add iptables rule to allow traffic on the port
add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{node['tomcat']['port']} -j ACCEPT", 9999, 'Open port for tomcat')

# Clean up app directories, pull down war files, and restart tomcat if changes are detected.
node['tomcat']['apps'].each do | app_name |
  app_name = app_name[0]
  webapp_dir = node['tomcat']['webapp_dir']
  war_file = node['tomcat']['apps'][app_name]['warfile']

  directory "#{webapp_dir}/#{app_name}" do
    recursive true
    action :nothing
    notifies :restart, 'service[tomcat]' , :immediately
  end

  # Pull down the war file (only if updated/new) and delete ROOT and restart Tomcat
  remote_file "#{webapp_dir}/#{app_name}.war" do
    source war_file['url']
    checksum war_file['checksum']
    action :create
    notifies :delete, "directory[#{webapp_dir}/#{app_name}]", :immediately
  end
end

directory "#{node['tomcat']['webapp_dir']}/ROOT/META-INF" do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode '0755'
  action :create
  recursive true
end

template '/etc/tomcat6/Catalina/localhost/ROOT.xml' do
  source 'tomcat/context.xml.erb'
  variables(
    username: 'root',
    password: node['mysql']['server_root_password'],
    host: bindip
  )
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode '0644'
  notifies :restart, 'service[tomcat]'
  action :create
end
