default[:solr][:install_dir] = '/usr/share/tomcat6/solr'
default[:solr][:conf_dir] = node[:solr][:install_dir] + '/conf'
default[:solr][:lib_dir] = node[:solr][:install_dir] + '/lib'
default[:solr][:data_dir] = node[:solr][:install_dir] + '/data'
default[:solr][:core_name] = 'collection1'
default[:solr][:replication][:files_to_replicate] = "schema.xml,stopwords.txt,elevate.xml"
default[:solr][:replication][:slave_poll_interval] = "00:00:20"
default[:solr][:storage_type] = 'ephemeral'
case node[:platform]
when "centos"
  default[:tomcat][:app_user] = 'tomcat' unless node[:tomcat][:app_user]
when "ubuntu"
  default[:tomcat][:app_user] = 'tomcat6' unless node[:tomcat][:app_user]
  default[:solr][:install_dir] = '/var/lib/tomcat6/solr'
  default[:solr][:conf_dir] = node[:solr][:install_dir] + '/conf'
  default[:solr][:lib_dir] = node[:solr][:install_dir] + '/lib'
  default[:solr][:data_dir] = node[:solr][:install_dir] + '/data'
end
