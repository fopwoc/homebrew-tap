# frozen_string_literal: true

require "fileutils"
require "uri"

def required_env(name)
  value = ENV.fetch(name, "").strip
  abort "#{name} is required" if value.empty?
  abort "#{name} contains a control character" if value.match?(/[[:cntrl:]]/)

  value
end

token = required_env("CASK_TOKEN")
version = required_env("CASK_VERSION")
sha256 = required_env("CASK_SHA256").downcase
url = required_env("CASK_URL")
name = required_env("CASK_NAME")
description = required_env("CASK_DESC")
homepage = required_env("CASK_HOMEPAGE")
app = required_env("CASK_APP")

abort "CASK_TOKEN must contain only lowercase letters, digits, and single hyphens" unless token.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
abort "CASK_SHA256 must be a 64-character hexadecimal checksum" unless sha256.match?(/\A[0-9a-f]{64}\z/)

{ "CASK_URL" => url, "CASK_HOMEPAGE" => homepage }.each do |key, value|
  uri = URI.parse(value)
  abort "#{key} must be an HTTPS URL" unless uri.is_a?(URI::HTTPS) && uri.host
rescue URI::InvalidURIError
  abort "#{key} must be a valid URL"
end

cask = <<~RUBY
  cask #{token.dump} do
    version #{version.dump}
    sha256 #{sha256.dump}

    url #{url.dump}
    name #{name.dump}
    desc #{description.dump}
    homepage #{homepage.dump}

    app #{app.dump}
  end
RUBY

FileUtils.mkdir_p("Casks")
File.write("Casks/#{token}.rb", cask)
