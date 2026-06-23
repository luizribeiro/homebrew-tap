class Evalon < Formula
  desc "Run sandboxed Luau workflows in microVMs, with built-in coding agents"
  homepage "https://github.com/luizribeiro/lab/tree/main/evalon"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.1/evalon-macos-arm64.tar.xz"
      sha256 "c6662705f99cbdd528b3fcf1067490b604e578315275185385d18d417d968e29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.1/evalon-linux-aarch64.tar.xz"
      sha256 "7c24bddfbea91697dfb0a5311d3425959bf1b53c1a0dd65e6f43394484bfbdec"
    end
    on_intel do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.1/evalon-linux-x86_64.tar.xz"
      sha256 "107989d5cf40d85d6442b3eb5104c9d4d301239cc96dc2a2010590582f5a0fae"
    end
  end

  def install
    # The bundle is a relocatable tree (bin/ libexec/ lib/ share/); evalon finds
    # its kernel, initramfs, and the libkrun dylib closure by paths relative to
    # its own binary, so the layout must be preserved verbatim under the keg.
    prefix.install Dir["*"]
  end

  test do
    assert_match "evalon", shell_output("#{bin}/evalon --help 2>&1")
  end
end
