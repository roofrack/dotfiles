#!/usr/bin/env bash
set -euo pipefail

# Setting up a bridge to use with kvm,libvirt virtual machines...

# To be able to ssh into vm from another machine other than the host machine
# we need to set up a bridge to reach the vm network. A bridge interface will not
# work while using wifi with kvm/libvirt's vm's so will need to use the ethernet
# interface. I can not get NetworkManager to seamlessly switch between wifi and ethernet
# when using a bridge so wrote this helper script.
# NOTE:
#   -If other nm ethernet con profiles exist then delete them or set priority for br0.
#   -If you do unplug the ethernet cable than the vm will need to be restarted or can run
#    systemctl restart libvirtd.

BRIDGE_NAME="br0"
WIFI_CONNECTION="LilTimmy"
ETHERNET_INTERFACE=$(nmcli -t -f DEVICE,TYPE dev | grep ethernet | cut -d: -f1 | head -n1)
POLL_INTERVAL=2

# Create the bridge br0 (disable stp so switches to ethernet quicker)
# Add physical device enp0s31f6 as a slave to the br0 bridge.
# (Delete added just in case one of br0 or br0-slave doesnt exist)
set_up_bridge() {
  local connections
  connections=$(nmcli -t -f NAME con show)

  if ! grep -qx "$BRIDGE_NAME" <<<"$connections" ||
    ! grep -qx "${BRIDGE_NAME}-slave" <<<"$connections"; then

    nmcli con delete "$BRIDGE_NAME" 2>/dev/null || true
    nmcli con delete "${BRIDGE_NAME}-slave" 2>/dev/null || true

    nmcli con add type bridge \
      ifname "$BRIDGE_NAME" \
      con-name "$BRIDGE_NAME" \
      bridge.stp no bridge.forward-delay 0

    nmcli con add type bridge-slave \
      ifname "$ETHERNET_INTERFACE" \
      master "$BRIDGE_NAME" \
      con-name "${BRIDGE_NAME}-slave"
  fi
}

is_wifi_enabled() {
  [[ "$(nmcli -t -f WIFI radio)" == "enabled" ]]
}

wifi_up() {
  echo "WIFI connected to $WIFI_CONNECTION..."
  nmcli con down "$BRIDGE_NAME" &>/dev/null || true
  nmcli radio wifi on
}

ethernet_up() {
  echo "Ethernet connected to $ETHERNET_INTERFACE..."
  nmcli radio wifi off
  nmcli con up "${BRIDGE_NAME}-slave" &>/dev/null || true
  nmcli con up "$BRIDGE_NAME" &>/dev/null || true
}

# The 'carrier' file contains 1 if link is up, 0 if down/unplugged.
# Inside the while loop, you will enter one of the branches only one time and then
# nothing will happen until get_ethernet_status state changes (cable plugged/unplugged).
toggle_interfaces() {
  local get_ethernet_status
  get_ethernet_status=$(cat "/sys/class/net/${ETHERNET_INTERFACE}/carrier" \
    2>/dev/null || echo 0)

  if [[ "$get_ethernet_status" == "0" ]] &&
    ! is_wifi_enabled; then
    wifi_up
  elif [[ "$get_ethernet_status" == "1" ]] &&
    is_wifi_enabled; then
    ethernet_up
  fi
}

cleanup() {
  nmcli radio wifi on
}

main() {
  trap cleanup SIGINT SIGTERM
  set_up_bridge

  while true; do
    toggle_interfaces
    sleep "$POLL_INTERVAL"
  done
}
main
