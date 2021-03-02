# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/roll'

class RollTest < Minitest::Test
  def test_score_not_strike
    roll = Roll.new('9')
    assert_equal 9, roll.score
  end

  def test_score_strike
    roll = Roll.new('X')
    assert_equal 10, roll.score
  end
end
