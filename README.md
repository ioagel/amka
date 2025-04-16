# AMKA and Luhn IDs Validator / Generator

[![Ruby CI](https://github.com/ioagel/amka/actions/workflows/ci.yml/badge.svg)](https://github.com/ioagel/amka/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/amka.svg)](https://badge.fury.io/rb/amka)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/gems/amka)

## Α.Μ.Κ.Α (Αριθμός Μητρώου Κοινωνικής Ασφάλισης)

This gem validates **A.M.K.A** Greek social security IDs by
using the Luhn algorithm, as described in this [Wikipedia article](https://en.wikipedia.org/wiki/Luhn_algorithm).
The only additional validation needed that applies to Greek A.M.K.A is that the
first 6 digits must be a valid date (date of birth).

The gem also _validates_ and _generates_ **Luhn** ids, as well as _generating_
**AMKA** (like) ids. The _like_ here means that the AMKA generated are not
**real** as those provided by the Official Authorities in Greece.

There is an online calculator in [planetcalc](http://planetcalc.com/2464/), you
can validate the results of the gem, until you are confident that is working
as it should. Try you own and your family AMKA.

**DISCLAIMER**: The gem _does not_ validate the real existence of the A.M.K.A or that it
belongs to a given person. The same applies to the generator.

## Documentation

- [Usage Guide](USAGE.md) - Comprehensive examples and use cases
- [API Documentation](http://rubydoc.info/gems/amka) - Full method documentation
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to this gem
- [Changelog](CHANGELOG.md) - Version history and changes

## Installation

Requires ruby >= 2.7.0

Add this line to your application's Gemfile:

```ruby
gem 'amka'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install amka
```

## Quick Start

```ruby
require 'amka'

# Simple Validation (returns true or false)
Amka.valid?('01011441432')
# returns false

# You can also pass the 4 digit year of birth as a second string argument
# This will increase the accuracy of the date part of validation to 100%.
Amka.valid?('111098xxxxx', '1998')

# Detailed Validation with Error Messages
errors = Amka.validate('01AB9012345')
if errors.empty?
  puts "Valid AMKA!"
else
  puts "Invalid AMKA: #{errors.join(', ')}"
  # => "Invalid AMKA: AMKA must contain only digits"
end

# Exception-based Validation
begin
  Amka.validate!('01019012345')  # Returns true if valid
rescue Amka::ValidationError => e
  puts "Error: #{e.message}"
end

# To generate a random AMKA (returns the AMKA as a string)
Amka.generate

# To generate with a specific date (date format: [d]d/[m]m/yyyy)
# returns: 101190xxxxx
Amka.generate('10/11/1990')

###### Bonus ######

# To validate any number against the Luhn algorithm
Amka::Luhn.valid?('1142376755673') # returns true

# To generate a Luhn id
# takes up to 2 arguments: total, id_start(optional)
# total: how many digits you want in the Luhn generated
# id_start: string of numbers to include at the start of the Luhn
# - total must be greater than the length of id_start by at least one, to
# account for the rightmost check digit.
Amka::Luhn.generate(13) # returns '5361281695669'
Amka::Luhn.generate(10, '123456789') # returns '1234567897', 7 is the check digit.
Amka::Luhn.generate(15, '12345') # returns something like: '123450789968798'
```

See the [Usage Guide](USAGE.md) for more detailed examples and advanced usage.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/ioagel/amka>.

Please see the [Contributing Guide](CONTRIBUTING.md) for more details on how to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
