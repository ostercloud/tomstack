#
# Cookbook Name:: tomstack
# Recipe:: mysql_holland
#
#

# set repository
case node['platform']
when 'ubuntu'
  include_recipe 'apt'
  apt_repository 'Holland' do
    uri "http://download.opensuse.org/repositories/home:/holland-backup/x#{node['lsb']['id']}_#{node['lsb']['release']}/"
    key "http://download.opensuse.org/repositories/home:/holland-backup/x#{node['lsb']['id']}_#{node['lsb']['release']}/Release.key"
    components ['./']
    action :add
  end
when 'centos'
  include_recipe 'yum'
  yum_repository 'Holland' do
    description 'Holland backup repo'
    baseurl 'http://download.opensuse.org/repositories/home:/holland-backup/CentOS_CentOS-6/'
    gpgkey 'http://download.opensuse.org/repositories/home:/holland-backup/CentOS_CentOS-6/repodata/repomd.xml.key'
    action :create
  end
end

# install needed packages
%w(holland holland-mysqldump).each do |pkg|
  package pkg do
    action :install
  end
end

# determine if server is slave or standalone and drop specific backupset file
if node.run_context.loaded_recipe?('tomstack::mysql_slave')
  template '/etc/holland/backupsets/default.conf' do
    source 'mysql/backup_sets.slave.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      backup_user: 'holland',
      backup_password: node['holland']['password']
    )
  end
else
  template '/etc/holland/backupsets/default.conf' do
    source 'mysql/backup_sets.standalone.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      backup_user: 'holland',
      backup_password: node['holland']['password']
    )
  end
end

# set cronjob
cron 'backup' do
  hour node['holland']['cron']['hour']
  minute node['holland']['cron']['minute']
  day node['holland']['cron']['day']
  command '/usr/sbin/holland bk'
  action :create
end
