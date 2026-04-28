class Lockin < Formula
  desc "Build and run a child process inside an OS sandbox (Linux: syd, macOS: sandbox-exec)."
  homepage "https://github.com/luizribeiro/lab/tree/main/lockin"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.1.0/lockin-cli-aarch64-apple-darwin.tar.xz"
      sha256 "781a456d8147db0f5a38653a4e88f72e8bbce89f417bd2035f837fd9cd79371c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.1.0/lockin-cli-x86_64-apple-darwin.tar.xz"
      sha256 "df0c7305a29c3fca2a94e69b2f2244bce6be9d27ae9ca97e72b92a6e3ae9c69e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.1.0/lockin-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5d27dca49c789aaa79c9ac4279388ba407b51d3c5776ae5e9193a8164dca061"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.1.0/lockin-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94142ad90b916ce183bf550b56281e2b088aff2c4a02c31a7116c07f1a98bee0"
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
