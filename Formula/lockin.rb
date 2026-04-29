class Lockin < Formula
  desc "Build and run a child process inside an OS sandbox (Linux: syd, macOS: sandbox-exec)."
  homepage "https://github.com/luizribeiro/lab/tree/main/lockin"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.2.0/lockin-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5cef84efbd632ca67f73e07924254652857c4380e3e894b9334e7fb7e27c87fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.2.0/lockin-cli-x86_64-apple-darwin.tar.xz"
      sha256 "28376b89200f93f15e0abd1c6cd70ab95bc9c89b368f31d9bc943fce57f6ff5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.2.0/lockin-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70acf00912cceb0195f90b8287fcaccb83a6706e0b149ab0788f350894641652"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.2.0/lockin-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ef1961caf9c19166c2a8da6530e9e1d6995ec61bf8f04c60e123dc2d39a000e"
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
