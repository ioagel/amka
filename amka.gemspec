# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amka/version'

Gem::Specification.new do |spec|
  spec.name          = "amka"
  spec.version       = Amka::VERSION
  spec.authors       = ["Ioannis Angelakopoulos"]
  spec.email         = ["ioagel@gmail.com"]

  spec.summary       = %q{A.M.K.A Generator and Validator}
  spec.description   = %q{Generates and Validates Greek A.M.K.A (social security number), using the Luhn algorithm.}
  spec.homepage      = "https://github.com/ioagel/amka"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
