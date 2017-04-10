# coding: utf-8
here = File.dirname(__FILE__)
lib = File.join(here, "lib")
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rhust/version"
require "find"

Gem::Specification.new do |spec|
  spec.name          = "rhust"
  spec.version       = Rhust::VERSION
  spec.authors       = ["Cosmia Fu"]
  spec.summary       = %q{A native ruby extension written in rust}
  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/rhust/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
end
