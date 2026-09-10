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
    # Build the .app via our packaged build script.
    system "chmod", "+x", "scripts/build-app.sh"
    system "zsh", "scripts/build-app.sh"

    # Keep a canonical copy inside the Cellar (Homebrew tracks this for
    # uninstall / upgrade). The Cellar prefix is /opt/homebrew/Cellar on
    # Apple Silicon and /usr/local/Cellar on Intel — Homebrew handles the
    # difference for us.
    prefix.install "Build/Record.app"

    # Auto-install into /Applications so Launchpad / Spotlight / TCC
    # treat Record like any drag-installed app. This is what the user
    # actually wants — no manual cp step. If /Applications isn't
    # writable (locked-down machine or MDM), we leave the Cellar copy
    # alone and the caveats explain how to move it by hand.
    applications = "/Applications"
    if File.writable?(applications)
      rm_rf "#{applications}/Record.app"
      cp_r "#{prefix}/Record.app", "#{applications}/Record.app"
    end

    # Convenience: `record` in Terminal launches the installed app.
    (bin/"record").write <<~SH
      #!/bin/sh
      exec open -a "Record" "$@"
    SH
    chmod 0755, bin/"record"
  end

  def caveats
    if File.exist?("/Applications/Record.app")
      <<~EOS
        Record was installed to /Applications/Record.app.

        Launch it:
          open -a Record        # or just: record

        First launch will ask for Microphone + Screen Recording. Grant both —
        system audio (Zoom/Meet/Teams/etc.) needs Screen Recording.

        Open Preferences → Transcription to pick a whisper model.
        large-v3-turbo is best for quality; base.en is smallest.

        Optional: install the Kiro CLI (https://kiro.dev) for chat,
        auto-title, and auto-summary. Recording + transcription work
        without it.

        Data stays local, AES-GCM encrypted at:
          ~/Library/Application Support/Record/
      EOS
    else
      <<~EOS
        Record has been installed to:
          #{prefix}/Record.app

        We couldn't auto-copy it to /Applications (permission denied).
        Move it manually:
          cp -R #{prefix}/Record.app /Applications/
          open -a Record

        Then grant Microphone + Screen Recording, and pick a whisper
        model in Preferences → Transcription.

        Data stays local at ~/Library/Application Support/Record/.
      EOS
    end
  end

  test do
    assert_predicate prefix/"Record.app", :exist?
    assert_predicate prefix/"Record.app/Contents/MacOS/Record", :executable?
  end
end
