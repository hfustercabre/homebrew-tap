# Homebrew cask for AutoHush: https://github.com/hfustercabre/AutoHush
#
#   brew install --cask hfustercabre/tap/autohush
#
# AutoHush's Scripts/update-tap.sh sets version and sha256 for each release.
cask "autohush" do
  version "0.6.1"
  sha256 "7e3634735d805aa82bc71b4fe211bc8f765f76a786d0859e9de9f80e294fb251"

  url "https://github.com/hfustercabre/AutoHush/releases/download/v#{version}/AutoHush-#{version}.dmg"
  name "AutoHush"
  desc "Pauses your music while other apps play audio and resumes it afterwards"
  homepage "https://github.com/hfustercabre/AutoHush"

  # AutoHush installs its own updates, so `brew upgrade` leaves it alone
  # (unless --greedy).
  auto_updates true
  depends_on macos: :sequoia

  app "AutoHush.app"

  # AutoHush is signed with its own certificate but not notarized by Apple,
  # so Gatekeeper would block the first launch. Installing from this tap is the
  # user's decision to trust it; drop the download quarantine accordingly.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AutoHush.app"]
  end

  uninstall quit: "com.autohush.AutoHush"

  zap trash: [
    "~/Library/Caches/com.autohush.AutoHush",
    "~/Library/HTTPStorages/com.autohush.AutoHush",
    "~/Library/Preferences/com.autohush.AutoHush.plist",
  ]

  caveats <<~EOS
    AutoHush is not notarized by Apple; this cask removes the download
    quarantine so it opens normally.

    On first launch, choose your music player (Spotify, Apple Music or TIDAL),
    then allow Automation (Accessibility for TIDAL) to control it, and System
    Audio Recording to measure how loud other apps are, when macOS asks.
  EOS
end
