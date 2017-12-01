# matchbox::server
#
# Adds CoreOS Matchbox as part of the CoreOS deployment infrastructure
#
# @summary Install matchbox as a service and starts it
#
# @example
#   include matchbox::server
#
class matchbox::server {
  $matchbox_enable = $matchbox::enable,
){

  validate_bool( $quartermaster::matchbox_enable )
  validate_string( $quartermaster::matchbox_version )

  if $quartermaster::matchbox_enable == true {
    user { 'matchbox':
      ensure     => 'present',
      managehome => true,
    } ->
    file{[
      '/var/lib/matchbox',
      '/var/lib/matchbox/examples',
      '/var/lib/matchbox/assets',
      '/var/lib/matchbox/profiles',
      '/var/lib/matchbox/cloud',
      '/var/lib/matchbox/generic',
      '/etc/matchbox',
    ]:
      ensure => directory,
      owner  => 'matchbox',
      group  => 'matchbox',

    }  -> 
    # matchbox terraform
    file{'/root/.matchbox':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    } ->
    file{ '/var/lib/matchbox/addons':
      ensure  => directory,
      recurse => true,
      owner   => 'matchbox',
      group   => 'matchbox',
      source  => 'puppet:///modules/quartermaster/coreos/matchbox/addons',
    } ->
    # matchbox groups
    # matchbox groups
    file{ '/var/lib/matchbox/terraform':
      ensure  => directory,
      recurse => true,
      owner   => 'matchbox',
      group   => 'matchbox',
      source  => 'puppet:///modules/quartermaster/coreos/matchbox/terraform',
    } ->
    # matchbox groups
    file{ '/var/lib/matchbox/groups':
      ensure  => directory,
      recurse => true,
      owner   => 'matchbox',
      group   => 'matchbox',
      source  => 'puppet:///modules/quartermaster/coreos/matchbox/groups',
    } ->
    # matchbox groups/bootkube-install/install.json
#    file{ '/var/lib/matchbox/groups/bootkube-install.json':
#      ensure  => file,
#      owner   => 'matchbox',
#      group   => 'matchbox',
#      content => template('quartermaster/matchbox/groups/bootkube-install.json.erb'),
#    } ->
    # matchbox groups/etcd3-install/install.json
#    file{ '/var/lib/matchbox/groups/etcd3-install.json':
#      ensure  => file,
#      owner   => 'matchbox',
#      group   => 'matchbox',
#      content => template('quartermaster/matchbox/groups/etcd3-install.json.erb'),
#    } ->
    # matchbox groups/simple-install/install.json
#    file{ '/var/lib/matchbox/groups/install.json':
#      ensure  => file,
#      owner   => 'matchbox',
#      group   => 'matchbox',
#      content => template('quartermaster/matchbox/groups/simple-install.json.erb'),
#    } ->

    # matchbox profiles install-reboot.json
    file{ '/var/lib/matchbox/profiles/default.json':
      ensure  => file,
      owner   => 'matchbox',
      group   => 'matchbox',
      content => template('quartermaster/matchbox/profiles.default.json.erb'),
    } ->

#    # matchbox profiles bootkube-worker.json
#    file{ '/var/lib/matchbox/profiles/bootkube-worker.json':
#      ensure  => file,
#      owner   => 'matchbox',
#      group   => 'matchbox',
#      content => template('quartermaster/matchbox/profiles/bootkube-worker.json.erb'),
#    } ->

#    # matchbox profiles bootkube-controller.json
#    file{ '/var/lib/matchbox/profiles/bootkube-controller.json':
#      ensure  => file,
#      owner   => 'matchbox',
#      group   => 'matchbox',
#      content => template('quartermaster/matchbox/profiles/bootkube-controller.json.erb'),
#    } ->
    # matchbox terraform/etcd3-install/terraform.tfvars
    file{ '/var/lib/matchbox/terraform/etcd3-install/terraform.tfvars':
      ensure  => file,
      owner   => 'matchbox',
      group   => 'matchbox',
      content => template('quartermaster/matchbox/terraform/etcd3-install.terraform.tfvars.erb'),
    } ->

    # matchbox terraform/simple-install/terraform.tfvars
    file{ '/var/lib/matchbox/terraform/simple-install/terraform.tfvars':
      ensure  => file,
      owner   => 'matchbox',
      group   => 'matchbox',
      content => template('quartermaster/matchbox/terraform/simple-install.terraform.tfvars.erb'),
    } ->


    # matchbox ignition
    file{ '/var/lib/matchbox/ignition':
      ensure  => directory,
      recurse => true,
      owner   => 'matchbox',
      group   => 'matchbox',
      source  => 'puppet:///modules/quartermaster/coreos/matchbox/ignition',
    } ->
    
    staging::deploy{"matchbox-v${quartermaster::matchbox_version}-linux-amd64.tar.gz":
      source   => "https://github.com/coreos/matchbox/releases/download/v${quartermaster::matchbox_version}/matchbox-v${quartermaster::matchbox_version}-linux-amd64.tar.gz",
      target   => '/home/matchbox',
      username => 'root',
      creates  => [
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/CHANGES.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd/matchbox-for-tectonic.service",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd/matchbox-local.service",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd/matchbox-on-coreos.service",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd/matchbox.service",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/api.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/bootkube.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/bootkube-upgrades.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/cloud-config.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/config.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/container-linux-config.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/deployment.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/dev",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/dev/develop.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/dev/release.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/getting-started-docker.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/getting-started.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/getting-started-rkt.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/grub.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/ipxe.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/kubernetes-dashboard.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/machine-lifecycle.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/network-setup-flow.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/overview.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/proxydhcp.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/pxelinux.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/tectonic-console.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/img/tectonic-installer.png",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/machine-lifecycle.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/matchbox.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/network-booting.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/network-setup.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/openpgp.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/docs/Documentation/troubleshooting.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/cloud",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube/node1.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube/node2.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube/node3.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube-install",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube-install/install.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube-install/node1.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube-install/node2.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/bootkube-install/node3.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3/gateway.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3/node1.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3/node2.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3/node3.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install/gateway.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install/install.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install/node1.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install/node2.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/etcd3-install/node3.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/grub",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/grub/default.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/simple",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/simple/default.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/simple-install",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/simple-install/install.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/groups/simple-install/simple.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/bootkube-controller.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/bootkube-worker.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/etcd3-gateway.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/etcd3.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/install-reboot.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/ignition/ssh.yaml",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/bootkube-controller.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/bootkube-worker.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/etcd3-gateway.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/etcd3.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/grub.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/install-reboot.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/simple-install.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/profiles/simple.json",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/examples/README.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/LICENSE",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/matchbox",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/README.md",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/get-coreos",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/tls",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/tls/cert-gen",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/tls/openssl.conf",
      "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/tls/README.md",
      ],
    } ->
    file{'/usr/local/bin/matchbox':
      ensure => file,
      source => "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/matchbox",
      mode   => '0777',
    } ->
    file{'/usr/local/bin/get-coreos':
      ensure => file,
      source => "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/scripts/get-coreos",
      mode   => '0777',
    } ->
    file{'/etc/systemd/system/matchbox.service':
      ensure => file,
      source => "/home/matchbox/matchbox-v${quartermaster::matchbox_version}-linux-amd64/contrib/systemd/matchbox-local.service",
      mode   => '0777',
    }

    if ( $facts[os][distro][id] == 'Ubuntu' ) and ( $facts[os][distro][release][major] == '14.04'){
      package{'systemd':
        ensure => latest
      } ->
      file{'/etc/init/matchbox.conf':
        ensure => file,
        source  => 'puppet:///modules/quartermaster/coreos/matchbox/upstart.matchbox.conf'
      }
    }
    # Start the Matchbox Service and Enable it
    service{'matchbox':
      enable => true,
      ensure => 'running',
    }
  }
}
