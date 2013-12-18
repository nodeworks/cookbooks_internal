#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

# Recommended production settings: http://www.datastax.com/documentation/cassandra/1.2/webhelp/index.html#cassandra/install/installRecommendSettings.html

rightscale_marker :begin

right_link_tag "cassandra:seed_host=#{node[:cassandra][:is_seed_host]}"

remote_file "#{Chef::Config[:file_cache_path]}/cassandra12-1.2.6-1.noarch.rpm" do
  source "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/cassandra12-1.2.6-1.noarch.rpm"
  checksum "6e41d897c052a7d4efbbb6d2be1fb61a79492d058333ab496ef9d678910eb6e6"
end

remote_file "#{Chef::Config[:file_cache_path]}/dsc12-1.2.6-1.noarch.rpm" do
  source "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/dsc12-1.2.6-1.noarch.rpm"
  checksum "38a29503f913daea343b22964608898f3f33c08bb02b6046ab1b9d1d12089db0"
end

remote_file "#{Chef::Config[:file_cache_path]}/jre-7u45-linux-x64.rpm" do
  source "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/jre-7u45-linux-x64.rpm"
  checksum "b3d28c3415cffd965a63cd789d945cf9da827d960525537cc0b10c6c6a98221a"
end

package "jna" do
  action :install
end

package "cassandra12" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/cassandra12-1.2.6-1.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

package "dsc12" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/dsc12-1.2.6-1.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

package "jre" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/jre-7u45-linux-x64.rpm"
  provider Chef::Provider::Package::Rpm
end

bash "update_alternatives_to_oracle_java" do
  flags "-ex"
  code <<-EOM
    alternatives --install /usr/bin/java java /usr/java/jre1.7.0_45/bin/java 20000
  EOM
end

cookbook_file "/etc/sysctl.conf" do
  source "sysctl.conf"
  mode "0644"
  owner "root"
  group "root"
end

bash "disable_swap" do
  flags "-ex"
  code <<-EOM
    swapoff --all
  EOM
end

rightscale_marker :end
