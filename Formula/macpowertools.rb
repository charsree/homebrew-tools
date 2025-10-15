class Macpowertools < Formula
  desc "Mac Power Tools - Text extraction and clipboard history"
  homepage "https://github.com/charsree/MacPowerTools"
  url "https://github.com/charsree/MacPowerTools/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  sha256 "6aa42fd6480bcdb53ba705fa360fddd1854308257845400c791c8b3b20a244a4"

  depends_on :macos

  def install
    system "./build.sh"
    system "./create_apps.sh"
    prefix.install "MacPowerTools.app"
  end

  def caveats
    <<~EOS
      MacPowerTools has been installed as an app bundle.
      
      To launch:
        open #{prefix}/MacPowerTools.app
      
      To add to Applications folder:
        cp -r #{prefix}/MacPowerTools.app /Applications/
      
      Grant Screen Recording and Accessibility permissions when prompted.
      
      Keyboard shortcuts:
        Cmd+Shift+T - Extract text from screen
        Cmd+Shift+V - Show clipboard history
    EOS
  end
end
