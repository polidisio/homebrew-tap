class ExiftoolCli < Formula
  desc "CLI tool for extracting, exporting, and removing EXIF metadata from photos"
  homepage "https://github.com/polidisio/exiftool-cli"
  license "MIT"
  url "https://github.com/polidisio/exiftool-cli/archive/refs/heads/main.tar.gz"
  version "HEAD"

  depends_on "python@3.11"
  depends_on "tcl-tk"

  def install
    libexec.mkpath

    system "curl", "-sL", "https://github.com/polidisio/exiftool-cli/archive/refs/heads/main.tar.gz", "-o", "#{libexec}/src.tar.gz"
    system "tar", "-xzf", "#{libexec}/src.tar.gz", "-C", libexec
    system "rm", "#{libexec}/src.tar.gz"

    src_dir = Dir.glob("#{libexec}/exiftool-cli*").first
    raise "Source directory not found" if src_dir.nil?

    bin.mkpath
    (bin/"exiftool-cli").write <<~SCRIPT
      #!/bin/bash
      export PYTHONPATH="#{libexec}:#{src_dir}/src"
      exec #{Formula["python@3.11"].opt_bin}/python3.11 -m exiftool_cli.cli "$@"
    SCRIPT
    chmod 0555, bin/"exiftool-cli"

    system "#{Formula["python@3.11"].opt_bin}/pip3.11", "install", "--target=#{libexec}",
          "Pillow>=10.0.0", "piexif>=1.1.3", "click>=8.1.0", "colorama>=0.4.6"
  end

  test do
    system "#{bin}/exiftool-cli", "--help"
  end
end