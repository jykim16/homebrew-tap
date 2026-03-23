class Tnote < Formula
  desc "Terminal Notepad"
  homepage "https://github.com/jykim16/tnote"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.2/tnote-aarch64-apple-darwin.tar.xz"
      sha256 "83c72c1e06caa6c381dcd1c6e1fa17eff24942be6754dc9b21cdd42ff53af377"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.2/tnote-x86_64-apple-darwin.tar.xz"
      sha256 "06ee62a9ca9657985aa3b47f93a65fc0562f70f66fc92b6132bede5fbb7c4ac5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.2/tnote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5113974c4f9044af39e4d67495a2d1afd424428df33cbab13d8d4cf06d9168a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.2/tnote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b1f4cbdaa493cd09e809444cddce7f70cc3d339241dbfcb0d81150418a1d316"
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
