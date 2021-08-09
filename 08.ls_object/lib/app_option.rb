# frozen_string_literal: true

class AppOption
  require 'optparse'

  def initialize
    @options = {}
    OptionParser.new do |opt|
      opt.on('-a') { |v| @options[:a] = v }
      opt.on('-l') { |v| @options[:l] = v }
      opt.on('-r') { |v| @options[:r] = v }
      opt.on('-1') { |v| @options[1] = v } # 追加で1オプションを実装
      opt.parse!(ARGV)
    end
  end

  def has?(option_name) = @options.include?(option_name)

  def args = ARGV[0]
end
