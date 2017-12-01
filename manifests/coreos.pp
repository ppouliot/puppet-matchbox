# matchbox::coreos
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox::coreos

class matchbox::coreos {

  if $::channel =~/([0-9]+).([0-9]+).([0-9])/{
    $rel_major = $1
    $rel_minor = $2
    notice($::rel_major)
    notice($::rel_minor)
  } else {
    warning("${::distro} ${::channel} does not have major and minor point ::channels for ${::name}.")
  }

  if ( $::distro == 'coreos' ) {
    case $::channel {
      'stable':{
        warning("coreos ${::channel} for ${::arch} will be activated")
        $coreos_version = '1520.8.0'
      }
      'beta':{
        warning("coreos ${::channel} for ${::arch} will be activated")
        $coreos_version = '1576.2.0'
      }
      'alpha':{
        warning("coreos ${::channel} for ${::arch} will be activated")
        $coreos_version = '1590.0.0'
      }
      default:{
        fail("${::name} is not a valid coreos ::channel! Valid ::channel are stable, beta  or alpha.")
      }
    }
    case $::arch {
      'amd64','arm64':{
        warning("coreos ${::channel} for ${::arch} will be activated")
      }
      default:{
        fail("${::arch} is not a valid processor architecture for coreos, valid processor arch are amd64 and arm64.")
      }
    }
    $coreos_channel  = $::channel
    $autofile        = 'cloud-config.yml'
    $linux_installer = 'coreos-install'
    $pxekernel      = 'coreos_production_pxe.vmlinuz'
    $initrd          = 'cpio.gz'
    $src_initrd      = "coreos_production_pxe_image.${initrd}"
    $target_kernel   = "${::channel}_production.vmlinuz"
    $target_initrd   = "${::channel}_production.${initrd}"

    # This adds scripts to deploy to the system after booting into coreos 
    # when finished it should reboot.
    file {"/srv/quartermaster/${::distro}/${autofile}/${::name}.pxe_installer.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.pxe_installer.sh.erb'),
    }
    file {"/srv/quartermaster/${::distro}/${autofile}/${::name}.running_instance.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.running_instance.sh.erb'),
    }
    file {"/srv/quartermaster/${::distro}/${autofile}/${::name}.custom_ip_resolution.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.custom_ip_resolution.sh.erb'),
    }
    if ( $quartermaster::matchbox_enable ) {
      notice("matchbox/groups/${::channel}-install.json")
      exec{"matchbox_get-coreos_${coreos_::channel}-${coreos_version}":
        command   => "/usr/local/bin/get-coreos ${coreos_::channel} ${coreos_version} /var/lib/matchbox/assets",
        logoutput => true,
        timeout   => 0,
        user      => 'root',
        creates   => [
        "/var/lib/matchbox/assets/coreos/${coreos_version}",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/CoreOS_Image_Signing_Key.asc",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_image.bin.bz2",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_image.bin.bz2.sig",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_pxe_image.cpio.gz",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_pxe_image.cpio.gz.sig",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_pxe.vmlinuz",
        "/var/lib/matchbox/assets/coreos/${coreos_version}/coreos_production_pxe.vmlinuz.sig",
        ],
        require   => File['/var/lib/matchbox/assets'],
      }
      # Begin Examples
      file{[
        "/var/lib/matchbox/examples/${coreos_version}",
        "/var/lib/matchbox/examples/${coreos_version}/groups",
        "/var/lib/matchbox/examples/${coreos_version}/groups/simple",
        "/var/lib/matchbox/examples/${coreos_version}/groups/simple-install",
        "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3",
        "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install",
        "/var/lib/matchbox/examples/${coreos_version}/groups/grub",
        "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube",
        "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube-install",
        "/var/lib/matchbox/examples/${coreos_version}/profiles",
#       "/var/lib/matchbox/examples/${coreos_version}/ignition",
        ]:
        ensure => directory,
        owner  => 'matchbox',
        group  => 'matchbox',
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/ignition":
        ensure  => directory,
        owner   => 'matchbox',
        group   => 'matchbox',
        recurse => true,
        source  => 'puppet:///modules/quartermaster/coreos/matchbox/ignition',
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/grub/default.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/grub/default.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/simple/default.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple/default.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/simple-install/simple.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple-install/simple.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/simple-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple-install/install.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3/gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/gateway.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node1.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node2.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node3.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install/gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/gateway.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node1.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node2.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node3.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/etcd3-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/install.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node1.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node2.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node3.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube-install/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node1.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube-install/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node2.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube-install/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node3.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/groups/bootkube-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/install.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/simple.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/simple.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/simple-install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/simple-install.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/grub.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/grub.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/etcd3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/etcd3.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/etcd3-gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/etcd3-gateway.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/bootkube-worker.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/bootkube-worker.json.erb'),
      }
      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/bootkube-controller.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/bootkube-controller.json.erb'),
      }
# Below is commented out until bits are properly cleaned up.
      # matchbox profiles grub.json
#
#      file{ "/var/lib/matchbox/groups/${::channel}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.::channel-install.json.erb'),
#      }
#      notice("matchbox/profiles/${::channel}-install.json")
#      file{ "/var/lib/matchbox/profiles/${::channel}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.::channel-install.json.erb'),
#      }
#      notice("matchbox/groups/${::channel}.json")
#      file{ "/var/lib/matchbox/groups/${::channel}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.::channel.json.erb'),
#      }
      # matchbox groups etcd3-install.json
#      file{ "/var/lib/matchbox/groups/etcd3-${::channel}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.etcd3-install.json.erb'),
#      }
      # Begin Examples
#      notice("matchbox/profiles/${::channel}.json")
#      file{ "/var/lib/matchbox/profiles/${::channel}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.::channel.json.erb'),
#      }
      # matchbox profiles grub.json
#      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/grub-${::channel}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.grub.json.erb'),
#      }

      # matchbox profiles etcd3.json
#      file{ "/var/lib/matchbox/profiles/etcd3-${::channel}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3.json.erb'),
#      }

      # matchbox profiles etcd3-gateway.json
#      file{ "/var/lib/matchbox/profiles/etcd3-gateway-${::channel}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3-gateway.json.erb'),
#      }

#      file{ "/var/lib/matchbox/profiles/install-${::channel}-reboot.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.install-::channel-reboot.json.erb'),
#      }

    }
  }

}
