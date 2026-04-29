class Lockin < Formula
  desc "Build and run a child process inside an OS sandbox (Linux: syd, macOS: sandbox-exec)."
  homepage "https://github.com/luizribeiro/lab/tree/main/lockin"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.2/lockin-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8c298d8847307dab2b3e2a2925fa97172c46cb0c28869696321623b8ce6b4c90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.2/lockin-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3a20aa9f7030a34c0bb1281165b4e726c6285f80ddb9ed112c085c510f26e620"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.2/lockin-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "91fe51728540e90712262dffe8a3db5c3663d6d757c47bb45d92c3d4ace0d60e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.2/lockin-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b0e53e469d5219d2ba9df015c83da64bd44fcad6d93d78f7cf754795e400fabf"
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
