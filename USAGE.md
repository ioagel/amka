# AMKA Gem Usage Guide

This document provides comprehensive examples and guidelines for using the AMKA gem in your Ruby projects.

## Table of Contents

- [AMKA Gem Usage Guide](#amka-gem-usage-guide)
  - [Table of Contents](#table-of-contents)
  - [Understanding AMKA](#understanding-amka)
  - [Basic Usage](#basic-usage)
    - [Installation](#installation)
    - [Validation](#validation)
    - [Generation](#generation)
  - [Advanced Usage](#advanced-usage)
    - [Working with Birth Dates](#working-with-birth-dates)
    - [Using the Luhn Algorithm Directly](#using-the-luhn-algorithm-directly)
  - [Error Handling](#error-handling)
  - [Performance Considerations](#performance-considerations)
  - [Use Cases](#use-cases)

## Understanding AMKA

An AMKA (Αριθμός Μητρώου Κοινωνικής Ασφάλισης) is a unique 11-digit identification number used in Greece. It's similar to a Social Security Number in the United States and follows these rules:

1. It's always exactly 11 digits long
2. The first 6 digits represent the person's date of birth in format DDMMYY
3. The number (as a whole) must pass validation by the Luhn algorithm
4. The last digit is a check digit computed using the Luhn algorithm

## Basic Usage

### Installation

Add the gem to your Gemfile:

```ruby
gem 'amka'
```

Or install it directly:

```bash
gem install amka
```

Then require it in your code:

```ruby
require 'amka'
```

### Validation

You can validate an AMKA number with a simple call:

```ruby
# Basic validation
Amka.valid?('01019012345')  # => true or false

# The validation checks:
# 1. If it's exactly 11 digits
# 2. If the first 6 digits form a valid date (ddmmyy)
# 3. If the number passes the Luhn algorithm check
```

When working with dates from different centuries, you can provide the 4-digit year for more accurate validation:

```ruby
# Explicitly specify century for validation
Amka.valid?('01019012345', '1990')  # => true
Amka.valid?('01019012345', '2090')  # => false (if the year doesn't match)
```

### Generation

You can generate random valid AMKA numbers:

```ruby
# Generate a random valid AMKA
amka = Amka.generate  # => "01019012345"
```

Or generate an AMKA with a specific birth date:

```ruby
# Generate an AMKA for someone born January 1, 1990
amka = Amka.generate('1/1/1990')  # => "01019012345"

# Days and months can be 1 or 2 digits
amka = Amka.generate('15/12/1985')  # => "15128512345"
```

## Advanced Usage

### Working with Birth Dates

The first 6 digits of an AMKA represent a date of birth in DDMMYY format:

```ruby
amka = '01019012345'
birth_date = Date.strptime(amka[0..5], '%d%m%y')  # => #<Date: 1990-01-01>

# For ambiguous 2-digit years, you might need to adjust the century
if birth_date > Date.today
  birth_date = Date.strptime(amka[0..3] + '19' + amka[4..5], '%d%m%Y')
end
```

### Using the Luhn Algorithm Directly

The gem includes a standalone implementation of the Luhn algorithm that can be used for other purposes:

```ruby
# Validate any number against the Luhn algorithm
Amka::Luhn.valid?('4532015112830366')  # => true (valid credit card number)
Amka::Luhn.valid?('1234567890')        # => false

# Generate a valid Luhn number of specific length
luhn_id = Amka::Luhn.generate(16)  # => "4532015112830366"

# Generate a valid Luhn number with a specific prefix
luhn_id = Amka::Luhn.generate(16, '4532')  # => "4532015112830366"
```

## Error Handling

The gem will raise descriptive `ArgumentError` exceptions for invalid inputs:

```ruby
begin
  Amka.valid?(12345)  # Not a string
rescue ArgumentError => e
  puts e.message  # => "'12345': must be a string of digits only!"
end

begin
  Amka.generate('invalid-date')
rescue ArgumentError => e
  puts e.message  # => "date of birth must be in this format: [d]d/[m]m/yyyy"
end

begin
  Amka.generate('31/2/1990')  # February 31st doesn't exist
rescue ArgumentError => e
  puts e.message  # => "The date of birth is invalid!"
end
```

## Performance Considerations

- The validation and generation methods are lightweight and suitable for high-volume use
- No external dependencies are required
- All operations are performed in memory without any I/O

## Use Cases

- Government systems that need to validate AMKA numbers
- Healthcare applications that need to work with patient identification
- Testing systems that need to generate sample data
- Any application that needs to implement the Luhn algorithm validation
- Form validation for Greek websites
