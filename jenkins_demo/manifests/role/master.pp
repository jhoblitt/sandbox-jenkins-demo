class jenkins_demo::role::master {
  include ::jenkins_demo::profile::base
  include ::jenkins_demo::profile::ganglia::gmond
  include ::jenkins_demo::profile::ganglia::web
  include ::jenkins_demo::profile::master
  include ::jenkins_demo::profile::sensu::base
  include ::jenkins_demo::profile::sensu::server
  include ::jenkins_demo::profile::sensu::check::base
  include ::jenkins_demo::profile::sensu::check::sensu_server
  include ::jenkins_demo::profile::sensu::check::jenkins_master
  include ::jenkins_demo::profile::sensu::check::jenkins_slave

  class { 'selinux': mode => 'enforcing' }
}
