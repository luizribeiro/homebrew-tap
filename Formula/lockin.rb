class Lockin < Formula
  desc "Build and run a child process inside an OS sandbox (Linux: syd, macOS: sandbox-exec)."
  homepage "https://github.com/luizribeiro/lab/tree/main/lockin"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.1/lockin-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c4b21c5aa143a27c53cc56609e8a507d40d17ead703e8e005255f81a3b5e0619"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.1/lockin-cli-x86_64-apple-darwin.tar.xz"
      sha256 "747598d87abedd31293dfd178ceb865ecc79d5b1c61689c22e00077eb7634a88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.1/lockin-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cee7634e38daec302ebcb0068a551b6d2b478f6f7fb26670a6671cf8c0c42766"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/lockin-cli-v0.3.1/lockin-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2786efafbbc624992ea0a2ac59e17a3d608a09d940e9f830d6594fe948e12a9"
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
