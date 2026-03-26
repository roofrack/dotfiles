#!/usr/bin/env bash
set -euo pipefail

# Setting up a bridge to use with kvm,libvirt virtual machines...

# To be able to ssh into vm from another machine other than the host machine
# we need to set up a bridge to reach the vm network. A bridge interface will not
# work while using wifi with kvm/libvirt's vm's so will need to use the ethernet interface. I
# can not get NetworkManager to seamlessly switch between wifi and ethernet when using a
# bridge so will try this helper script. NOTE: If you do unplug the ethernet cable than
# the vm will need to be restarted or can run systemctl restart libvirtd.
# NOTE: If other nm ethernet connection profiles exist then delete them or set priority for br0.

bridge_name="br0"
wifi_connection="LilTimmy"
ethernet_interface=$(nmcli -t -f DEVICE,TYPE dev | grep ethernet | cut -d: -f1 | head -n1)

# Create the bridge br0 (disable stp so switches to ethernet quicker)
# Add physical device enp0s31f6 as a slave to the br0 bridge.
set_up_bridge() {
  if ! nmcli -t -f NAME connection show | grep -qx "$bridge_name" ||
    ! nmcli -t -f NAME connection show | grep -qx "${bridge_name}-slave"; then
    nmcli connection delete "$bridge_name" 2>/dev/null || true
    nmcli connection delete "${bridge_name}-slave" 2>/dev/null || true

    nmcli con add type bridge ifname "$bridge_name" con-name "$bridge_name" \
      bridge.stp no bridge.forward-delay 0
    nmcli con add type bridge-slave ifname "$ethernet_interface" \
      master "$bridge_name" con-name "${bridge_name}-slave"
  fi
}

wifi_up() {
  echo "WIFI connected to $wifi_connection..."
  nmcli connection down "$bridge_name" &>/dev/null || true
  nmcli radio wifi on
}

ethernet_up() {
  echo "Ethernet connected to $ethernet_interface..."
  nmcli radio wifi off
  nmcli connection up "${bridge_name}-slave" &>/dev/null || true
  nmcli connection up "$bridge_name" &>/dev/null || true
}

# The 'carrier' file contains 1 if link is up, 0 if down/unplugged
toggle_interfaces() {
  local eth_status && local wifi_status
  eth_status=$(cat "/sys/class/net/${ethernet_interface}/carrier" 2>/dev/null || echo 0)
  wifi_status=$(nmcli -t -f wifi radio)

  if [[ "$eth_status" == "0" ]] && [[ "$wifi_status" == "disabled" ]]; then
    wifi_up
  elif [[ "$eth_status" == "1" ]] && [[ "$wifi_status" == "enabled" ]]; then
    ethernet_up
  fi
}

cleanup() {
  # log "Stopping service, restoring WiFi"
  nmcli radio wifi on
}

main() {
  trap cleanup SIGINT SIGTERM
  set_up_bridge

  while true; do
    toggle_interfaces
    sleep 2
  done
}
main
