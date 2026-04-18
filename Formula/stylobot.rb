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
    bin.install "stylobot"
    lib.install Dir["*.dylib"] if OS.mac?
    lib.install Dir["*.so"] if OS.linux?
    (etc/"stylobot").mkpath
    (etc/"stylobot").install "appsettings.json"
    (etc/"stylobot").install "appsettings.production.json" if File.exist?("appsettings.production.json")
  end

  def caveats
    <<~EOS
      StyloBot Community Edition installed!

        stylobot                    # Start in demo mode (port 5080)
        stylobot --mode production  # Production mode

      Config: #{etc}/stylobot/appsettings.json
      Dashboard: http://localhost:5080/_stylobot
      Docs: https://github.com/scottgal/stylobot
      Upgrade: https://stylobot.net/pricing
    EOS
  end

  test do
    assert_predicate bin/"stylobot", :exist?
  end
end
