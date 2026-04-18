class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "5.6.4"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "6fda1e3faf3824678c3b8f591066e3047d7e09448d5c6c6bf7690776cf68ee5b"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
      sha256 "c7d6b9e188ac27337c42db9bd4e3ea87b05e7f75bbf5f200b751e7926181fe11"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
      sha256 "d17c64bde255bd97bc2d4f3c5d2914fb62836c4a32a9aabd422bc73d304eacc6"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
      sha256 "52abab5b87401b9ad4d79d804c29d91df41e47daf61a54eaa63675fa0548b18b"
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

  def caveats
    <<~EOS
      StyloBot Community Edition installed!

        stylobot 5080 http://localhost:3000         # Proxy with bot detection
        stylobot 5080 http://localhost:3000 --tunnel # + Cloudflare Tunnel
        stylobot --help                              # All options

      For Cloudflare Tunnel support: brew install cloudflared

      Config: #{libexec}/appsettings.json
      Dashboard: http://localhost:5080/_stylobot
      Docs: https://github.com/scottgal/stylobot
    EOS
  end

  test do
    assert_predicate bin/"stylobot", :executable?
  end
end
