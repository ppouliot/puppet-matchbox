# matchbox::get_coreos
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   matchbox::get_coreos { 'namevar': }
define matchbox::get_coreos( $channel, $_version, $asset_path ) {
  exec{"matchbox_get-coreos_${coreos_channel}-${coreos_version}":
    command   => "/usr/local/bin/get-coreos ${coreos_channel} ${coreos_version} ${asset_path}",
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
}
