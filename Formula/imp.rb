class Imp < Formula
  desc "An extremely minimal coding-agent CLI."
  homepage "https://github.com/luizribeiro/lab/tree/main/imp"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/imp-v0.0.1/imp-aarch64-apple-darwin.tar.xz"
      sha256 "36bd3bde936f3d08f6f1c0a4275f2ebf5215d7f4bbe4f3c9caba9d4cfaa9baac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/imp-v0.0.1/imp-x86_64-apple-darwin.tar.xz"
      sha256 "05cb741b0df9cce692f68e2b9b985a6e6a45eddf6b6bc88a2e9ef021566f164a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "imp" if OS.mac? && Hardware::CPU.arm?
    bin.install "imp" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
