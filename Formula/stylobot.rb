class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.2.0"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "fb25ca38c240379ca6a3be5fa1a97bfe0a8fc96465a2bdf3b86b7f4ef4e70cda"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "41b36fe2a9724dc4602ecd29e3f3017f61ec81d286ade9761f07be921b3393a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "28c8cf6af728ab322edf7ef32e9f7dcc58321f8fb5edcfc042c14e6597618770"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "75ac853c055a96259ee485bcf6d017fd1d50ae45e46977007281126ec257cdf5"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"stylobot").write <<~EOS
      #!/bin/bash
      cd "#{libexec}" && exec ./stylobot "$@"
    EOS
  end

  service do
    run [opt_bin/"stylobot", "5080", "http://localhost:3000", "--mode", "production", "--verbose"]
    keep_alive true
    log_path var/"log/stylobot/stylobot.log"
    error_log_path var/"log/stylobot/stylobot.error.log"
    working_dir var/"lib/stylobot"
  end

  def post_install
    (var/"lib/stylobot").mkpath
    (var/"log/stylobot").mkpath
  end

  def caveats
    <<~EOS
      StyloBot installed. Free forever. No license required.

        stylobot 5080 http://localhost:3000         # Interactive (live table)
        stylobot start 5080 http://localhost:3000   # Background daemon
        stylobot stop                                # Stop daemon
        stylobot --help                              # All options

      Homebrew services:
        brew services start stylobot                 # Start as launchd service
        brew services stop stylobot                  # Stop service

      Cloudflare Tunnel: brew install cloudflared
      Docs: https://github.com/scottgal/stylobot
    EOS
  end

  test do
    assert_predicate bin/"stylobot", :executable?
  end
end
