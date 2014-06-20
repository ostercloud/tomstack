# Encoding: utf-8
#
# Cookbook Name:: tomstack
# Recipe:: default
#
# Copyright 2014, Rackspace Hosting
#
case node['platform']
when 'debian', 'ubuntu'
  node.set['apt']['compile_time_update'] = true
  include_recipe 'apt'
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  include_recipe 'yum'
end

node.set['build-essential']['compile_time'] = true
include_recipe 'build-essential'

chef_gem 'chef-metal' do
  version '0.11.2'
  action 'install'
end

chef_gem 'chef-metal-fog' do
  version '0.5.3'
  action 'install'
end

require 'chef_metal'
require 'chef_metal_fog'
require 'cheffish'
require 'fog'

rackspace = Chef::DataBagItem.load('secrets', 'raxcloud')
username = rackspace['username']
apikey = rackspace['apikey']

with_driver 'fog:Rackspace:https://identity.api.rackspacecloud.com/v2.0',
            compute_options: {
              rackspace_api_key: apikey,
              rackspace_username: username,
              rackspace_region: node['tomstack']['provisioner']['region']
            }

fog_key_pair 'metal-key'

with_machine_options ssh_username: 'root',
                     bootstrap_options: {
                       key_name: 'metal-key',
                       flavor_id: 'performance1-2', # 2GB Performance Cloud
                       image_id: 'ffa476b1-9b14-46bd-99a8-862d1d94eb7a' # Ubuntu 12.04
                     }

with_chef_server Chef::Config[:chef_server_url],
                 client_name: Chef::Config[:node_name],
                 signing_key_filename: Chef::Config[:client_key]

machine 'database' do
  recipe 'apt'
  recipe 'tomstack::mysql_standalone'
  notifies 'converge', 'machine[tomcat]', 'immediately'
end

machine 'tomcat' do
  recipe 'apt'
  recipe 'tomstack::tomcat'
  action 'nothing'
  notifies 'converge', 'machine[web]', 'immediately'
end

machine 'web' do
  recipe 'apt'
  recipe 'tomstack::apache'
  action 'nothing'
end
