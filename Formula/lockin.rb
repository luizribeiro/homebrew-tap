class Lockin < Formula
  desc "Build and run a child process inside an OS sandbox (Linux: syd, macOS: sandbox-exec)."
  homepage "https://github.com/luizribeiro/lab/tree/main/lockin"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.4.0/lockin-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1f825a1b835a82ec82269b6c430f943281d6b631da1bde73754a50e1c3a4fc1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.4.0/lockin-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8ca0da526012ad0f95af6df456fe894f46aec6db13b1e184bfa15055d61501a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.4.0/lockin-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "538559ad80939931bde114d8826955fd40f09fce36a5de6a6fdc7a020ae98ed8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.4.0/lockin-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7d9fd32081c8909e2c6cb0ae5182875dd507f4e046131d9485378d7e231e496"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lockin" if OS.mac? && Hardware::CPU.arm?
    bin.install "lockin" if OS.mac? && Hardware::CPU.intel?
    bin.install "lockin" if OS.linux? && Hardware::CPU.arm?
    bin.install "lockin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
