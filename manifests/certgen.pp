# matchbox::certgen
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include matchbox::certgen
class matchbox::certgen {
  # Generate Certificates for FQDN and IP
  exec{'certgen-for-matchbox-services':
    environment => [
    "SAN=DNS.1:${::fqdn},IP.1:${::ipaddress}",
    ],
    command     => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/cert-gen",
    cwd         => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls",
    logoutput   => true,
    timeout     => '0',
    user        => 'root',
    creates     => [
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/certs",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/crl",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/newcerts",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/serial",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/index.txt",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/index.txt.attr",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/ca.crt",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/ca.key",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/server.crt",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/server.key",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/client.crt",
    "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/client.key",
    ],
  }
  # Generated Certs to /etc ca.crt server.crt server.key
->file{'/etc/matchbox/ca.crt':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/ca.crt",
  }
->file{'/etc/matchbox/server.crt':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/server.crt",
  }
->file{'/etc/matchbox/server.key':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/server.key",
  }
  # Add client Certs to /root/.matchbox
->file{'/home/matchbox/.matchbox/client.key':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/client.key",
  }
->file{'/home/matchbox/.matchbox/client.crt':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/client.crt",
  }
->file{'/home/matchbox/.matchbox/ca.crt':
    ensure => file,
    source => "/home/matchbox/matchbox-v${matchbox::version}-linux-${matchbox::arch}/scripts/tls/ca.crt",
  }
}
