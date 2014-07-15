class java (
  $java_package = ''
) {

  include java::params

  if ($java_package != '') {
    if !($java_package in $java::params::available_versions) {
      fail ("java available versions are: ${java::params::available_versions}")
    }
  }

  $real_package = $java_package ? {
    '' => $::lsbdistcodename ? {
      hardy   => 'sun-java6',
      lucid   => 'openjdk-6-jre',
      precise => 'openjdk-7-jre'
    },
    default => $java::java_package
  }

  case $real_package {
    'sun-java6': {
      if ($::lsbdistcodename == 'precise') {
        fail('sun-java6 is available only in hardy and lucid distribution')
      }
    }
    'openjdk-6-jre': {
      if ($::lsbdistcodename == 'hardy') {
        fail('openjdk-6-jre isn\'t available in hardy distribution')
      }
    }
    'openjdk-7-jre': {
      if ($::lsbdistcodename != 'precise') {
        fail('openjdk-7-jre is available only in precise distribution')
      }
    }
    default: {
    }
  }

  include java::install
}
