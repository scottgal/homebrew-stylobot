class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "5.6.5"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "f4c74d2206278798ea0e5c797ee377983a2e455df722ad1b50b417c37fc01374"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "bf9de84b27d4fa3f009cb12f8039a64cd8161fab46c20fa72df5a4a1c9ab6c4b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "55be90cd02a0809d937b30525bf5c263412dd6526a2102d8c2c0d0d0a7f21b94"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "9aa449183ea4fa948f3e44cb859ff7bf0a852c67b40420497584169d14f44153"
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
