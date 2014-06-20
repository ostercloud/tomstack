include_attribute 'tomstack::tomcat'

site1 = 'example.com'

node.default['apache']['sites'][site1]['port']         = 80
node.default['apache']['sites'][site1]['cookbook']     = 'tomstack'
node.default['apache']['sites'][site1]['template']     = "apache2/sites/#{site1}.erb"
node.default['apache']['sites'][site1]['server_name']  = site1
node.default['apache']['sites'][site1]['server_alias'] = "test.#{site1} www.#{site1}"
node.default['apache']['sites'][site1]['docroot']      = "/var/www/#{site1}"
node.default['apache']['sites'][site1]['tomcathost']   = node['tomcat']['host']
node.default['apache']['sites'][site1]['tomcatport']   = node['tomcat']['port']
node.default['apache']['sites'][site1]['errorlog']     = "#{node['apache']['log_dir']}/#{site1}-error.log"
node.default['apache']['sites'][site1]['customlog']    = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
node.default['apache']['sites'][site1]['loglevel']     = 'warn'
