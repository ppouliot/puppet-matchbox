# matchbox::example
#
# Class to install matchbox terraform examples to a home directory
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   matchbox::example { 'namevar': }
define matchbox::example(
  $coreos_version = $name
) {
      # Begin Examples
      file{[
        "/home/matchbox/examples/${coreos_version}",
        "/home/matchbox/examples/${coreos_version}/groups",
        "/home/matchbox/examples/${coreos_version}/groups/simple",
        "/home/matchbox/examples/${coreos_version}/groups/simple-install",
        "/home/matchbox/examples/${coreos_version}/groups/etcd3",
        "/home/matchbox/examples/${coreos_version}/groups/etcd3-install",
        "/home/matchbox/examples/${coreos_version}/groups/grub",
        "/home/matchbox/examples/${coreos_version}/groups/bootkube",
        "/home/matchbox/examples/${coreos_version}/groups/bootkube-install",
        "/home/matchbox/examples/${coreos_version}/profiles",
#       "/home/matchbox/examples/${coreos_version}/ignition",
        ]:
        ensure => directory,
        owner  => 'matchbox',
        group  => 'matchbox',
      }
      file{ "/home/matchbox/examples/${coreos_version}/ignition":
        ensure  => directory,
        owner   => 'matchbox',
        group   => 'matchbox',
        recurse => true,
        source  => 'puppet:///modules/quartermaster/coreos/matchbox/ignition',
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/grub/default.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/grub/default.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/simple/default.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple/default.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/simple-install/simple.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple-install/simple.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/simple-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/simple-install/install.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3/gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/gateway.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node1.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node2.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3/node3.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3-install/gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/gateway.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3-install/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node1.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3-install/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node2.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3-install/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/node3.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/etcd3-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/etcd3-install/install.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node1.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node2.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube/node3.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube-install/node1.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node1.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube-install/node2.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node2.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube-install/node3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/node3.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/groups/bootkube-install/install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/groups/bootkube-install/install.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/simple.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/simple.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/simple-install.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/simple-install.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/grub.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/grub.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/etcd3.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/etcd3.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/etcd3-gateway.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/etcd3-gateway.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/bootkube-worker.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/bootkube-worker.json.erb'),
      }
      file{ "/home/matchbox/examples/${coreos_version}/profiles/bootkube-controller.json":
        ensure  => file,
        owner   => 'matchbox',
        group   => 'matchbox',
        content => template('quartermaster/matchbox/profiles/bootkube-controller.json.erb'),
      }
# Below is commented out until bits are properly cleaned up.
      # matchbox profiles grub.json
#
#      file{ "/home/matchbox/groups/${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.channel-install.json.erb'),
#      }
#      notice("matchbox/profiles/${release}-install.json")
#      file{ "/home/matchbox/profiles/${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.channel-install.json.erb'),
#      }
#      notice("matchbox/groups/${release}.json")
#      file{ "/home/matchbox/groups/${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.channel.json.erb'),
#      }
      # matchbox groups etcd3-install.json
#      file{ "/home/matchbox/groups/etcd3-${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.etcd3-install.json.erb'),
#      }
      # Begin Examples
#      notice("matchbox/profiles/${release}.json")
#      file{ "/home/matchbox/profiles/${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.channel.json.erb'),
#      }
      # matchbox profiles grub.json
#      file{ "/home/matchbox/examples/${coreos_version}/profiles/grub-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.grub.json.erb'),
#      }

      # matchbox profiles etcd3.json
#      file{ "/home/matchbox/profiles/etcd3-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3.json.erb'),
#      }

      # matchbox profiles etcd3-gateway.json
#      file{ "/home/matchbox/profiles/etcd3-gateway-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3-gateway.json.erb'),
#      }
#      file{ "/home/matchbox/profiles/install-${release}-reboot.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.install-channel-reboot.json.erb'),
#      }

}
