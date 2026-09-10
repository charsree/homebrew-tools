cask "record" do
  version "0.5.0"
  sha256 "bea6ee5489d995819e5999c1e7d96ccae56fb67e24c272f5c4858e5556610ad6"

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

  # Record is ad-hoc signed. Strip the quarantine bit so macOS doesn't
  # block first launch with the "cannot verify malware" dialog.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Record.app"],
                   must_succeed: false
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
