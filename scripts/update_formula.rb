# frozen_string_literal: true

require "fileutils"
require "uri"

def required_env(name)
  value = ENV.fetch(name, "").strip
  abort "#{name} is required" if value.empty?
  abort "#{name} contains a control character" if value.match?(/[[:cntrl:]]/)

  value
end

name = required_env("FORMULA_NAME")
version = required_env("FORMULA_VERSION")
sha256 = required_env("FORMULA_SHA256").downcase
url = required_env("FORMULA_URL")
description = required_env("FORMULA_DESC")
homepage = required_env("FORMULA_HOMEPAGE")
binary = required_env("FORMULA_BINARY")

abort "FORMULA_NAME must contain only lowercase letters, digits, and single hyphens" unless name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
abort "FORMULA_SHA256 must be a 64-character hexadecimal checksum" unless sha256.match?(/\A[0-9a-f]{64}\z/)
abort "FORMULA_BINARY must be a plain file name" unless binary.match?(/\A[A-Za-z0-9._-]+\z/)

{ "FORMULA_URL" => url, "FORMULA_HOMEPAGE" => homepage }.each do |key, value|
  uri = URI.parse(value)
  abort "#{key} must be an HTTPS URL" unless uri.is_a?(URI::HTTPS) && uri.host
rescue URI::InvalidURIError
  abort "#{key} must be a valid URL"
end

class_name = name.split("-").map(&:capitalize).join

formula = <<~RUBY
  class #{class_name} < Formula
    desc #{description.dump}
    homepage #{homepage.dump}
    url #{url.dump}
    version #{version.dump}
    sha256 #{sha256.dump}

    depends_on arch: :arm64
    depends_on :macos

    def install
      bin.install #{binary.dump}
    end

    test do
      assert_match version.to_s, shell_output("\#{bin}/#{binary} --version")
    end
  end
RUBY

FileUtils.mkdir_p("Formula")
File.write("Formula/#{name}.rb", formula)
