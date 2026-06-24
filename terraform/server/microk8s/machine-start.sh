#!/bin/bash
set -e

HOSTNAME="microk8s.local"
MACHINE="microk8s"
KUBE_CONFIG="$HOME/.kube/config"

#container machine stop microk8s

# Start the machine if not already running
STATE=$(container machine ls | awk -v name="$MACHINE" '$1 == name {for(i=1;i<=NF;i++) if($i ~ /^(running|stopped)$/) print $i}')
if [ "$STATE" != "running" ]; then
  echo "Starting machine '$MACHINE'..."
  container machine run -n "$MACHINE" "echo started"
fi

# Get the current IP - match the field that looks like an IPv4 address
IP=$(container machine ls | awk -v name="$MACHINE" '$1 == name {for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}')

if [ -z "$IP" ]; then
  echo "Could not find machine '$MACHINE'"
  exit 1
fi

# Update /etc/hosts
sudo sed -i '' "/$HOSTNAME/d" /etc/hosts
echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts > /dev/null
echo "Updated /etc/hosts: $IP $HOSTNAME"

# Update ~/.kube/config server IP
if [ -f "$KUBE_CONFIG" ]; then
  sed -i '' "s|https://[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:16443|https://$IP:16443|g" "$KUBE_CONFIG"
  echo "Updated $KUBE_CONFIG: server set to https://$IP:16443"
else
  echo "No kube config found at $KUBE_CONFIG, skipping"
fi
