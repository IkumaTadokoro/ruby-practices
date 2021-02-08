# frozen_string_literal: true

require_relative './shot'

class Frame
  NUMBER_OF_PINS = 10
  NO_BONUS = 0

  attr_reader :shot1, :shot2, :shot3

  def initialize(mark1, mark2 = nil, mark3 = nil)
    @shot1 = Shot.new(mark1)
    @shot2 = Shot.new(mark2)
    @shot3 = Shot.new(mark3)
  end

  def score
    shot1.score + shot2.score + shot3.score
  end

  def bonus_score(next_frame, after_next_frame)
    return NO_BONUS if next_frame.nil? || (!strike? && !spare?)
    return spare_bonus(next_frame) if spare?

    strike_bonus(next_frame, after_next_frame) if strike?
  end

  def strike?
    shot1.score == NUMBER_OF_PINS
  end

  def spare?
    !strike? && shot1.score + shot2.score == NUMBER_OF_PINS
  end

  private

  def spare_bonus(next_frame)
    next_frame.shot1.score
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike? && !after_next_frame.nil?
      next_frame.shot1.score + after_next_frame.shot1.score
    else
      next_frame.shot1.score + next_frame.shot2.score
    end
  end
end
