# frozen_string_literal: true

require_relative './roll'

class Frame
  NUMBER_OF_PINS = 10
  NO_BONUS = 0

  attr_reader :roll1, :roll2, :roll3

  def initialize(mark1, mark2 = nil, mark3 = nil)
    @roll1 = Roll.new(mark1)
    @roll2 = Roll.new(mark2)
    @roll3 = Roll.new(mark3)
  end

  def score
    roll1.score + roll2.score + roll3.score
  end

  def bonus_score(next_frame, after_next_frame)
    return NO_BONUS if next_frame.nil? || (!strike? && !spare?)
    return spare_bonus(next_frame) if spare?

    strike_bonus(next_frame, after_next_frame) if strike?
  end

  def strike?
    roll1.score == NUMBER_OF_PINS
  end

  def spare?
    !strike? && roll1.score + roll2.score == NUMBER_OF_PINS
  end

  private

  def spare_bonus(next_frame)
    next_frame.roll1.score
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike? && !after_next_frame.nil?
      next_frame.roll1.score + after_next_frame.roll1.score
    else
      next_frame.roll1.score + next_frame.roll2.score
    end
  end
end
