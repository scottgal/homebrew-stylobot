class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.3.1"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "cee83c3c79e50156d16db5d08ce4a801f34461473a7ba5aefcd4b66aa538cc3d"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "d589a78a09c253afed0961e4809fb2af06e01e8567c2bf13fe4a2adc952dd26c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "201408303fe0c431b3afa20f985824eb1143ce94caad34533066bbb479a50d71"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "81bfad4d52873c7ac1abff67288931135a2d755e4d70e847c66d493e8dbbbb7a"
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
