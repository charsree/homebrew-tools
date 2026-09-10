class Record < Formula
  desc "Local-first macOS meeting assistant with mic, system audio, screen OCR, and Kiro chat"
  homepage "https://github.com/charsree/record"
  url "https://github.com/charsree/record/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "95ad0aa70e8058c3f2b2559c3618212e62fd43aac6911d5c9e62804624b41a02"
  version "0.3.0"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["16.0", :build]
  depends_on "whisper-cpp"

  def install
    # Build the app.
    system "chmod", "+x", "scripts/build-app.sh"
    system "zsh", "scripts/build-app.sh"

    # Install the app bundle to the prefix.
    prefix.install "Build/Record.app"
  end

  def caveats
    <<~EOS
      Record has been installed to:
        #{prefix}/Record.app

      To use Record:
        1. Copy to Applications: cp -r #{prefix}/Record.app /Applications/
        2. Launch: open /Applications/Record.app
        3. Grant Microphone + Screen Recording when macOS prompts.
        4. Open Preferences → Transcription to download a whisper model.
           large-v3-turbo is best; base.en is smallest/fastest.

      Optional: install the Kiro CLI (https://kiro.dev) to enable the
      chat, auto-summary, and auto-title features. Recording and
      transcription work without it.

      Features:
        🎙️  Microphone + system audio capture (Zoom/Meet/Teams/Chime)
        🧠  Local whisper.cpp transcription (multi-language + translation)
        🔍  Snap-and-OCR any screen region
        💬  Chat over one meeting, all meetings, or ad-hoc via Kiro
        ⭐  Star / edit / play-from-here segments
        🗓️  Scheduled recordings + auto-detect video calls
        🔒  AES-GCM encrypted transcripts and chats at rest

      All meeting data stays on your Mac at:
        ~/Library/Application Support/Record/
    EOS
  end

  test do
    assert_predicate prefix/"Record.app", :exist?
    assert_predicate prefix/"Record.app/Contents/MacOS/Record", :executable?
  end
end
