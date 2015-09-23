#!/usr/bin/env bash

fancy_echo() {
  local fmt="$1"; shift
  printf " $fmt\n" "$@"
}

echo
fancy_echo "Welcome."
echo
fancy_echo "We're going to get you fixed up nice."
fancy_echo "Just.. tell us your seeeeecrets.."

# Ask for the administrator password up front
sudo -v

# Keep-alive: update existing sudo time stamp until .osx has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Optional Stuff                                                              #
###############################################################################
echo

change_name() {
  # Set computer name (as done via System Preferences → Sharing)
  read -p "What should we set the name to? " val
  sudo scutil --set ComputerName $val
  sudo scutil --set HostName $val
  sudo scutil --set LocalHostName $val
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $val
}

read -p "Want to change the computer's name? (y/n) " yn
case $yn in
  [Yy]* ) change_name;;
esac

# see also: lscleanup alias
read -p "Want to kill duplicates in Open With? (y/n) " yn
case $yn in
  [Yy]* ) /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user;;
esac

read -p "Want to wipe all app icons from the Dock? (y/n) " yn
case $yn in
  [Yy]* ) defaults write com.apple.dock persistent-apps -array
esac

read -p "Want a mind-blowingly fast keyboard repeat rate? (y/n) " yn
case $yn in
  [Yy]* ) defaults write NSGlobalDomain KeyRepeat -int 0
esac

read -p "Show hidden files in the Finder? (y/n) " yn
case $yn in
  [Yy]* ) defaults write com.apple.finder AppleShowAllFiles -bool true
esac

read -p "Disable Help Viewer windows floating? (y/n) " yn
case $yn in
  [Yy]* ) defaults write com.apple.helpviewer DevMode -bool true
esac

read -p "Allow quitting the Finder with ⌘ Q? (y/n) " yn
case $yn in
  [Yy]* ) defaults write com.apple.finder QuitMenuItem -bool true
esac

###############################################################################
# General UI/UX                                                               #
###############################################################################
echo

fancy_echo "UI/UX: Setting up menu bar items"
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/User.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"

fancy_echo "UI/UX: Setting highlight color to Graphite"
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"

fancy_echo "UI/UX: Setting sidebar icon size to large"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3

fancy_echo "UI/UX: Increasing window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

fancy_echo "UI/UX: Expanding save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

fancy_echo "UI/UX: Expanding print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

fancy_echo "UI/UX: Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

fancy_echo "UI/UX: Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

fancy_echo "UI/UX: Enabling Resume system-wide"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool true

fancy_echo "UI/UX: Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

fancy_echo "UI/UX: Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

fancy_echo "UI/UX: Disabling smart quotes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

fancy_echo "UI/UX: Disabling smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

fancy_echo "UI/UX: Enabling ctrl-scroll to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

fancy_echo "UI/UX: Following the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

echo
fancy_echo "Trackpad: enabling tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo
fancy_echo "Bluetooth: Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo
fancy_echo "Keyboard: Enabling full keyboard access"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

fancy_echo "Keyboard: Disabling press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

fancy_echo "Keyboard: Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Finder                                                                      #
###############################################################################
echo

fancy_echo "Finder: Disabling window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

fancy_echo "Finder: Setting Home folder as the default location for new Finder windows"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

fancy_echo "Finder: Showing icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

fancy_echo "Finder: showing all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

fancy_echo "Finder: showing status bar"
defaults write com.apple.finder ShowStatusBar -bool true

fancy_echo "Finder: showing path bar"
defaults write com.apple.finder ShowPathbar -bool true

fancy_echo "Finder: allowing text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

fancy_echo "Finder: When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

fancy_echo "Finder: Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

fancy_echo "Finder: Enabling spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

fancy_echo "Finder: Removing the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

fancy_echo "Finder: Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

fancy_echo "Finder: Disabling disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

fancy_echo "Finder: Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

fancy_echo "Finder: Showing item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

fancy_echo "Finder: Sort icon views by kind"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

fancy_echo "Finder: Increasing grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

fancy_echo "Finder: Increasing the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

fancy_echo "Finder: Nuking the motherfucking toolbar!"
defaults write com.apple.finder 'NSToolbar Configuration Browser.TB Item Identifiers' -array
defaults write com.apple.finder 'NSToolbar Configuration Browser.TB Icon Size Mode' -int 1
defaults write com.apple.finder 'NSToolbar Configuration Browser.TB Size Mode' -int 1
defaults write com.apple.finder 'NSToolbar Configuration Browser.TB Display Mode' -int 3

fancy_echo "Finder: Fuck tags"
defaults write com.apple.finder ShowRecentTags -bool false

fancy_echo "Finder: Using column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

fancy_echo "Finder: OH HAI ~/Library FOLDER"
chflags nohidden ~/Library

fancy_echo "Finder: Expanding the good File Info panes: General, Open With, Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
echo

fancy_echo "Dock: Setting the icon size of Dock items"
defaults write com.apple.dock tilesize -int 72

fancy_echo "Dock: Changing minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "suck"

fancy_echo "Dock: Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

fancy_echo "Dock: Making Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo
fancy_echo "Dashboard: FUCK OFF DASHBOARD"
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

echo
fancy_echo "Spaces: Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo
fancy_echo "Launchpad: Adding iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
echo

fancy_echo "Safari: Showing the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

fancy_echo "Safari: Setting Safari's home page"
defaults write com.apple.Safari HomePage -string ""

fancy_echo "Safari: Prevent Safari from opening 'safe' files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

fancy_echo "Safari: Hiding Safari's bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

fancy_echo "Safari: Hiding Safari's sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

fancy_echo "Safari: Enabling Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

fancy_echo "Safari: Making Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

fancy_echo "Safari: Removing useless icons from Safari's bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

fancy_echo "Safari: Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

fancy_echo "Safari: Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################
echo

fancy_echo "Time Machine: Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################
echo

fancy_echo "Activity Monitor: Showing the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

fancy_echo "Activity Monitor: Showing all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

fancy_echo "Activity Monitor: Sorting Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# TextEdit, and Disk Utility                                                  #
###############################################################################
echo

fancy_echo "TextEdit: Using plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

fancy_echo "TextEdit: Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo
fancy_echo "Disk Utility: Enabling the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
echo

fancy_echo "Messages: Disabling automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

fancy_echo "Messages: Disabling smart quotes as it's annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

fancy_echo "Messages: Disabling continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false


###############################################################################
# Terminal                                                                    #
###############################################################################
echo

fancy_echo "Terminal: Only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

fancy_echo "Terminal: Use a modified version of the Solarized Dark theme by default"
osascript <<EOD
tell application "Terminal"
	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Pro"
	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window
	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName
	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window
	repeat with windowID in allOpenedWindows
		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)
		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if
	end repeat
end tell
EOD

fancy_echo "Terminal: Enable focus follows mouse (hover over a window and start typing in it without clicking first)"
defaults write com.apple.terminal FocusFollowsMouse -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################
echo

fancy_echo "KILLING EVERY LAST MOTHERFUCKER IN THE ROOM"

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Messages" "Safari" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

echo
fancy_echo "Now, stuff you need to do manually:"
fancy_echo "Would you kindly: Set the Terminal Pro theme to use Inconsolata 16pt."
fancy_echo "Would you kindly: Logout/restart for some earlier changes to take effect."
