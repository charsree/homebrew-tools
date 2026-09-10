class Record < Formula
  desc "Local-first macOS meeting assistant with mic, system audio, screen OCR, and Kiro chat"
  homepage "https://github.com/charsree/record"
  url "https://github.com/charsree/record/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c24d6bdc6498860cab34f56a78a649fdc0ed6475ed0956188b798b6b4117d0cd"
  version "0.2.0"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["16.0", :build]
  depends_on "whisper-cpp"

  def install
    system "chmod", "+x", "scripts/build-app.sh"
    system "zsh", "scripts/build-app.sh"
    prefix.install "Build/Record.app"
  end

  def caveats
    <<~EOS
      Record has been installed to:
        #{prefix}/Record.app

      To use Record:
        1. Copy to Applications: cp -r #{prefix}/Record.app /Applications/
        2. Launch: open /Applications/Record.app
        3. Grant Microphone and Screen Recording permissions when prompted.
        4. Open Preferences → Transcription to download a whisper model
           (large-v3-turbo recommended for best quality).

      Optional: install the Kiro CLI (https://kiro.dev) to enable the
      chat, auto-summary, and auto-title features. Recording and
      transcription work without it.

      All meeting data stays on your Mac, encrypted with AES-GCM at:
        ~/Library/Application Support/Record/
    EOS
  end

  test do
    assert_predicate prefix/"Record.app", :exist?
    assert_predicate prefix/"Record.app/Contents/MacOS/Record", :executable?
  end
end
