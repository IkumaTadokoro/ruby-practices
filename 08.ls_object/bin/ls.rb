#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ls/formatter'

if __FILE__ == $PROGRAM_NAME
  ls = Ls::Formatter.new
  puts ls.output
end
