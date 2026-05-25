class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.8.5"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "e6b103dbadecf420d5045fbda27f7ac7a8eeab2d76c68b49b12bad7ac24a11b3"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "04e8adf1a8b7d87ba2f83cc17d8db983a33821311d12d83e6edc1139bd13aeef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "e52a130d13140afe2389dcf1d8e7a10e5245c7ad47f2fcc19f672ab5463a403b"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "bfb90b1d6ba4fbfb378cb180e92bf0ad92f8caf78d51c2ffd5b013355f8c8c10"
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
