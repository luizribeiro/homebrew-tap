class Scope < Formula
  desc "Non-interactive CLI web browser for AI agents (search, read URLs as markdown)."
  homepage "https://github.com/luizribeiro/lab/tree/main/scope"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.1/scope-aarch64-apple-darwin.tar.xz"
      sha256 "53a14ef9a2e3425046633a2a06f644961da3f2e0db73e949dab3da8aa125636f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.1/scope-x86_64-apple-darwin.tar.xz"
      sha256 "fcf20eca4f309af4e0b833f1a5d4cf58c534662d8ccd763c72a8db2ab4638c01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.1/scope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "58c9d85b325eb62775909ebe6d1944b00b273dad7cefedaed9f5c60180f82f08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.1/scope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfdc2aa987333811ed9b8262a8c41387abf7231107ce72df1cad1530470cc227"
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
    bin.install "scope" if OS.mac? && Hardware::CPU.arm?
    bin.install "scope" if OS.mac? && Hardware::CPU.intel?
    bin.install "scope" if OS.linux? && Hardware::CPU.arm?
    bin.install "scope" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
