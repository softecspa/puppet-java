class java::install {

  case $java::real_package {

    'sun-java6': {
      package {
        'gij':            ensure  => absent;
        'gcj':            ensure  => absent;
        'ant-gcj':        ensure  => absent;
        'sun-java6-bin':
          ensure  => installed,
          require => Exec['debconf-set-selections-sun-java6-bin'];
        'sun-java6-jre':
          ensure  => installed,
          require => Exec['debconf-set-selections-sun-java6-jre']
      }

      exec { 'debconf-set-selections-sun-java6-bin':
        command => '/bin/echo \'sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true\' | /usr/bin/debconf-set-selections',
        unless  => 'grep -A1 accepted-sun-dlj-v1-1 /var/cache/debconf/config.dat | grep -iq \'value: true\'',
      }

      exec { 'debconf-set-selections-sun-java6-jre':
        command => '/bin/echo \'sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true\' | /usr/bin/debconf-set-selections',
        unless  => 'grep -A1 accepted-sun-dlj-v1-1 /var/cache/debconf/config.dat | grep -iq \'value: true\'',
      }

      if $::lsbdistcodename == 'lucid' {
        apt::key { $java::params::ferramroberto_ppa_key :
          before  => [ Package['sun-java6-bin'], Package['sun-java6-jre'] ],
        }

        apt::sources_list { 'ferramroberto-java-lucid':
          content => "deb http://ppa.launchpad.net/ferramroberto/java/ubuntu $::lsbdistcodename main",
          before  => [ Package['sun-java6-bin'], Package['sun-java6-jre'] ],
        }
      }

      java::update_alternatives { 'update-alternatives-java6-sun':
        java_version  => 'java-6-sun',
        require       => [ Package['sun-java6-bin'], Package['sun-java6-jre'] ],
      }

    }

    'openjdk-6-jre': {
      package { 'openjdk-6-jre':
        ensure  => installed
      }

      java::update_alternatives { 'update-alternatives-java6-openjdk':
        java_version  => 'java-6-openjdk',
        require       => [ Package['openjdk-6-jre'] ],
      }
    }

    'openjdk-7-jre': {
      package {'openjdk-7-jre':
        ensure  => installed
      }

      java::update_alternatives { 'update-alternatives-java7-openjd':
        java_version        => "java-1.7.0-openjdk-${::architecture}",
        java_check_version  => "java-7-openjdk-${::architecture}",
        require             => [ Package['openjdk-7-jre'] ],
      }
    }

    default: {}

  }
}


