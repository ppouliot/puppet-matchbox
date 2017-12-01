# matchbox
# Module to install an up-to-date version of matchbox from the internet
#
# @Parameters
#
#
# [*version*]
#   The version to install.
#   Defaults to undefined
#
# [*arch*]
#   Architecture of the target platform.
#   Defaults to amd64
#
# [*ensure*]
#   Passed to internal classes
#   Defaults to present
#
# [*enable*]
#   Passed to internal classes
#   Defaults to undef
#
# [*go_version*]
#   The version to install.
#   Defaults to undefined
#
# [*terraform_version*]
#   The version to install.
#   Defaults to undefined
#
# [*log_level*]
#   Set the logging level
#   Defaults to undef: matchbox defaults to info if no value specified
#   Valid values: debug, info, warn, error, fatal
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
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox
class matchbox (
  $version            = '0.6.1',
  $arch               = 'amd64',
  $ensure             = present,
  $enable             = undef,
  $go_version         = '1.9.2',
  $terraform_version  = '0.11.0',
  $log_level          = undef
  $service_name = $service_name_default
  $service_state      = running
  $service_enable     = true
  $manage_service     = true
){
  validate_string($version)
  validate_string($go_version)
  validate_string($terraformversion)
  validate_string($version)
  validate_bool($manage_service)
  validate_re($::osfamily, '^(Debian|RedHat|CoreOS)$',
              'This module only works on Debian or Red Hat based systems or on CoreOS.')
#  validate_bool($tls_enable)
  if $log_level {
    validate_re($log_level, '^(debug|info|warn|error|fatal)$', 'log_level must be one of debug, info, warn, error or fatal')
  }
  case $::osfamily {
    'Debian' : {
      case $::operatingsystem {
        'Ubuntu' : {
          if (versioncmp($::operatingsystemrelease, '15.04') >= 0) {
            $service_provider        = 'systemd'
            $service_config_template = 'matchbox/etc/sysconfig/matchbox.systemd.erb'
            $service_overrides_template = 'matchbox/etc/systemd/system/matchbox.service.d/overrides.conf.erb'
            $service_hasstatus       = true
            $service_hasrestart      = true
            include matchbox::systemd_reload
          } else {
            $service_config_template = 'matchbox/etc/default/matchbox.erb'
            $service_overrides_template = undef
            $service_provider        = 'upstart'
            $service_hasstatus       = true
            $service_hasrestart      = false
          }
        }
        default: {
          if (versioncmp($::operatingsystemmajrelease, '8') >= 0) {
            $service_provider           = 'systemd'
            $service_config_template    = 'matchbox/etc/sysconfig/matchbox.systemd.erb'
            $service_overrides_template = 'matchbox/etc/systemd/system/matchbox.service.d/overrides.conf.erb'
            $service_hasstatus          = true
            $service_hasrestart         = true
            include matchbox::systemd_reload
          } else {
            $service_provider           = undef
            $service_config_template    = 'matchbox/etc/default/matchbox.erb'
            $service_overrides_template = undef
            $service_hasstatus          = undef
            $service_hasrestart         = undef
          }
        }
      }
      if ($::operatingsystem == 'Debian' and versioncmp($::operatingsystemmajrelease, '8') >= 0) or
        ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '15.04') >= 0) {
        $detach_service_in_init = false
      } else {
        $detach_service_in_init = true
      }
    }
    'RedHat':{
      $service_config = '/etc/sysconfig/matchbox'
      $service_hasstatus  = true
      $service_hasrestart = true
      $service_provider           = 'systemd'
      $service_config_template    = 'matchbox/etc/sysconfig/matchbox.systemd.erb'
      $service_overrides_template = 'matchbox/etc/systemd/system/matchbox.service.d/service-overrides-rhel.conf.erb'
    }
    'CoreOS':{}
    default:{}
  }
  

  include stdlib
  if $matchbox_enable == true {
    class{'::matchbox':}
    contain matchbox
  }

}
