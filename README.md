# AMKA and Luhn IDs Validator / Generator
##### Α.Μ.Κ.Α (Αριθμός Μητρώου Κοινωνικής Ασφάλισης)
This gem validates **A.M.K.A** Greek social security IDs by
using the Luhn algorithm, as described in this [Wikipedia article](https://en.wikipedia.org/wiki/Luhn_algorithm).
The only additional validation needed that applies to Greek A.M.K.A is that the
first 6 digits must be a valid date (date of birth).

The gem also *validates* and *generates* **Luhn** ids, as well as *generating*
**AMKA** (like) ids. The *like* here means that the AMKA generated are not
**real** as those provided by the Official Authorities in Greece.

There is an online calculator in [planetcalc](http://planetcalc.com/2464/), you
can validate the results of the gem, until you are confident that is working
as it should. Try you own and your family AMKA.

**DISCLAIMER**: The gem *does not* validate the real existence of the A.M.K.A or that it
belongs to a given person. The same applies to the generator.

## Installation
Requires ruby >= 2.0.0

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

# To validate (takes the AMKA as a string and returns true or false)
Amka.valid?('01011441432')
# returns false (i did not use a valid one in this example just in case
# it belonged to a real person!!!!)

# To generate (returns the AMKA as a string)
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
# - total must be greater than id_start by at least one, to account for the
#   rightmost check digit.
Amka::Luhn.generate(13) # returns '5361281695669'
Amka::Luhn.generate(10, '123456789') # returns '1234567897', 7 is the check digit.
Amka::Luhn.generate(15, '12345') # returns something like: '123450789968798'
```

## TODO

Add tests for the Luhn class.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ioagel/amka.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

