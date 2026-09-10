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
    system "chmod", "+x", "scripts/build-app.sh"
    system "zsh", "scripts/build-app.sh"
    prefix.install "Build/Record.app"

    # Copy the built app into /Applications so it shows up in Launchpad,
    # Spotlight and TCC just like any other GUI app. If /Applications
    # isn't writable, we still leave the Cellar copy in place.
    applications = "/Applications"
    if File.writable?(applications)
      system "rm", "-rf", "#{applications}/Record.app"
      system "cp", "-R", "#{prefix}/Record.app", "#{applications}/"
    end

    # Convenience CLI: type "record" in Terminal to launch the app.
    (bin/"record").write <<~SH
      #!/bin/sh
      exec open -a "Record" "$@"
    SH
    chmod 0755, bin/"record"
  end

  def caveats
    <<~EOS
      Record was installed to /Applications/Record.app.

      Launch it from Launchpad, Spotlight, or:
        open -a Record        # or just: record

      On first launch macOS will ask for Microphone + Screen Recording.
      Grant both — system audio (Zoom/Meet/etc.) requires Screen Recording.

      Open Preferences → Transcription to pick a whisper model.
      large-v3-turbo is best for quality; base.en is smallest/fastest.

      Optional: install the Kiro CLI (https://kiro.dev) for chat,
      auto-title, and auto-summary. Recording/transcription work
      without it.

      All meeting data stays on your Mac, encrypted with AES-GCM at
      ~/Library/Application Support/Record/.
    EOS
  end

  test do
    assert_predicate prefix/"Record.app", :exist?
    assert_predicate prefix/"Record.app/Contents/MacOS/Record", :executable?
  end
end
