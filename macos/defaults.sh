#!/usr/bin/env bash
# Idempotent macOS preference tweaks used by setup.sh.
# Safe to re-run. Skip with: SKIP_MACOS_DEFAULTS=1 ./setup.sh
set -euo pipefail

log() { printf '==> %s\n' "$*"; }

log "macOS defaults (trackpad)"

# Tap to click (built-in + Bluetooth trackpads)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Faster tracking speed (0.0–3.0; default is ~1.0)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0

# Three Finger Drag (Accessibility → Pointer Control → Trackpad Options)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool false
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false

# Apply immediately when available (no logout)
if [[ -x /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings ]]; then
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
fi

log "macOS defaults applied (log out/in if a setting doesn’t take effect)"
