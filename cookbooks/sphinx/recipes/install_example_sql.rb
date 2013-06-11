rightscale_marker :begin

case node[:platform]
when "redhat","centos","scientific"
  package "mysql50-server" do
    action :install
  end

  package "mysql50" do
    action :install
  end
  
  service "mysqld" do
    action :start
  end
  
when "ubuntu", "debian"
  package "mysql-server" do
    action :install
  end

  service "mysql" do
    action :start
  end
  
  directory "/var/run/sphinx" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
end

cookbook_file "/tmp/example.sql" do
  source "example.sql"
  owner "root"
  group "root"
  mode "0644"
end

execute "mysql_import" do
  command "mysql -u root < /tmp/example.sql"
  action :run
end

execute "#{node[:sphinx][:indexer]}" do
  command "#{node[:sphinx][:indexer]} --all"
  action :run
end

service "#{node[:sphinx][:service]}" do
  action :start
end

rightscale_marker :end
