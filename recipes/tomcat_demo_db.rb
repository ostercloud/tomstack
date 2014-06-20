#
# Cookbook Name:: tomstack
# Recipe:: tomcat_demo_db
#
# Copyright 2014, Rackspace Hosting
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

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database node['tomcat-demo']['db_name'] do
  connection connection_info
  action 'create'
end

app_nodes = search(:node, 'recipes:tomstack\:\:tomcat' << " AND chef_environment:#{node.chef_environment}")
app_nodes.each do |app_node|
  mysql_database_user node['tomcat-demo']['db_user'] do
    connection connection_info
    password node['tomcat-demo']['password']
    host "#{app_node['cloud']['local_ipv4']}"
    database_name node['tomcat-demo']['db_name']
    privileges ['select', 'update', 'insert']
    retries 2
    retry_delay 2
    action ['create', 'grant']
  end
end
