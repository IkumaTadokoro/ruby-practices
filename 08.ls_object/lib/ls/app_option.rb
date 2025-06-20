# frozen_string_literal: true

require 'optparse'

module Ls
  class AppOption

    def initialize
      @options = {}
      OptionParser.new do |opt|
        opt.on('-a') { |v| @options[:a] = v }
        opt.on('-l') { |v| @options[:l] = v }
        opt.on('-r') { |v| @options[:r] = v }
        opt.parse!(ARGV)
      end
    end

    def has?(option_name) = @options.include?(option_name)

    def args = ARGV[0]
  end
end
