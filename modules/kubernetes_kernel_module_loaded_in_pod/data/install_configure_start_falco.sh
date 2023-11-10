#!/bin/bash

# Install Falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y && apt-get install -y falco

# Configure Falco
cat <<EOF | tee /etc/falco/falco.yaml
falco:
  program_output:
    enabled: true
    keep_alive: false
    program: "/usr/bin/logger -t falco -p local3.info"
  rules_file:
    - /etc/falco/falco_rules.yaml
EOF

# Start Falco
systemctl enable falco && systemctl start falco