# matchbox::get_coreos
#
# A puppet defined type wrapper for the get-coreos.sh script 
#
# @summary 
# This defined type executes the get-coreos.sh script to retrieve
# CoreOS images from the internet.
# 
# @example
#   matchbox::get_coreos { 'namevar': }
define matchbox::get_coreos(
  $channel,
  $version,
  $asset_path = $name,
) {
  include matchbox
  validate_re($ensure, '^(present|absent|latest)$')
  validate_re($coreos_channel, '^(stable|beta|alpha)$',
              'Valid CoreOS channles are "stable", "beta" and "alpha".')
  validate_re($asset_path, '^[\S]*$')
  validate_bool($force)
  exec{"matchbox_get-coreos_${coreos_channel}-${coreos_version}":
    command   => "/usr/local/bin/get-coreos ${coreos_channel} ${coreos_version} ${asset_path}",
    logoutput => $matchbox::logoutput,
    timeout   => 0,
    user      => 'root',
    creates   => [
      "${asset_path}/coreos/${coreos_version}",
      "${asset_path}/coreos/${coreos_version}/CoreOS_Image_Signing_Key.asc",
      "${asset_path}/coreos/${coreos_version}/coreos_production_image.bin.bz2",
      "${asset_path}/coreos/${coreos_version}/coreos_production_image.bin.bz2.sig",
      "${asset_path}/coreos/${coreos_version}/coreos_production_pxe_image.cpio.gz",
      "${asset_path}/coreos/${coreos_version}/coreos_production_pxe_image.cpio.gz.sig",
      "${asset_path}/coreos/${coreos_version}/coreos_production_pxe.vmlinuz",
      "${asset_path}/coreos/${coreos_version}/coreos_production_pxe.vmlinuz.sig",
    ],
    require   => File[$asset_path],
  }
}
