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

  # Ad-hoc signed. Users on locked-down machines may see a Gatekeeper
  # prompt on first launch — right-click the app → Open → Open.
  auto_updates false

  app "Record.app"

  # Convenience CLI: `record` in Terminal launches the installed app.
  binary "#{staged_path}/record-shim", target: "record"

  preflight do
    File.write("#{staged_path}/record-shim", <<~SH)
      #!/bin/sh
      exec open -a "Record" "$@"
    SH
    File.chmod(0755, "#{staged_path}/record-shim")
  end

  zap trash: [
    "~/Library/Application Support/Record",
    "~/Library/Preferences/dev.charsree.record.plist",
    "~/Library/Saved Application State/dev.charsree.record.savedState",
  ]

  caveats <<~EOS
    Record was installed to /Applications/Record.app.

    Launch it:
      open -a Record        # or just: record

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
