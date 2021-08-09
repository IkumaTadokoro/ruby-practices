#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

class LsCommand
  COLUMN_WIDTH = 2 # Terminalの幅に合わせた出力には未対応
  COLUMN_WIDTH_ONE_LINE = 1
  ADJUST_SIZE = 1
  OCTAL = 8
  BINARY = 2
  ROLL = { owner: -3, group: -2, other: -1 }.freeze

  attr_accessor :file_list, :file_stats, :options

  def initialize
    @file_list = []
    @file_stats = []
    @options = {}
    OptionParser.new do |opt|
      opt.on('-a') { |v| @options[:a] = v }
      opt.on('-l') { |v| @options[:l] = v }
      opt.on('-r') { |v| @options[:r] = v }
      opt.on('-1') { |v| @options[1] = v } # 追加で1オプションを実装
      opt.parse!(ARGV)
    end
  end

  def to_s
    list_data.join("\n")
  end

  private

  def list_data
    select_search_range
    select_order
    @file_stats = @file_list.map { |file| File.lstat(file) }
    options.include?(:l) ? long_list : short_list
  end

  def select_search_range
    flags = options.include?(:a) ? File::FNM_DOTMATCH : 0
    patterns = '*'
    @file_list = Dir.glob(patterns, flags).sort
  end

  def select_order
    @file_list.reverse! if options.include?(:r)
  end

  def short_list
    file_rows.map do |row|
      row.map { |file| file.to_s.ljust(max_file_name_length) }.join("\t")
    end
  end

  def file_rows
    (COLUMN_WIDTH - @file_list.length % COLUMN_WIDTH).times { @file_list << nil } unless (@file_list.length % COLUMN_WIDTH).zero?
    @file_list.each_slice(row_width).to_a.transpose
  end

  def row_width
    @file_list.length / col_width
  end

  def col_width
    options.include?(1) ? COLUMN_WIDTH_ONE_LINE : COLUMN_WIDTH
  end

  def max_file_name_length
    @file_list.compact.max_by(&:length).length
  end

  def long_list
    header + body
  end

  def header
    ["total #{@file_stats.map(&:blocks).sum}"]
  end

  def body
    @file_list.map do |file|
      [
        get_permission(file),
        get_hard_link_size(file),
        get_owner_name(file),
        get_group_name(file),
        get_byte_size(file),
        get_timestamp(file),
        get_file_name(file)
      ]
    end.map { |row| row.join(' ') }
  end

  def get_permission(file)
    get_file_type(file) + get_owner_roll(file) + get_group_roll(file) + get_other_roll(file)
  end

  def get_file_type(file)
    { 'file': '-', 'directory': 'd', 'link': 'l' }[File.lstat(file).ftype.to_sym]
  end

  def get_owner_roll(file)
    get_roll_string(:owner).call(File.lstat(file))
  end

  def get_group_roll(file)
    get_roll_string(:group).call(File.lstat(file))
  end

  def get_other_roll(file)
    get_roll_string(:other).call(File.lstat(file))
  end

  # Mac拡張属性には未対応
  def get_roll_string(roll)
    lambda do |file|
      octal = file.mode.to_s(OCTAL)[ROLL[roll]]
      binary = octal.to_i.to_s(BINARY)
      read = (binary[0] == '1' ? 'r' : '-')
      write = (binary[1] == '1' ? 'w' : '-')
      execute = (binary[2] == '1' ? 'x' : '-')
      read + write + execute
    end
  end

  def get_hard_link_size(file)
    File.lstat(file).nlink.to_s.rjust(max_nlink_length)
  end

  def get_owner_name(file)
    "#{Etc.getpwuid(File.lstat(file).uid).name} "
  end

  def get_group_name(file)
    Etc.getgrgid(File.lstat(file).gid).name
  end

  def get_byte_size(file)
    File.lstat(file).size.to_s.rjust(max_size_length)
  end

  def get_timestamp(file)
    File.lstat(file).mtime.strftime(' %-m %d %H:%M')
  end

  def get_file_name(file)
    File.lstat(file).symlink? ? "#{file} -> #{File.readlink(file)}" : file
  end

  def max_size_length
    @file_stats.map(&:size).max.to_s.length + ADJUST_SIZE
  end

  def max_nlink_length
    @file_stats.map(&:nlink).max.to_s.length + ADJUST_SIZE
  end
end

def main
  ls = LsCommand.new
  puts ls.to_s
end

main if __FILE__ == $PROGRAM_NAME
