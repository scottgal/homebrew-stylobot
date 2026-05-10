class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.3.8"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "42f29af887c7702de0552b4c496e0fbf2567c8d297e3e2ab62aa71f9483da97b"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "28bcf4b3730310c81aa837f897359be8a75904764adb2682aac077989a2fa19c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "dd01cf827f4f1c543b3e458e05308fc5382bc7edabbc51045600fc1caf3eb3e0"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "d0186e63568333eb81ca6f755e7899ae93a3509cbf71190d11e4fa2ce63d1961"
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
