require 'test_helper'

class AmkaTest < Minitest::Test

  def test_amka_generation
    100.times do
      amka = Amka.generate

      # length must equal 11
      assert_equal 11, amka.length

      # first 6 digits must be a valid date
      assert_instance_of Date, Date.strptime(amka[0..5], '%d%m%y')

      # make sure the amka is valid according to the Luhn algorithm
      assert Amka::Luhn.valid? amka
    end
  end

  def test_amka_not_valid_when_not_valid_date_in_first_6_digits_but_valid_luhn
    luhn_valid_ids = %w(97909369536 72021984173 10133701093 10185628285)

    # first assert that ids are valid according to Luhn algorithm
    valid_luhns = luhn_valid_ids.select { |id| Amka::Luhn.valid? id }
    assert_equal 4, valid_luhns.length

    # then assert that these ids are not valid AMKAs
    valid_amka = luhn_valid_ids.select { |id| Amka.valid? id }
    assert_equal 0, valid_amka.length

    # and they are not valid because date is invalid
    4.times.with_index do |i|
      e = assert_raises ArgumentError do
        Date.strptime(luhn_valid_ids[i][0..5], '%d%m%y')
      end
      assert_equal 'invalid date', e.message
    end

    # And to prove that invalid date caused the AMKAs not to be valid,
    # lets make the Utils.valid_date? class method that is called
    # by Amka.valid? to return always true.
    Amka::Utils.stubs(:valid_date?).returns(true)
    false_positive_valid_amka = luhn_valid_ids.select { |id| Amka.valid? id }
    assert_equal 4, false_positive_valid_amka.length
  end

  def test_amka_not_valid_when_valid_date_but_invalid_luhn
    date_valid_ids = %w(11118734597 02039936475 20127837465 09080237485)

    # first assert that dates are valid
    date_valid = date_valid_ids.select { |id| Date.strptime(id[0..5], '%d%m%y') and true }
    assert_equal 4, date_valid.length

    # then assert that these ids are not valid amka
    valid_amka = date_valid_ids.select { |id| Amka.valid? id }
    assert_equal 0, valid_amka.length

    # and they are not valid because they fail the Luhn algorithm
    valid_luhn = date_valid_ids.select { |id| Amka::Luhn.valid? id }
    assert_equal 0, valid_luhn.length

    # and to prove the above assertion lets stub the Luhn.valid? class method
    # that is called by Amka.valid?
    Amka::Luhn.stubs(:valid?).returns(true)
    false_positive_valid_amka = date_valid_ids.select { |id| Amka.valid? id }
    assert_equal 4, false_positive_valid_amka.length
  end

end
