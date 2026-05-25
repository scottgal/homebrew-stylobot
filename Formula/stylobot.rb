class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "6.8.4"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "d521bd2e6858a6e8544d42cf9c20b82fbba396188ba4b1bc2d67e196a3b25e65"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "d9c42a5b4bef72df3a1f7338db673f276995407271128873267db17d0c2b0ce7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "cac79fe85d69f0f75abc1d5aef438503e8074156498e04a01e3f6d772f637398"
    else
      url "https://github.com/scottgal/stylobot/releases/download/allbot-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "e93a52226f83e0218a475451453b334f4c5808265111882d66e11a0262d23239"
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
