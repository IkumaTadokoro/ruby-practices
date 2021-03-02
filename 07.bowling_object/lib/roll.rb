# frozen_string_literal: true

class Roll
  attr_reader :score

  def initialize(mark)
    @score = mark == 'X' ? 10 : mark.to_i
  end
end
