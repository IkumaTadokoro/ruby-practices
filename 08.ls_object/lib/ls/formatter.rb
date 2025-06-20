# frozen_string_literal: true

module Ls
  class Formatter
    require 'etc'
    require_relative 'app_option'
    require_relative 'file_list'

    COLUMN_WIDTH = 3 # Terminalの幅に合わせた出力には未対応

    def initialize
      @option = Ls::AppOption.new
      @file_list = Ls::FileList.new(@option)
    end

    def output = @option.has?(:l) ? long_list : short_list

    private

    def long_list = [header, body.map { |row| row.join(' ') }].join("\n")

    def short_list = file_rows.map { |row| row.join("\t") }

    def header = "total #{@file_list.total_blocks}"

    def body
      @file_list.files.map do |file|
        [
          format_item(file, :r, :permission, 0),
          format_item(file, :r, :hard_link_size, @file_list.max_nlink_length + 1),
          format_item(file, :l, :owner_name, file.owner_name.length + 1),
          format_item(file, :r, :group_name, 0),
          format_item(file, :r, :byte_size, @file_list.max_size_length + 1),
          format_item(file, :r, :edited_month_date, 0),
          format_item(file, :r, :edited_year, @file_list.max_edited_year_length),
          format_item(file, :r, :basename, 0)
        ]
      end
    end

    def file_rows
      @file_list.files
                .map { |file| format_item(file, :l, :basename, @file_list.max_file_name_length) }
                .tap { |a| a.push(*blanks) }
                .each_slice(row_width).to_a
                .transpose
    end

    def format_item(target, direction, column, adjust_size)
      target.send(column).to_s.send("#{direction}just", adjust_size)
    end

    def blanks = fraction.zero? ? [] : [''] * (COLUMN_WIDTH - fraction)

    def fraction = @file_list.files.length % COLUMN_WIDTH

    def row_width = (@file_list.files.length + blanks.length) / COLUMN_WIDTH
  end
end
