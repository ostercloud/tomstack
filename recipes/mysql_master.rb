#
# Cookbook Name:: tomstack
# Recipe:: mysql_master
#

include_recipe 'tomstack::mysql_base'

include_recipe 'mysql-multi::mysql_master'

if node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled')
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
