Build Cloud Servers
===================
<pre>
nova boot tomcat-web --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
--flavor "performance1-1" --key-name laptop

nova boot tomcat-mysql --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
--flavor "performance1-1" --key-name laptop
</pre>

Create the Roles
================
<pre>
knife role edit tomcat_web

  "run_list": [
    "recipe[platformstack::monitors]",
    "recipe[platformstack::default]",
    "recipe[rackops_rolebook::rack_user]",
    "recipe[tomstack::apache]",
    "recipe[tomstack::tomcat]"
  ],

knife role edit tomcat_mysql

  "run_list": [
    "recipe[platformstack::default]",
    "recipe[rackops_rolebook::rack_user]",
    "recipe[tomstack::mysql_base]"
  ],
</pre>

Set required attributes in Environment
======================================
<pre>
knife environment show stage

override_attributes:
  platformstack:
    cloud_monitoring:
      enabled: false
  rackspace:
    cloud_credentials:
      api_key:  CHANGEME
      username: smbmarquee
    cloudbackup:
      enabled: false
</pre>

Bootstrap the nodes
===================
knife bootstrap -x root -r 'role[tomcat_mysql]' -E stage
knife bootstrap -x root -r 'role[tomcat_web]' -E stage
