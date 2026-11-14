cask "weblounge" do
  version "0.1.1"
  sha256 "47bf40c74326880e08a824545585a0b9b4e530f70be8e35cc3b9f97255cdeae4"

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
