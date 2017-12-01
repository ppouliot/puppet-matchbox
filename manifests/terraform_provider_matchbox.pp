# matchbox::terraform_provider_matchbox
#
# This class installs terraform and the terraform matchbox provider
#
# @summary 
#  This class downloads and extracts the terraform binary from the internet
#  and extract it to /usr/local/bin.  It also runs a `go get` command to
#  retrieve terraform-provider-matchbox from github and install it to the
#  GOPATH.
# @example
#   include matchbox::terraform_provider_matchbox
class matchbox::terraform_provider_matchbox {
  staging::deploy{"terraform_${matchbox::terraform_version}_linux_amd64.zip":
    source  => "https://releases.hashicorp.com/terraform/${matchbox::terraform_version}/terraform_${matchbox::terraform_version}_linux_amd64.zip",
    target  => '/usr/local/bin',
    creates => '/usr/local/bin/terraform',
  }
  # install the terraform matchbox provider
->exec{'go-get-terraform-provider-matchbox':
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
  }
  # Add a .terraformrc for matchbox in /root
->file{ [
    '/root/.terraformrc',
    '/etc/skel/.terraformrc',
  ]:
    ensure  => file,
    content => "# Puppet Managed: ${::module_name}
providers {
  matchbox = \"/usr/local/go/bin/terraform-provider-matchbox\"
}
",
  }
}
