#
# Cookbook Name:: tomstack
# Recipe:: mysql_base
#
# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')

include_recipe 'chef-sugar'
include_recipe 'database::mysql'
include_recipe 'platformstack::iptables'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'mysql::server'

include_recipe 'mysql-multi::mysql_base'

# allow traffic to mysql port for local addresses only
add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{node['mysql']['port']} -j ACCEPT", 9999, 'Open port for mysql')

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

# add holland user (if holland is enabled)
if node.deep_fetch('holland', 'enabled')
  mysql_database_user 'holland' do
    connection connection_info
    password ['holland']['password']
    host 'localhost'
    privileges [:usage, :select, :'lock tables', :'show view', :reload, :super, :'replication client']
    retries 2
    retry_delay 2
    action [:create, :grant]
  end
end

node.set_unless['tomstack']['cloud_monitoring']['agent_mysql']['password'] = secure_password

mysql_database_user node['tomstack']['cloud_monitoring']['agent_mysql']['user'] do
  connection connection_info
  password node['tomstack']['cloud_monitoring']['agent_mysql']['password']
  action 'create'
end

if node['platformstack']['cloud_monitoring']['enabled'] == true
  template 'mysql-monitor' do
    cookbook 'tomstack'
    source 'monitoring-agent-mysql.yaml.erb'
    path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
    owner 'root'
    group 'root'
    mode '00600'
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
