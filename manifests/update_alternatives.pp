define java::update_alternatives (
  $java_version='',
  $java_check_version = ''
) {

  $to_check = $java_check_version?{
    ''      => $java_version,
    default => $java_check_version
  }

  exec { 'update-java-alternatives':
    command => "/usr/sbin/update-java-alternatives --jre -s $java_version",
    onlyif  => "test -z \"`realpath /etc/alternatives/java | grep ${to_check} `\"",
  }
}
