class Evalon < Formula
  desc "Run sandboxed Luau workflows in microVMs, with built-in coding agents"
  homepage "https://github.com/luizribeiro/lab/tree/main/evalon"
  version "0.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.2/evalon-macos-arm64.tar.xz"
      sha256 "e5bbb21151a6183b234d7c2f9542f668ca1d951d0a040570e3c8faa6d6c742a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.2/evalon-linux-aarch64.tar.xz"
      sha256 "75d47c23ee8b5263de38e23cc1fc3c51f84b3bbcc506093b3321c1f7475c6720"
    end
    on_intel do
      url "https://github.com/luizribeiro/lab/releases/download/evalon-v0.0.2/evalon-linux-x86_64.tar.xz"
      sha256 "6dc2333db82111931998e684856b2aebdf617e390647cc7b480b969f3de32c1a"
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
