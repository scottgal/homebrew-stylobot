class Stylobot < Formula
  desc "Self-hosted bot detection with 31 detectors, session vectors, and zero PII"
  homepage "https://stylobot.net"
  version "5.6.3"
  license "Unlicense"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-arm64.tar.gz"
      sha256 "6a618f6580105333d26bae64b7bb1867c26016316da9fb3f446a3fb6f7abc381"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-osx-x64.tar.gz"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-arm64.tar.gz"
    else
      url "https://github.com/scottgal/stylobot/releases/download/console-v#{version}/stylobot-linux-x64.tar.gz"
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

        stylobot                    # Start in demo mode (port 5080)
        stylobot --mode production  # Production mode

      Config: #{libexec}/appsettings.json
      Dashboard: http://localhost:5080/_stylobot
      Docs: https://github.com/scottgal/stylobot
    EOS
  end

  test do
    assert_predicate bin/"stylobot", :executable?
  end
end
