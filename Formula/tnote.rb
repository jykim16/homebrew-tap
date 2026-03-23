class Tnote < Formula
  desc "Terminal Notepad"
  homepage "https://github.com/jykim16/tnote"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.0/tnote-aarch64-apple-darwin.tar.xz"
      sha256 "e9932bf7b2f07cf7fc41cb0bed76e51a7c2be7ea785551dd70971d1c13583adc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.0/tnote-x86_64-apple-darwin.tar.xz"
      sha256 "a7bf65fa4576aa26c76ef1f132b575fd33ffa6122ab9ea13d6ac2d4d684b7761"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.0/tnote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf0792b0e1776e4a775278d15a6cdbb03ff012a9fbbb6073511bd87fc44bb0b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.0/tnote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "59daf822ab2ed62da9a68419adfb1eeedbf7d73ff8f045f03fbb29a2c98025e4"
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
