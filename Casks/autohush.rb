# Homebrew cask for AutoHush: https://github.com/hfustercabre/AutoHush
#
#   brew install --cask hfustercabre/tap/autohush
#
# AutoHush's Scripts/update-tap.sh sets version and sha256 for each release.
cask "autohush" do
  version "0.11.0"
  sha256 "b99187b72bbecbf0b98d628319b7567adf454f398272a2641f8f78f55df9e036"

  url "https://github.com/hfustercabre/AutoHush/releases/download/v#{version}/AutoHush-#{version}.dmg"
  name "AutoHush"
  desc "Pauses music, podcasts or videos while other apps play audio, then resumes them"
  homepage "https://github.com/hfustercabre/AutoHush"

  # AutoHush installs its own updates. Homebrew 7 still lists it in
  # `brew outdated` and upgrades it with `brew upgrade`.
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

    On first launch, choose your music player (Spotify, Apple Music, VLC,
    Apple Podcasts, TIDAL or a Safari web app), then allow Automation
    (Accessibility for Apple Podcasts, TIDAL and Safari web apps) to control
    it, and System Audio Recording to measure how loud other apps are, when
    macOS asks.
  EOS
end
