cask "weblounge" do
  version "0.1.3"
  sha256 "6943ef74d5096fe52c0e0739a4967097768f967e338fe2f0e32d3ff129e66125"

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
  depends_on :macos

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
