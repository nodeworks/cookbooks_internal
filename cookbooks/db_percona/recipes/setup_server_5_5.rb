#
# Cookbook Name:: db_percona
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

version = "5.5"
node[:db][:version] = version
node[:db][:provider] = "db_percona"

#16KB is the recommended by AWS:
#http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSPerformance.html
stripesize = "16"
`sed -i 's/:stripesize => 256/:stripesize => #{stripesize}/' /opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/rightscale_tools-*/lib/rightscale_tools/block_device/lvm.rb`

#patch lvm.rb to retry when lvremove fails. This avoids backups failing and leaving the DB locked
`sed -r -i 's/(lvremove.*):ignore_failure => true/\1:retry_num => 5, :retry_sleep => 10/g' /opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/rightscale_tools-*/lib/rightscale_tools/block_device/lvm.rb`

log "  Setting DB Percona version to #{version}"

# Set MySQL 5.5 specific node variables in this recipe.
#
node[:db][:socket] = value_for_platform(
  "ubuntu" => {
    "default" => "/var/run/mysqld/mysqld.sock"
  },
  "default" => "/var/lib/mysql/mysql.sock"
)

# http://dev.mysql.com/doc/refman/5.5/en/linux-installation-native.html
# For Red Hat and similar distributions, the MySQL distribution is divided into a
# number of separate packages, mysql for the client tools, mysql-server for the
# server and associated tools, and mysql-libs for the libraries.

node[:db_percona][:service_name] = value_for_platform(
  "ubuntu" => {
    "10.04" => "",
    "default" => "mysql"
  },
  "default" => "mysql"
)

node[:db_percona][:server_packages_uninstall] = []

node[:db_percona][:server_packages_install] = value_for_platform(
  "ubuntu" => {
    "10.04" => [],
    "default" => ["percona-server-server-5.5"]
  },
  "default" => ["Percona-Server-server-55","Percona-Server-client-55"]
)

node[:db][:init_timeout] = node[:db_percona][:init_timeout]

# Mysql specific commands for db_sys_info.log file
node[:db][:info_file_options] = ["mysql -V", "cat /etc/mysql/conf.d/my.cnf"]
node[:db][:info_file_location] = "/etc/mysql"

log "  Using MySQL service name: #{node[:db_percona][:service_name]}"
