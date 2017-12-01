# matchbox
# Module to install an up-to-date version of matchbox from the internet
#
# @Parameters
#
# [*version*]
#   The version to install.
#   Defaults to undefined
#
# [*ensure*]
#   Passed to internal classes
#   Defaults to present
#
# [*service_state*]
#   Whether you want to matchbox daemon to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to matchbox daemon to start up at boot
#   Defaults to true
#
# [*manage_service*]
#   Specify whether the service should be managed.
#   Valid values are 'true', 'false'.
#   Defaults to 'true'.
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox
class matchbox (
  $ensure             = present,
  $enable             = undef,
  $version            = '0.6.1',
  $go_version         = '1.9.2',
  $terraform_version  = '0.11.0',
  $service_state      = running
  $service_enable     = true
  $manage_service     = true
){
  validate_string($version)
  validate_re($::osfamily, '^(Debian|RedHat|CoreOS)$',
              'This module only works on Debian or Red Hat based systems or on CoreOS.')
  validate_bool($tls_enable)

  include stdlib
  if $matchbox_enable == true {
    class{'::matchbox':}
    contain matchbox
  }

}
