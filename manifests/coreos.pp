# matchbox::coreos
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox::coreos
class matchbox::coreos {
}
# Class: quartermaster::pxelinux
#
# This Class defines the creation of the linux pxe infrastructure
#
define quartermaster::pxelinux (
  # The following pxe menu variables are required for the templates used in this class
  $default_pxeboot_option        = $quartermaster::default_pxeboot_option,
  $pxe_menu_timeout              = $quartermaster::pxe_menu_timeout,
  $pxe_menu_total_timeout        = $quartermaster::pxe_menu_total_timeout,
  $pxe_menu_allow_user_arguments = $quartermaster::pxe_menu_allow_user_arguments,
  $pxe_menu_default_graphics     = $quartermaster::pxe_menu_default_graphics,
  $puppetmaster                  = $quartermaster::puppetmaster,
  $jenkins_swarm_version_to_use  = $quartermaster::jenkins_swarm_version_to_use,
  $use_local_proxy               = $quartermaster::use_local_proxy,
  $vnc_passwd                    = $quartermaster::vnc_passwd,
){

# this regex works w/ no .
#if $name =~ /([a-zA-Z0-9_]+)-([a-zA-Z0-9_]+)-([a-zA-Z0-9_]+)/ {
  if $quartermaster::use_local_proxy {
    Staging::File {
      # Some curl_options to add for downloading large files over questionable links
      # Use local cache   * --proxy http://${ipaddress}:3128
      # Continue Download * -C 
      # Maximum Time      * --max-time 1500 
      # Retry             * --retry 3 
      curl_option => "--proxy http://${::ipaddress}:3128 --retry 3",
      #
      # Puppet waits for the Curl execution to finish
      #
      timeout     => '0',
    }
  }

  # Define proper name formatting matching distro-release-p_arch
  if $name =~ /([a-zA-Z0-9_\.]+)-([a-zA-Z0-9_\.]+)-([a-zA-Z0-9_\.]+)/ {
    $distro  = $1
    $release = $2
    $p_arch  = $3
    notice($distro)
    notice($release)
    notice($p_arch)
    validate_string($distro, '^(debian|centos|fedora|kali|scientificlinux|opensuse|oraclelinux|ubuntu)$', 'The currently supported values for distro are debian, centos, fedora, kali, oraclelinux, scientificlinux, opensuse',)
    validate_string($p_arch, '^(i386|i586|i686|x86_65|amd64)$', 'The currently supported values for pocessor architecture  are i386,i586,i686,x86_64,amd64',)
  } else {
    fail('You must put your entry in format "<Distro>-<Release>-<Processor Arch>" like "centos-7-x86_64" or "ubuntu-14.04-amd64"')
  }
  # convert release into rel_number to check to major and minor releases
  $rel_number = regsubst($release, '(\.)','','G')
  notice($rel_number)

  if $release =~/([0-9]+).([0-9])/{
    $rel_major = $1
    $rel_minor = $2
    notice($rel_major)
    notice($rel_minor)
  } else {
    warning("${distro} ${release} does not have major and minor point releases for ${name}.")
  }

  if ( $distro == 'coreos' ) {
    case $release {
      'stable':{
        warning("coreos ${release} for ${p_arch} will be activated")
        $coreos_version = '1520.8.0'
      }
      'beta':{
        warning("coreos ${release} for ${p_arch} will be activated")
        $coreos_version = '1576.2.0'
      }
      'alpha':{
        warning("coreos ${release} for ${p_arch} will be activated")
        $coreos_version = '1590.0.0'
      }
      default:{
        fail("${name} is not a valid coreos release! Valid release are stable, beta  or alpha.")
      }
    }
    case $p_arch {
      'amd64','arm64':{
        warning("coreos ${release} for ${p_arch} will be activated")
      }
      default:{
        fail("${p_arch} is not a valid processor architecture for coreos, valid processor arch are amd64 and arm64.")
      }
    }
    $coreos_channel  = $release
    $autofile        = 'cloud-config.yml'
    $linux_installer = 'coreos-install'
    $pxekernel      = 'coreos_production_pxe.vmlinuz'
    $initrd          = 'cpio.gz'
    $src_initrd      = "coreos_production_pxe_image.${initrd}"
    $target_kernel   = "${release}_production.vmlinuz"
    $target_initrd   = "${release}_production.${initrd}"
    $url             = "https://${release}.release.core-os.net/${p_arch}-usr/current"
    $inst_repo       = "https://${release}.release.core-os.net/${p_arch}-usr/current"
    $boot_iso_url    = "https://${release}.release.core-os.net/${p_arch}-usr/current/coreos_production_iso_image.iso"

    
    # This adds scripts to deploy to the system after booting into coreos 
    # when finished it should reboot.
    file {"/srv/quartermaster/${distro}/${autofile}/${name}.pxe_installer.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.pxe_installer.sh.erb'),
    }
    file {"/srv/quartermaster/${distro}/${autofile}/${name}.running_instance.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.running_instance.sh.erb'),
    }
    file {"/srv/quartermaster/${distro}/${autofile}/${name}.custom_ip_resolution.sh":
      ensure  => file,
      mode    => '0777',
      content => template('quartermaster/scripts/coreos.custom_ip_resolution.sh.erb'),
    }
    if ( $quartermaster::matchbox_enable ) {
      notice("matchbox/groups/${release}-install.json")
      exec{"matchbox_get-coreos_${coreos_channel}-${coreos_version}":
        command   => "/usr/local/bin/get-coreos ${coreos_channel} ${coreos_version} /var/lib/matchbox/assets",
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
#        "/var/lib/matchbox/examples/${coreos_version}/ignition",
      ]:
        ensure  => directory,
        owner   => 'matchbox',
        group   => 'matchbox',
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
#      file{ "/var/lib/matchbox/groups/${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.channel-install.json.erb'),
#      }
#      notice("matchbox/profiles/${release}-install.json")
#      file{ "/var/lib/matchbox/profiles/${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.channel-install.json.erb'),
#      }
#      notice("matchbox/groups/${release}.json")
#      file{ "/var/lib/matchbox/groups/${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.channel.json.erb'),
#      }
      # matchbox groups etcd3-install.json
#      file{ "/var/lib/matchbox/groups/etcd3-${release}-install.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/groups.etcd3-install.json.erb'),
#      }
      # Begin Examples
#      notice("matchbox/profiles/${release}.json")
#      file{ "/var/lib/matchbox/profiles/${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.channel.json.erb'),
#      }
      # matchbox profiles grub.json
#      file{ "/var/lib/matchbox/examples/${coreos_version}/profiles/grub-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.grub.json.erb'),
#      }

      # matchbox profiles etcd3.json
#      file{ "/var/lib/matchbox/profiles/etcd3-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3.json.erb'),
#      }

      # matchbox profiles etcd3-gateway.json
#      file{ "/var/lib/matchbox/profiles/etcd3-gateway-${release}.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.etcd3-gateway.json.erb'),
#      }

     # profiles install-channel-reboot.json
#      file{ "/var/lib/matchbox/profiles/install-${release}-reboot.json":
#        ensure  => file,
#        owner   => 'matchbox',
#        group   => 'matchbox',
#        content => template('quartermaster/matchbox/profiles.install-channel-reboot.json.erb'),
#      }

    }
  }

}
