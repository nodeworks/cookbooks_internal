#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

seed_ips   = Array.new
dirs       = Array.new
rack       = nil
datacenter = nil

# Find datacenter and rack that this host belongs to
if node[:cloud][:provider] == "ec2"
  datacenter = "ec2-#{node[:ec2][:placement][:availability_zone].chop}"
  rack       = "#{node[:ec2][:placement][:availability_zone]}"
elsif node[:cloud][:provider] == "google"
  datacenter = "google-#{node[:google][:zone].split('/').last.chop.chop}"
  rack       =  "#{node[:google][:zone].split('/').last}"
end

# Collect directories to create
dirs.push(node[:cassandra][:commitlog_directory])
dirs.push(node[:cassandra][:saved_caches_directory])
dirs += node[:cassandra][:data_file_directories]

# Find hosts that are going to be Cassandra seeds
seed_hosts = rightscale_server_collection "seed_hosts" do
  tags ["cassandra:seed_host=true"]
  mandatory_tags ["server:public_ip_0"]
  empty_ok false
  action :nothing
end
seed_hosts.run_action(:load)

if node["server_collection"]["seed_hosts"]
  Chef::Log.info "Server collection found ..."
  node["server_collection"]["seed_hosts"].to_hash.values.each do |tag|
    seed_ips.push(RightScale::Utils::Helper.get_tag_value("server:public_ip_0", tag))
  end
end

# Create Cassandra directories
dirs.each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
  end
end

# Install main Cassandra config file
template "/etc/cassandra/conf/cassandra.yaml" do
  source "#{node[:cassandra][:require_inter_node_encryption]}-cassandra.yaml.erb"
  owner "cassandra"
  group "cassandra"
  mode "0644"
  variables({
    :cluster_name           => node[:cassandra][:cluster_name],
    :snitch                 => node[:cassandra][:snitch],
    :commitlog_directory    => node[:cassandra][:commitlog_directory],
    :data_file_directories  => node[:cassandra][:data_file_directories],
    :saved_caches_directory => node[:cassandra][:saved_caches_directory],
    :listen_address         => node[:cloud][:private_ips][0],
    :broadcast_address      => node[:cloud][:public_ips][0],
    :seeds                  => seed_ips
  })
end

# Only install rackdc.properties if using GossipingPropertyFileSnitch
if node[:cassandra][:snitch] == "GossipingPropertyFileSnitch"
  template "/etc/cassandra/conf/cassandra-rackdc.properties" do
    source "cassandra-rackdc.properties.erb"
    owner "cassandra"
    group "cassandra"
    mode "0644"
    variables({
      :datacenter => datacenter,
      :rack       => rack
    })
  end
end

if node[:cassandra][:require_inter_node_encryption] == "true"
  bash "install_cassandra_certs" do
    flags "-ex"
    code <<-EOM
      rs_run_rightscript --name "Install Cassandra Certs"
    EOM
  end
end

service "cassandra" do
  action [:enable, :start]
end

rightscale_marker :end
