name             'cnmonitor'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures cnmonitor'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "DS389"

recipe "cnmonitor::setup_389ds", "sets up cn=monitor for ds389"
