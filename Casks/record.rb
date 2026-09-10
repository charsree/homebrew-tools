cask "record" do
  version "0.3.1"
  sha256 "babc4df176fa4df35c538b8003f905e07d9e1fd1695828a7892b5ed53a47576c"

  url "https://github.com/charsree/record/releases/download/v#{version}/Record-#{version}.zip"
  name "Record"
  desc "Local-first macOS meeting assistant with mic, system audio, screen OCR, and Kiro chat"
  homepage "https://github.com/charsree/record"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :sequoia"

  app "Record.app"

  # Record is ad-hoc signed (no paid Apple Developer ID yet). By default,
  # Homebrew Cask marks downloaded apps as quarantined, which triggers
  # macOS Gatekeeper's "cannot verify this app is free of malware" dialog
  # on first launch. Strip the quarantine bit so the app opens normally.
  # Users who want the extra scrutiny can install with
  #   brew install --cask record --quarantine
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Record.app"],
                   must_succeed: false
  end

  uninstall_postflight do
    # No-op; here for symmetry.
  end

  zap trash: [
    "~/Library/Application Support/Record",
    "~/Library/Preferences/dev.charsree.record.plist",
    "~/Library/Saved Application State/dev.charsree.record.savedState",
  ]

  caveats <<~EOS
    Record was installed to /Applications/Record.app.

    Launch it:
      open -a Record

    First launch asks for Microphone + Screen Recording. Grant both —
    system audio (Zoom/Meet/Teams/etc.) needs Screen Recording.

    Pick a whisper model in Preferences → Transcription.
    large-v3-turbo is best; base.en is smallest / fastest.

    Optional: install the Kiro CLI (https://kiro.dev) for chat, auto-title,
    and auto-summary. Recording + transcription work without it.

    All meeting data stays on your Mac, encrypted with AES-GCM at:
      ~/Library/Application Support/Record/
  EOS
end
