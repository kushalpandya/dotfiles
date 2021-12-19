#!/usr/bin/env bash

# Apps to put in dock
apps=(
  "/System/Applications/Launchpad.app"
  "/System/Applications/App Store.app"
  "/System/Applications/System Preferences.app"
  "/System/Applications/Music.app"
  "/Applications/Spotify.app"
  "/Applications/Pixelmator Pro.app"
  "/Applications/KeePassXC.app"
  "/Applications/Slack.app"
  "/Applications/Safari.app"
  "/Applications/Microsoft Edge.app"
  "/Applications/Opera.app"
  "/Applications/Firefox.app"
  "/Applications/Google Chrome.app"
  "/Applications/iTerm.app"
  "/Applications/Visual Studio Code.app"
)

# Remove all existing app launchers
dockutil --remove all

# Add apps to Dock
for app in "${apps[@]}"; do
  echo "Adding $app to dock"
  dockutil --add "$app" --section apps
done

# Add Downloads folder
echo "Adding '~/Downloads' to dock"
dockutil --add '~/Downloads' --view list --display folder

echo "Adding spacers"
dockutil --add '' --type spacer --section apps --before "Launchpad"
sleep 1
dockutil --add '' --type spacer --section apps --after "System Preferences"
sleep 1
dockutil --add '' --type spacer --section apps --after "Slack"
sleep 1
dockutil --add '' --type spacer --section apps --after "Google Chrome"
sleep 1

# Configure Dock preferences
# Set icon size
defaults write com.apple.dock "tilesize" -int "54"
# Do not show recent apps
defaults write com.apple.dock "show-recents" -bool "false"

# Restart Dock
echo "Restarting Dock..."
killall Dock
