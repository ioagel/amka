# frozen_string_literal: true

require_relative 'lib/amka/version'

Gem::Specification.new do |spec|
  spec.name          = 'amka'
  spec.version       = Amka::VERSION
  spec.authors       = ['Ioannis Angelakopoulos']
  spec.email         = ['ioagel@gmail.com']

  spec.summary       = 'AMKA/Luhn IDs Generator and Validator'
  spec.description   = 'Generates and Validates Greek A.M.K.A and Luhn IDs, ' \
                       'using the Luhn algorithm. DISCLAIMER: ' \
                       'It does not validate the real existence ' \
                       'of the A.M.K.A or that it belongs to a given person. ' \
                       'The same applies to the generator.'
  spec.homepage      = 'https://github.com/ioagel/amka'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => 'http://rubydoc.info/gems/amka',
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[lib/**/*.rb *.md LICENSE.txt])
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
