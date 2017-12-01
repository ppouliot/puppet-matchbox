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
      command     => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/cert-gen',
      cwd         => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/',
      logoutput   => true,
      timeout     => '0',
      user        => 'root',
      creates     => [
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/certs',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/crl',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/newcerts',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/serial',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/index.txt',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/index.txt.attr',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/ca.crt',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/ca.key',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/server.crt',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/server.key',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/client.crt',
      '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/client.key',
      ],
    } ->
    # Generated Certs to /etc ca.crt server.crt server.key
    file{'/etc/matchbox/ca.crt':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/ca.crt',
    } ->
    file{'/etc/matchbox/server.crt':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/server.crt',
    } ->
    file{'/etc/matchbox/server.key':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/server.key',
    } ->
    # Add client Certs to /root/.matchbox
    file{'/root/.matchbox/client.key':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/client.key',
    } ->
    file{'/root/.matchbox/client.crt':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/client.crt',
    } ->
    file{'/root/.matchbox/ca.crt':
      ensure => file,
      source => '/home/matchbox/matchbox-v0.6.1-linux-amd64/scripts/tls/ca.crt',
    }
}
