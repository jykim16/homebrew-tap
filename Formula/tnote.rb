class Tnote < Formula
  desc "Terminal Notepad"
  homepage "https://github.com/jykim16/tnote"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.1/tnote-aarch64-apple-darwin.tar.xz"
      sha256 "0c4b8224e33f7b5757a9548b6bde6dd1e8508a1e8ddacd8eb795ee10aeb36bab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.1/tnote-x86_64-apple-darwin.tar.xz"
      sha256 "1d148899cc0f2328cc9a0815afe2d4c699991599a045f15e5ab58d3b1b8edac4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.1/tnote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "33128de9c90026ecaa23f8ee0afee9ff42b246aecae06a09cf54bacbc8693700"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.1/tnote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e0765824c0489db272f41cae9624ac89b0db055f295a66b2bf4e41a67824c3ca"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "tnote" if OS.mac? && Hardware::CPU.arm?
    bin.install "tnote" if OS.mac? && Hardware::CPU.intel?
    bin.install "tnote" if OS.linux? && Hardware::CPU.arm?
    bin.install "tnote" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
