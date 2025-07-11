#!/usr/bin/env bash

VPN_NAME="wg-enp5s0"

if sudo wg show "$VPN_NAME" > /dev/null 2>&1; then
    wg-quick down "$VPN_NAME"
else
    wg-quick up "$VPN_NAME"
fi