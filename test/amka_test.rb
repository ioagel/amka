require 'test_helper'

class AmkaTest < Minitest::Test
  def test_amka_generation
    amka = Amka.generate

    # length must equal 11
    assert_equal 11, amka.length

    # first 6 digits must be a valid date
    assert Date.strptime(amka[0..5], '%d%m%y')
  end
end
