class Tnote < Formula
  desc "Terminal Notepad"
  homepage "https://github.com/jykim16/tnote"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.7/tnote-aarch64-apple-darwin.tar.xz"
      sha256 "26dc7846e2232be22e0702ad30ecf4e971c4643c6e8f21e89243e681d063e75b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.7/tnote-x86_64-apple-darwin.tar.xz"
      sha256 "c00d53e156feb3f5acc7bd1e5e333e83888ea19ec193120940659a15662e2bd6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.7/tnote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "935ab914b9d4b423cbb2dc5f22d5abf5a2fb8e4a24e83a04494ff81df05acc4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jykim16/tnote/releases/download/v0.3.7/tnote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6aa3a80af6e16a1b89e6f28872747bbf46cd438c619a047bfe7c390c42c4088"
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
