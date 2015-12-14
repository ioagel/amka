# AMKA Validator / Generator

This gem validates and/or generates A.M.K.A Greek social security numbers by
using the Luhn algorithm, as described in this [Wikipedia article](https://en.wikipedia.org/wiki/Luhn_algorithm).
The only additional validation needed that applies to Greek A.M.K.A is that the
first 6 digits must be a valid date (date of birth).

NOTICE: The gem does not validate the existence of the A.M.K.A or that it
belongs to a given person. The same applies to the generator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'amka'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amka

## Usage

```ruby
require 'amka'

# To validate
Amka.valid?('26029996274') # returns true or false

# To generate
Amka.generate # returns a string '05129064191'
```

## TODO

Add tests ;-)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ioagel/amka.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

