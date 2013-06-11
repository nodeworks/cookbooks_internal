#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2012, RightScale Inc.
#
# All rights reserved - Do Not Redistribute
#
class Chef::Recipe
  include RightScale::Hadoop::Helper
end

rightscale_marker :begin

right_link_tag "hadoop:node_type=#{node[:hadoop][:node][:type]}"

#uninstall packages
node[:hadoop][:uninstall_packages] = packages = value_for_platform(
  ["centos", "redhat"] => {
    "default" => [
      "jdk"
    ]
  },
  "ubuntu" => {
    "default" => [ ]
  }
)


#install openjdk packages
node[:hadoop][:packages] = value_for_platform(
  ["centos", "redhat"] => {
    "default" => [
      "java-1.6.0-openjdk",
      "java-1.6.0-openjdk-devel"
    ]
  },
  "ubuntu" => {
    "default" => [
      "openjdk-6-jdk"
    ]
  }
)


include_recipe 'hadoop::install'
include_recipe 'hadoop::do_config'
include_recipe 'hadoop::do_init'

rightscale_marker :end