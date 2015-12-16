# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amka/version'

Gem::Specification.new do |spec|
  spec.name          = "amka"
  spec.version       = Amka::VERSION
  spec.authors       = ["Ioannis Angelakopoulos"]
  spec.email         = ["ioagel@gmail.com"]

  spec.summary       = %q{AMKA/Luhn IDs Generator and Validator}
  spec.description   = %q{Generates and Validates Greek A.M.K.A (social security number) and Luhn IDs, using the Luhn algorithm. DISCLAIMER: It does not validate the real existence of the A.M.K.A or that it belongs to a given person. The same applies to the generator.}
  spec.homepage      = "https://github.com/ioagel/amka"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
