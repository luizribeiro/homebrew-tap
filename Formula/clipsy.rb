class Clipsy < Formula
  desc "Sync your clipboard across hosts"
  homepage "https://github.com/luizribeiro/clipsy"
  url "https://github.com/luizribeiro/clipsy/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4b13535cbeceb362dad1c4c5caae1105e08e10489ea0e7a448c87aaf86dbb83c"
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
