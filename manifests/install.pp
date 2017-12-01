# matchbox::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox::install
class matchbox::install {
  include ::stdlib
  $matchbox_start_command = $matchbox::matchbox_start_command
  validate_string($matchbox::version)
  validate_re($::osfamily, '^(Debian|RedHat|CoreOS)$',
              'This module only works on Debian or Red Hat based systems or CoreOS based systems.')
  validate_bool($matchbox::use_upstream_package_source)

  if $matchbox::version and $matchbox::ensure != 'absent' {
    $ensure = $matchbox::version
  } else {
    $ensure = $matchbox::ensure
  }

  case $::osfamily {
    'Debian','RedHat':{
      notice('running on a Debian or Redhat Platform')
    }
    'CoreOS':{
      notice('Matchbox on CoreOS')
    }
    default: {
      warning('This may or may not work on this system')
    }
  }
}
