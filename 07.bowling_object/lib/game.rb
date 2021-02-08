# frozen_string_literal: true

require_relative './frame'

class Game
  FRAME_SIZE = 10

  attr_reader :marks

  def initialize(marks)
    @marks = marks.split(',')
  end

  def score
    frames = build_frames
    FRAME_SIZE.times.sum do |idx|
      current_frame, next_frame, after_next_frame = frames[idx, 3]
      current_frame.score + current_frame.bonus_score(next_frame, after_next_frame)
    end
  end

  private

  def build_frames
    Array.new(FRAME_SIZE - 1) { marks[0] == 'X' ? marks.shift(1) : marks.shift(2) }
         .concat([marks])
         .map { |shot1, shot2, shot3| Frame.new(shot1, shot2, shot3) }
  end
end
