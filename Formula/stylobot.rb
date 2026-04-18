class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "5.6.8"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "79c82a5c459a5e1417a0918dc5dcb8b70a636852e289d9ff00b8bd83bc1d64d6"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "aa4c2f90f316c7cf17ddb19fe9688a7eeb5f40549adb175cef974e5b26c21cf7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "c4ac3dc78e979a7d0ab76cbf8a2b5f3a588b8aa0e6fd603434c44dc5be47e840"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "5660d21c1e9b9ff4e16c3dae96dc3c290930f6d8730bba477b68811cc775a5ca"
    end
  end

  def install
    # Everything must be co-located: binary, native libs, and config
    # .NET looks for appsettings.json relative to AppContext.BaseDirectory
    libexec.install Dir["*"]
    # Wrapper script that cd's to libexec before running
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
      StyloBot Community Edition installed!

        stylobot 5080 http://localhost:3000         # Interactive (live table)
        stylobot start 5080 http://localhost:3000   # Background daemon
        stylobot stop                                # Stop daemon
        stylobot status                              # Check daemon
        stylobot --help                              # All options

      Or use Homebrew services:
        brew services start stylobot                 # Start as launchd service
        brew services stop stylobot                  # Stop service

      For Cloudflare Tunnel: brew install cloudflared

      Config: #{libexec}/appsettings.json
      Dashboard: http://localhost:5080/_stylobot
      Docs: https://github.com/scottgal/stylobot
    EOS
  end

  test do
    assert_predicate bin/"stylobot", :executable?
  end
end
