#!/bin/bash
# Minimal autostart for dwm on Void Linux
# --------------------------
# Status bar
# --------------------------
~/.dwm/status-clock.sh &

# --------------------------
# Compositor
# --------------------------
if ! pgrep -x picom >/dev/null; then
    picom --config ~/.config/picom/picom.conf &
fi

# --------------------------
# Audio daemons (PipeWire + WirePlumber)
# --------------------------
# Ensure runtime dir exists
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Start PipeWire if not already running
if ! pgrep -x pipewire >/dev/null; then
    pipewire &
fi

# Give the main PipeWire daemon a moment to initialize
sleep 1

# Start PulseAudio compatibility layer
if ! pgrep -x pipewire-pulse >/dev/null; then
    pipewire-pulse &
fi

# Start WirePlumber session manager
if ! pgrep -x wireplumber >/dev/null; then
    wireplumber &
fi
