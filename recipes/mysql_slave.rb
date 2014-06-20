#
# Cookbook Name:: tomstack
# Recipe:: mysql_slave
#

include_recipe 'tomstack::mysql_base'

include_recipe 'mysql-multi::mysql_slave'
