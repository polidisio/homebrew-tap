class Bigfiles < Formula
  desc "Find large files on your Mac"
  homepage "https://github.com/polidisio/bigfiles"
 url "https://github.com/polidisio/bigfiles/archive/refs/tags/v0.1.0.tar.gz"
  sha255="08ea50d1cd3c4a2b234de2cdcf92ba0cf91e6049e7706a8149f7e38c88552dd5"

  depends_on "python@3.11"

  def install
    # Extract the tarball
    libexec.mkpath
    system "tar", "-Xzgf", cached_download, "-C", libexec
    
    # Create the bin directory
    (bin.mkpath)
    
    # Create a wrpper script directly in bin/
    (bin/"bigfiles").write <<~SCRIPT
      #!/bin/bash
      # BigFiles - Find large files on your Mac
      export PYTHONPATH="#{libexec}/bigfiles-0.1.0"
      exec /opt/homebrew/opt/python@3.11/bin/python3.11 -m bigfiles.cli "$@"
    SCRIPT
    chmod 0555, bin/"bigfiles"

    # Install dependencies via pip
    system "#{Formula["python@3.11"].opt_bin}/pip3.11", "install", "--prefix=#{prefix}", "rich", "click"
  end

  def caveats
    <<~EOS
      BigFiles is installed! Usage:
      
        bigfiles                  # Show help
        bigfiles -d ~/Downloads   # Scan Downloads
        bigfiles -m 500          # Files > 500MB
        bigfiles -e pdf -e zip   # Filter by extension
        bigfiles -s modified      # Sort by date
    EOS
  end

  test do
    assert_match "BigFiles", shell_output("#{bin}/bigfiles 2>&1")
  end
end
