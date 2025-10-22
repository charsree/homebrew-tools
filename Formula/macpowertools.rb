class Macpowertools < Formula
  desc "Mac Power Tools - Text Extractor and Clipboard History with Custom Hotkeys"
  homepage "https://github.com/charsree/MacPowerTools"
  url "https://github.com/charsree/MacPowerTools/archive/697c9d0bb020b2ee72ba70dd63b8397d6de4b825.tar.gz"
  sha256 "a5fcf1fc6eb75be701b215f310d5dc2d33b20098acd5ac567f7c539653366f39"
  version "2.0"
  license "MIT"

  depends_on :macos
  depends_on arch: [:x86_64, :arm64]

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
        🔐 Smart Permissions: Only requested when features are used
        🚀 Login Items: Easy management via menu bar

      First time setup:
        • No startup dialogs - clean launch experience
        • Permissions requested only when you use features
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
