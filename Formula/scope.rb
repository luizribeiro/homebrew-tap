class Scope < Formula
  desc "Non-interactive CLI web browser for AI agents (search, read URLs as markdown)."
  homepage "https://github.com/luizribeiro/lab/tree/main/scope"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.2/scope-aarch64-apple-darwin.tar.xz"
      sha256 "e84b2700a329bd8214e496df6248d96e56141e85848ee1bb907e425f1eacdd8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.2/scope-x86_64-apple-darwin.tar.xz"
      sha256 "5bc9a5cfdd7d6868b2329d35646b2fe2a4f74824ff78026ff05c786057d11a2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.2/scope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30dc403c5e8d0c3f98aea6c5b728f35be003002a9f640d8087c00fd53a9841e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/scope-v0.1.2/scope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fbc28e7f4fc02c97953b98c416cd91a1ff2935a1f5cf56e8bddd8d377ef03e8f"
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
