#
# Cookbook Name:: 123456-testcustomer-app
# Recipe:: default
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

# Customer environment node info
# Web node info
node.default['123456-testcustomer']['web_nodes'] = ['127.0.0.1']

# App node info
node.default['123456-testcustomer']['app_nodes'] = ['127.0.0.1']

# Cache node info
node.default['123456-testcustomer']['cache_nodes'] = ['127.0.0.1']

# NoSQL node info
node.default['123456-testcustomer']['nosql_nodes'] = ['127.0.0.1']

# DB master node info
node.default['123456-testcustomer']['db_master_node'] = '127.0.0.1'

# DB slave node info
node.default['123456-testcustomer']['db_slave_nodes'] = ['127.0.0.1']

# Customer/app specific settings app/env wide.
node.default['apt']['compile_time_update'] = true

node.default['tz'] = 'America/Chicago'
include_recipe 'timezone-ii'

# Port and host info for tomcat
node.default['tomcat']['host'] = '127.0.0.1'
node.default['tomcat']['port'] = 8080

# Turn off backups and monitoring for testing
node.default['rackspace']['cloudbackup']['enabled'] = false
node.default['platformstack']['cloud_monitoring']['enabled'] = false

# Include the rackops_rolebook for support
# Currently broken - unable to hit http://whoami.rackops.org/api from pub cloud servers
# include_recipe 'rackops_rolebook::default'
# Everything in rackops_rolebook::default except public_info and support packages while we fix the api
include_recipe 'rackops_rolebook::motd'
include_recipe 'rackops_rolebook::rack_user'
include_recipe 'rackops_rolebook::acl'
include_recipe 'platformstack::default'
