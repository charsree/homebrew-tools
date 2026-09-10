class Record < Formula
  desc "Local-first macOS meeting assistant with mic, system audio, screen OCR, and Kiro chat"
  homepage "https://github.com/charsree/record"
  url "https://github.com/charsree/record/releases/download/v0.3.1/Record-0.3.1.zip"
  sha256 "babc4df176fa4df35c538b8003f905e07d9e1fd1695828a7892b5ed53a47576c"
  version "0.3.1"
  license "MIT"

  depends_on :macos

  def install
    # Pre-built .app bundle sits at the archive root because
    # tag-release.sh zipped it with .
    prefix.install "Record.app"

    # Auto-install into /Applications so Launchpad / Spotlight
    # / TCC treat it like any drag-installed app. Falls back to
    # a caveats note when /Applications isn't writable.
    applications = "/Applications"
    if File.writable?(applications)
      rm_rf "#{applications}/Record.app"
      cp_r "#{prefix}/Record.app", "#{applications}/Record.app"
    end

    # `record` in Terminal opens the app.
    (bin/"record").write <<~SH
      #!/bin/sh
      exec open -a "Record" "\$@"
    SH
    chmod 0755, bin/"record"
  end

  def caveats
    if File.exist?("/Applications/Record.app")
      <<~EOS
        Record was installed to /Applications/Record.app.

        Launch it:
          open -a Record        # or just: record

        First launch asks for Microphone + Screen Recording. Grant both —
        system audio (Zoom/Meet/Teams/etc.) needs Screen Recording.

        Pick a whisper model in Preferences → Transcription.
        large-v3-turbo is best; base.en is smallest / fastest.

        Optional: install the Kiro CLI (https://kiro.dev) for chat,
        auto-title, and auto-summary. Recording + transcription work
        without it.

        Data stays local, AES-GCM encrypted at
        ~/Library/Application Support/Record/.
      EOS
    else
      <<~EOS
        Record has been installed to:
          #{prefix}/Record.app

        We couldn't auto-copy it to /Applications (permission denied).
        Move it manually:
          cp -R #{prefix}/Record.app /Applications/
          open -a Record
      EOS
    end
  end

  test do
    assert_predicate prefix/"Record.app", :exist?
    assert_predicate prefix/"Record.app/Contents/MacOS/Record", :executable?
  end
end
