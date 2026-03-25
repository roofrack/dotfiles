ethernet_interface="enp0s31f6"
wifi_connection="LilTimmy"

# # Create the bridge br0 (disable stp so switches to ethernet quicker)
# NOTE: Add your physical device enp0s31f6 as a slave to the br0 bridge.
set_up_bridge() {
  if ! nmcli -t connection | grep -q -E "^br0|^br0-slave"; then
    nmcli connection delete br0 br0-slave &>/dev/null
    nmcli con add type bridge ifname br0 con-name br0 bridge.stp no bridge.forward-delay 0
    nmcli con add type bridge-slave ifname "$ethernet_interface" master br0 con-name br0-slave
  fi
}

# 1. Cable unplugged to get wifi...
#     Is the wifi radio already off at this point?
#     IT should already be off! So if its off than need a test to show off!
#     - nmcli radio wifi on
#     - This only needs to be run if wifi radio is off so while loop doesnt keep running commands inside if statement.
wifi_up() {
  if nmcli radio wifi | grep -q disabled; then
    echo "WIFI connected to $wifi_connection."
    nmcli connection down br0 &>/dev/null
    nmcli radio wifi on
  fi
}

# 2. Wifi on and cable plugged in to get ethernet...
#     - turn nmcli radio wifi off
#     - This only needs to run if wifi radio is on.
#     - Not sure if need to bring br0 and br0-slave up?
# NOTE: Bring up slave connection before bridge.
# Seems to work with just bringing up the slave connection.
ethernet_up() {
  if nmcli radio wifi | grep -q enabled; then
    echo "Wired connection via $ethernet_interface."
    nmcli radio wifi off
    nmcli connection up br0-slave
    # nmcli connection up br0
  fi
}

# Function to check the link status using `cat /sys/class/net/$INTERFACE/carrier`
# The 'carrier' file contains 1 if link is up, 0 if down/unplugged
check_link_status() {
  if [[ -e "/sys/class/net/$ethernet_interface/carrier" ]]; then
    cat "/sys/class/net/$ethernet_interface/carrier"
  else
    # Interface might not exist or system uses a different path
    echo 0
  fi
}

# Main loop to monitor the status
main() {
  while true; do
    STATUS=$(check_link_status)
    if [[ "$STATUS" == "0" ]]; then
      wifi_up
    elif [[ "$STATUS" == "1" ]]; then
      ethernet_up
    fi
    # Sleep for a short interval before checking again
    sleep 2
  done
}
main
