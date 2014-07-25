# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fech-ftp/version'

Gem::Specification.new do |spec|
  spec.name          = "Fech-FTP"
  spec.version       = Fech::Ftp::VERSION
  spec.authors       = ["Derek Willis"]
  spec.email         = ["dwillis@gmail.com"]
  spec.summary       = %q{A Ruby interface for FTP data from the Federal Election Commission.}
  spec.description   = %q{Retrieve and parse summary and detailed federal campaign finance data.}
  spec.homepage      = "https://github.com/dwillis/fech-ftp"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_dependency "fech"
  spec.add_dependency "remote_table"
  spec.add_dependency "american_date"
end
