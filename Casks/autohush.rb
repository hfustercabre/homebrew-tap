# Homebrew cask for AutoHush: https://github.com/hfustercabre/AutoHush
#
#   brew install --cask hfustercabre/tap/autohush
#
# AutoHush's Scripts/update-tap.sh sets version and sha256 for each release.
cask "autohush" do
  version "0.7.0"
  sha256 "949773f5a1c35ca5819f1548db2e356a8a666b0f9f4ff74d59d4c35061951e40"

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
