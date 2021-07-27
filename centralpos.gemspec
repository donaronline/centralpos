# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'centralpos/version'

Gem::Specification.new do |spec|
  spec.name          = "centralpos"
  spec.version       = Centralpos::VERSION
  spec.authors       = ["Agustin Cavilliotti"]
  spec.email         = ["cavi21@gmail.com"]

  spec.summary       = "Ruby wrapper for the CentralPos WebService"
  spec.description   = "Ruby wrapper for the CentralPos WebService"
  spec.homepage      = "https://github.com/donaronline/centralpos"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.12"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "httplog"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry-byebug", "~> 3.2"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.21"
end
