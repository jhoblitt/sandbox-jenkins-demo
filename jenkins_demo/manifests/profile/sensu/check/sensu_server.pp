class jenkins_demo::profile::sensu::check::sensu_server {
  sensu::subscription { 'sensu-server': }

  #
  # sensu-server checks
  #
  $www_host = hiera('www_host', 'jenkins-master')

  sensu::check { 'jenkins-http-https-redirect':
    command     => "/opt/sensu/embedded/bin/check-http.rb --url http://${www_host}/ --redirect-to https://${www_host}/",
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'jenkins-https':
    command     => "/opt/sensu/embedded/bin/check-http.rb --url https://${www_host}/",
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'ganglia-web':
    command     => "/opt/sensu/embedded/bin/check-http.rb --url https://${www_host}/ganglia/",
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'jenkins-https-cert-valid':
    command     => "/opt/sensu/embedded/bin/check-https-cert.rb --url https://${www_host}/ -w 90 -c 45",
    interval    => 3600,
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'rabbitmq-alive':
    command     => '/opt/sensu/embedded/bin/check-rabbitmq-alive.rb --vhost :::vhost|sensu::: --username :::username|sensu::: --password :::password:::',
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
    custom       => {
      'password'   => 'sensutest',
    },
  }

  sensu::check { 'redis':
    command     => '/opt/sensu/embedded/bin/check-redis-info.rb',
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  # we can not use the uchiwa init script to test for aliveness
  # https://github.com/sensu/uchiwa-build/issues/23
  sensu::check { 'uchiwa-service':
    command     => '/opt/sensu/embedded/bin/check-process.rb --file-pid /var/run/uchiwa.pid',
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'sensu-api-service':
    command     => '/opt/sensu/embedded/bin/check-cmd.rb -c \'service sensu-api status\'',
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }

  sensu::check { 'sensu-server-service':
    command     => '/opt/sensu/embedded/bin/check-cmd.rb -c \'service sensu-server status\'',
    refresh     => 15,
    handlers    => 'hipchat',
    subscribers => 'sensu-server',
  }
}
