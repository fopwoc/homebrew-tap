class Migr < Formula
  desc "Carry Minecraft configs between Prism instances with git"
  homepage "https://github.com/fopwoc/migr"
  url "https://github.com/fopwoc/migr/releases/download/0.1.0/migr-0.1.0-macos.tar.gz"
  version "0.1.0"
  sha256 "60d92dcbde2438e678dfe3fec5855c302a0e2cacde0b220395b26466d1108e87"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "migr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/migr --version")
  end
end
