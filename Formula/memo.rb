class Memo < Formula
  desc "Apple Reminders from the command line, from MCP clients, or over HTTP."
  homepage "https://github.com/luizribeiro/lab/tree/main/memo"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/luizribeiro/lab/releases/download/memo-v0.3.2/memo-aarch64-apple-darwin.tar.xz"
      sha256 "431f08653377d8b73741798cbb462bee2e3a4bfe7afab45e3e5dc16ddea824d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/luizribeiro/lab/releases/download/memo-v0.3.2/memo-x86_64-apple-darwin.tar.xz"
      sha256 "9e76f5e573c54f4c6d2a0fa7c994e63da0f491b0335810668a7346da5e5d55c1"
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
    bin.install "memo" if OS.mac? && Hardware::CPU.arm?
    bin.install "memo" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
