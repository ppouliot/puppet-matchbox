# matchbox::terraform_matchbox_provider
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox::terraform_matchbox_provider
class matchbox::terraform_matchbox_provider {
    staging::deploy{"terraform_${quartermaster::terraform_version}_linux_amd64.zip":
      source  => "https://releases.hashicorp.com/terraform/${quartermaster::terraform_version}/terraform_${quartermaster::terraform_version}_linux_amd64.zip",
      target  => '/usr/local/bin',
      creates => '/usr/local/bin/terraform'
    } ->
    # install the terraform matchbox provider
    exec{'go-get-terraform-provider-matchbox':
      environment => [
        'GOPATH=/opt/go',
        'GOBIN=/usr/local/go/bin',
      ],
      command     => '/usr/local/go/bin/go get github.com/coreos/terraform-provider-matchbox',
      creates     => '/usr/local/bin/terraform-provider-matchbox',
      cwd         => '/usr/local/go',
      logoutput   => true,
      timeout     => '0',
      user        => 'root',
    } ->
    # Add a .terraformrc for matchbox in /root
    file{ '/root/.terraformrc':
      ensure => file,
      content => '#
providers {
  matchbox = "/usr/local/go/bin/terraform-provider-matchbox"
}
',
    } 
}
