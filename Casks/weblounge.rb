cask "weblounge" do
  version "0.1.0"
  sha256 "519491040cdd63d26c502d12e0e39a984a175aa68e3924c71b9429c1b7645d42"

  url "https://github.com/luizribeiro/weblounge-client/releases/download/desktop-v#{version}/weblounge-#{version}.dmg"
  name "weblounge"
  desc "IRCv3 chat client"
  homepage "https://beta.weblounge.org/"

  livecheck do
    url :url
    regex(/^desktop-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64

  app "weblounge.app"

  zap trash: [
    "~/Library/Application Support/org.weblounge.desktop",
    "~/Library/Caches/org.weblounge.desktop",
    "~/Library/HTTPStorages/org.weblounge.desktop.binarycookies",
    "~/Library/LaunchAgents/weblounge.plist",
    "~/Library/Preferences/org.weblounge.desktop.plist",
    "~/Library/WebKit/org.weblounge.desktop",
  ]
end
