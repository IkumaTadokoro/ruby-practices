#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ls_formatter'

if __FILE__ == $PROGRAM_NAME
  ls = LsFormatter.new
  puts ls.output
end
