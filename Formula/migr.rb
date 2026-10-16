class Migr < Formula
  desc "Carry Minecraft configs between Prism instances with git"
  homepage "https://github.com/fopwoc/migr"
  url "https://github.com/fopwoc/migr/releases/download/0.2.0/migr-0.2.0-macos.tar.gz"
  version "0.2.0"
  sha256 "064c40f908a5693252b6f0ab74399c182c9749eee965005b99cfa51b7af495b6"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "migr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/migr --version")
  end
end
