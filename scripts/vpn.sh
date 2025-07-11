#!/usr/bin/env bash
VPN_NAME="wg-enp5s0"

echo "Checking VPN status..."

# Check if VPN is running and toggle accordingly
if sudo wg show "$VPN_NAME" > /dev/null 2>&1; then
    echo "VPN is running. Disconnecting..."
    sudo wg-quick down "$VPN_NAME"
    echo "VPN disconnected successfully!"
else
    echo "VPN is not running. Connecting..."
    sudo wg-quick up "$VPN_NAME"
    echo "VPN connected successfully!"
fi

# Keep terminal open for a moment to show result
sleep 1