class Tnote < Formula
  desc "Terminal Notepad"
  homepage "https://github.com/jykim16/tnote"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.6/tnote-aarch64-apple-darwin.tar.xz"
      sha256 "5ac278156a8ea8abea9bf413f1cb942760f96a2ba2f23b7a65b2b71d8406cffe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.6/tnote-x86_64-apple-darwin.tar.xz"
      sha256 "903e2200ed6f1e642df18837cdbf839889e637cde56b6cf17e082f574c50692a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.6/tnote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "075b9d01b569def8e50d4467c06c09448329f1bb698026179858d5d44ef8c036"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.6/tnote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ac92e87541af6e91fe2968e3a306605162cddd604196e96821a664d9514ca73"
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
