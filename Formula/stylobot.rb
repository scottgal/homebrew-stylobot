class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "8.1.0"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "52e17e5c9aed29adc6b49866494a63321d79d2a529b8b0932fe0ebd6cf9de9fc"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "c35707d650b3824523546d348ce53d86e0d3c9bb92be574fd5f3ecaa78c5badd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "846b44fe93dd9257554097418b529f848ec0c055312eb982b7bd857ef3183ac0"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "1e235610f444d11640a4c5d75943cf0c72b51c0e7e15ff3eaed976ecf0f25570"
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
