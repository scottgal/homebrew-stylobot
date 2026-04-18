# Homebrew Tap for StyloBot

Self-hosted bot detection with 31 detectors, session vectors, and zero PII.

## Install

```bash
brew install scottgal/stylobot/stylobot
```

Or tap first:

```bash
brew tap scottgal/stylobot
brew install stylobot
```

## Usage

```bash
# Start in demo mode
stylobot

# Start with upstream target
DEFAULT_UPSTREAM=http://localhost:3000 stylobot --mode production

# Dashboard
open http://localhost:5080/_stylobot
```

## More info

- [GitHub](https://github.com/scottgal/stylobot)
- [Documentation](https://github.com/scottgal/stylobot/tree/main/docs)
- [Pricing](https://stylobot.net/pricing) - Free forever for the open source edition
