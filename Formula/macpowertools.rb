class Macpowertools < Formula
  desc "Mac Power Tools - Text Extractor and Clipboard History with Custom Hotkeys"
  homepage "https://github.com/charsree/MacPowerTools"
  url "https://github.com/charsree/MacPowerTools/archive/9acdc00b7254ccbfd2aabbae0c23d28f239ec24a.tar.gz"
  sha256 "5f181ee7aad2f7d836b9e0037fca0db1ce6ceddd9f967bd6489219732649dbac"
  version "2.0"
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
        📝 Text Extractor: Customizable hotkeys (default Cmd+Shift+T)
        📋 Clipboard History: Customizable hotkeys (default Cmd+Shift+V)
        🎛️ Custom Hotkeys: Configure via Preferences menu
        🚀 Login Items: Easy management via menu bar

      First time setup:
        • Permissions requested when you use features
        • Custom hotkeys: Click ⌬ → Preferences
        • Login items: Click ⌬ → Add to Login Items

      Version 2.0 includes custom hotkeys, smart permissions, and login items management!
    EOS
  end

  test do
    assert_predicate prefix/"MacPowerTools.app", :exist?
    assert_predicate prefix/"MacPowerTools.app/Contents/MacOS/MacPowerTools", :executable?
  end
end
