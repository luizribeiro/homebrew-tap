class Clipsy < Formula
  desc "Sync your clipboard across hosts"
  homepage "https://github.com/luizribeiro/clipsy"
  url "https://github.com/luizribeiro/clipsy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/luizribeiro/clipsy.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"clipsy", "serve"]
    keep_alive true
    process_type :interactive
    log_path var/"log/clipsy.log"
    error_log_path var/"log/clipsy.log"
  end

  test do
    assert_match "clipsy #{version}", shell_output("#{bin}/clipsy --version")
  end
end
