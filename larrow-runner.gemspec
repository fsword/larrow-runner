# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'larrow/runner/version'

Gem::Specification.new do |spec|
  spec.name          = "larrow-runner"
  spec.version       = Larrow::Runner::VERSION
  spec.authors       = ["fsword"]
  spec.email         = ["li.jianye@gmail.com"]
  spec.summary       = %q{Core application of larrow}
  spec.description   = %q{Automatically build your app from code}
  spec.homepage      = "http://github.com/fsword/larrow-core"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency 'rake', '~> 0'
end
