# Homebrew cask for AutoHush: https://github.com/hfustercabre/AutoHush
#
#   brew install --cask hfustercabre/tap/autohush
#
# AutoHush's Scripts/update-tap.sh sets version and sha256 for each release.
cask "autohush" do
  version "1.1.0"
  sha256 "9595c4ae9483aaaac84339ff3a3b33e16dc6e3e63ed02c6e42a873112cc4e5c7"

  url "https://github.com/hfustercabre/AutoHush/releases/download/v#{version}/AutoHush-#{version}.dmg"
  name "AutoHush"
  desc "Pauses music, podcasts or videos while other apps play audio, then resumes them"
  homepage "https://github.com/hfustercabre/AutoHush"

  # AutoHush installs its own updates. Homebrew 7 still lists it in
  # `brew outdated` and upgrades it with `brew upgrade`.
  auto_updates true
  depends_on macos: :sonoma

  app "AutoHush.app"

  # AutoHush is signed by its developer team but not notarized by Apple,
  # so Gatekeeper would block the first launch. Installing from this tap is the
  # user's decision to trust it; drop the download quarantine accordingly.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AutoHush.app"]
  end

  uninstall quit: "com.autohush.AutoHush"

  zap trash: [
    "~/Library/Caches/com.autohush.AutoHush",
    "~/Library/HTTPStorages/com.autohush.AutoHush",
    "~/Library/Logs/AutoHush",
    "~/Library/Preferences/com.autohush.AutoHush.plist",
  ]

  caveats <<~EOS
    AutoHush is not notarized by Apple; this cask removes the download
    quarantine so it opens normally.

    On first launch, choose your media player (Spotify, Apple Music, VLC,
    Apple Podcasts, TIDAL, QuickTime Player, a Safari web app, or another
    app checked with Add an App), then allow Automation (Accessibility for
    Apple Podcasts, TIDAL, Safari web apps and added apps) to control it,
    and Audio Recording to measure how loud other apps are, when macOS asks.
  EOS
end
