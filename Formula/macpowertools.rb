class Macpowertools < Formula
  desc "Mac Power Tools - Text Extractor and Clipboard History with Custom Hotkeys"
  homepage "https://github.com/charsree/MacPowerTools"
  url "https://github.com/charsree/MacPowerTools/archive/refs/tags/v2.1.tar.gz"
  sha256 "bc51814b8dd084d3f69344ed8d84664c5805aaf555fbe898f7419da9e65451e1"
  version "2.1"
  license "MIT"

  depends_on :macos

  def install
    # Build the application
    system "chmod", "+x", "build.sh"
    system "./build.sh"
    
    # Create the app bundle
    system "chmod", "+x", "create_apps.sh"  
    system "./create_apps.sh"
    
    # Install the app bundle to the prefix
    prefix.install "MacPowerTools.app"
  end

  def caveats
    <<~EOS
      Mac Power Tools has been installed to:
        #{prefix}/MacPowerTools.app

      To use Mac Power Tools:
        1. Copy to Applications: cp -r #{prefix}/MacPowerTools.app /Applications/
        2. Launch: open /Applications/MacPowerTools.app
        3. Look for the ⌬ diamond icon in your menu bar

      Features:
        📝 Text Extractor: Customizable hotkeys (default Cmd+Shift+Y)
        📋 Clipboard History: Customizable hotkeys (default Cmd+Shift+V)
        🖼️  Image Clipboard: Screenshots and copied images join the history
        🎛️  Custom Hotkeys: Configure via Preferences menu
        🚀 Login Items: Easy management via menu bar

      First time setup:
        • Permissions requested when you use features
        • Custom hotkeys: Click ⌬ → Preferences
        • Login items: Click ⌬ → Add to Login Items (now uses SMAppService)

      Version 2.1 adds image clipboard support, fixes preferences-window
      focus, fixes login-items add/remove, and changes the default text-
      extractor hotkey from Cmd+Shift+T to Cmd+Shift+Y.
    EOS
  end

  test do
    assert_predicate prefix/"MacPowerTools.app", :exist?
    assert_predicate prefix/"MacPowerTools.app/Contents/MacOS/MacPowerTools", :executable?
  end
end
