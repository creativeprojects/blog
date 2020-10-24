#!/bin/bash

ports="80,443"
ipv4="ips-v4"
ipv6="ips-v6"
installv4="install-v4.sh"
installv6="install-v6.sh"

rm -f $ipv4 $ipv6

echo "Downloading IPv4 addresses..."
curl https://www.cloudflare.com/$ipv4 | sort >$ipv4

echo "Downloading IPv6 addresses..."
curl https://www.cloudflare.com/$ipv6 | sort >$ipv6

echo "#!/bin/sh" > "$installv4"
echo "#!/bin/sh" > "$installv6"

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "ufw allow from $line to any port $ports proto tcp" >> "$installv4"
done < "$ipv4"

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "ufw allow from $line to any port $ports proto tcp" >> "$installv6"
done < "$ipv6"
