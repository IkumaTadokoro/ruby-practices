# frozen_string_literal: true

require_relative 'roll'

class Frame
  NUMBER_OF_PINS = 10
  NO_BONUS = 0

  attr_reader :score_of_roll1, :score_of_roll2, :score_of_roll3

  def initialize(mark1, mark2 = nil, mark3 = nil)
    @score_of_roll1 = Roll.new(mark1).score
    @score_of_roll2 = Roll.new(mark2).score
    @score_of_roll3 = Roll.new(mark3).score
  end

  def score
    score_of_roll1 + score_of_roll2 + score_of_roll3
  end

  def bonus_score(next_frame, after_next_frame)
    return NO_BONUS if next_frame.nil? || (!strike? && !spare?)
    return spare_bonus(next_frame) if spare?

    strike_bonus(next_frame, after_next_frame) if strike?
  end

  def strike?
    score_of_roll1 == NUMBER_OF_PINS
  end

  def spare?
    !strike? && score_of_roll1 + score_of_roll2 == NUMBER_OF_PINS
  end

  private

  def spare_bonus(next_frame)
    next_frame.score_of_roll1
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike? && !after_next_frame.nil?
      next_frame.score_of_roll1 + after_next_frame.score_of_roll1
    else
      next_frame.score_of_roll1 + next_frame.score_of_roll2
    end
  end
end
