# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


rightscale_marker :begin

log("service couchbase-server start")

 execute "starting server" do
    command "/etc/init.d/couchbase-server start && sleep 15"
    action :run
  end


rightscale_marker :end


