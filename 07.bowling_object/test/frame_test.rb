# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'
require_relative '../lib/shot'

class FrameTest < Minitest::Test
  def test_strike_before_last_frame
    frame = Frame.new('X')
    assert frame.strike?
  end

  def test_strike_at_last_frame
    frame = Frame.new('X', '2', '4')
    assert frame.strike?
  end

  def test_not_strike
    frame = Frame.new('1', '9')
    refute frame.strike?
  end

  def test_spare_before_last_frame
    frame = Frame.new('0', '10')
    assert frame.spare?
  end

  def test_spare_at_last_frame
    frame = Frame.new('4', '6', '3')
    assert frame.spare?
  end

  def test_not_spare
    frame = Frame.new('3', '6')
    refute frame.spare?
  end

  def test_score_before_last_frame
    frame = Frame.new('1', '7')
    assert_equal 8, frame.score
  end

  def test_score_at_last_frame
    frame = Frame.new('2', '8', '3')
    assert_equal 13, frame.score
  end

  def test_bonus_score_at_last_frame
    current_frame = Frame.new('3', '7', '2')
    next_frame = nil
    after_next_frame = nil
    assert_equal 0, current_frame.bonus_score(next_frame, after_next_frame)
  end

  def test_bonus_score_no_spare_and_no_strike
    current_frame = Frame.new('3', '5')
    next_frame = Frame.new('2', '7')
    after_next_frame = Frame.new('4', '3')
    assert_equal 0, current_frame.bonus_score(next_frame, after_next_frame)
  end

  def test_bonus_score_with_spare
    current_frame = Frame.new('6', '4')
    next_frame = Frame.new('2', '7')
    after_next_frame = Frame.new('1', '3')
    assert_equal 2, current_frame.bonus_score(next_frame, after_next_frame)
  end

  def test_bonus_score_with_strike_before_frame9_and_next_frame_is_not_strike
    current_frame = Frame.new('X')
    next_frame = Frame.new('2', '7')
    after_next_frame = Frame.new('1', '3')
    assert_equal 9, current_frame.bonus_score(next_frame, after_next_frame)
  end

  def test_bonus_score_with_strike_before_frame9_and_next_frame_is_strike
    current_frame = Frame.new('X')
    next_frame = Frame.new('X')
    after_next_frame = Frame.new('1', '3')
    assert_equal 11, current_frame.bonus_score(next_frame, after_next_frame)
  end

  def test_bonus_score_with_strike_at_frame9
    current_frame = Frame.new('X')
    next_frame = Frame.new('3', '7', '2')
    after_next_frame = nil
    assert_equal 10, current_frame.bonus_score(next_frame, after_next_frame)
  end
end
