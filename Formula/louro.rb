class Louro < Formula
  desc "Let any coding agent act as an IRC bot"
  homepage "https://github.com/luizribeiro/louro"
  url "https://github.com/luizribeiro/louro/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0a60cc9cebd319e4a3ebc887debab1e488b40185f28b2f744837f5d89338a124"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/luizribeiro/louro.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    # Hardened runtime, so a same-user process can't read the password from louro's memory
    system "codesign", "--force", "--sign", "-", "--options", "runtime", bin/"louro" if OS.mac?
  end

  test do
    assert_match "louro #{version}", shell_output("#{bin}/louro --version")
    assert_match "runtime", shell_output("codesign --display --verbose #{bin}/louro 2>&1") if OS.mac?
  end
end
