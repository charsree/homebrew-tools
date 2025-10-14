class Macpowertools < Formula
  desc "Mac Power Tools - Text extraction and clipboard history"
  homepage "https://github.com/charsree/MacPowerTools"
  url "https://github.com/charsree/MacPowerTools/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  sha256 "ded45f2310da3e9a36f00f4f3d120749086dba32bdd87c65c10697fa7590d35a"

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

  def caveats
    <<~EOS
      To start MacPowerTools:
        MacPowerTools &

      Grant Screen Recording and Accessibility permissions when prompted.
    EOS
  end
end
