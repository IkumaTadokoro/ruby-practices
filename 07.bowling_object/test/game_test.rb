# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/roll'

class GameTest < Minitest::Test
  def test_score_no_spare_and_no_strike
    game = Game.new('2,2,5,3,4,3,1,6,8,1,3,6,3,3,7,2,1,8,1,5,')
    assert_equal 74, game.score
  end

  def test_score_spare_and_no_strike
    game = Game.new('2,2,5,5,4,3,1,6,8,2,3,6,7,3,7,2,1,8,1,5')
    assert_equal 95, game.score
  end

  def test_score_no_spare_and_strike
    game = Game.new('2,2,5,2,4,3,X,8,1,3,6,7,2,X,X,1,5')
    assert_equal 107, game.score
  end

  def test_score_all_zero
    game = Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game.score
  end

  def test_score_prepared_by_practice_a
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.score
  end

  def test_score_prepared_by_practice_b
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.score
  end

  def test_score_prepared_by_practice_c
    game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.score
  end

  def test_score_prepared_by_practice_d
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.score
  end

  def test_score_prepared_by_practice_e
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.score
  end
end
