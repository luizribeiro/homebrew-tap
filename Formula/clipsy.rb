class Clipsy < Formula
  desc "Sync your clipboard across hosts"
  homepage "https://github.com/luizribeiro/clipsy"
  url "https://github.com/luizribeiro/clipsy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f69bbc1a1e013f779901724f3bac815df6c3b7a4b86c19d9bd093e354a9ee796"
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
