class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.2.7"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "74dfccdb1340a8eaf9cd5d0e81bc147f5dd4bbc406245e5f009f24509166f4de"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "a49bd1f6fa57fb2e3bc82b0ba69a0aaf0515f50ace427cf3ac22453f7b2fc794"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "5e5d313746c0b189369c86f7a6c9de5decf2cdbac099f0327e26dd0c06f673e8"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "c7b013a0e963649c160a892dd53cdda9c808e66a2efa844fbfa1abb9a5dbdb90"
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
