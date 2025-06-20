# frozen_string_literal: true

require 'etc'
require 'date'

module Ls
  class File

    OCTAL = 8
    BINARY = 2
    ROLL = { owner: -3, group: -2, other: -1 }.freeze

    def initialize(name)
      @name = name
    end

    def stat = ::File.lstat(@name)

    def permission = file_type + owner_roll + group_roll + other_roll

    def hard_link_size = stat.nlink.to_s

    def owner_name = Etc.getpwuid(stat.uid).name

    def group_name = Etc.getgrgid(stat.gid).name

    def byte_size = stat.size.to_s

    def edited_month_date = stat.mtime.strftime('%b %e')

    def edited_year
      edited_at = stat.mtime
      edited_at_six_months_ago?(edited_at) ? edited_at.strftime('%Y') : edited_at.strftime('%H:%M')
    end

    def basename = ::File.basename(@name)

    private

    def file_type = { 'file': '-', 'directory': 'd', 'link': 'l' }[stat.ftype.to_sym]

    def owner_roll = get_roll_string(:owner).call(stat)

    def group_roll = get_roll_string(:group).call(stat)

    def other_roll = get_roll_string(:other).call(stat)

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

    def edited_at_six_months_ago?(time)
      (Date.today << 6 <=> Date.parse(time.to_s)) == 1
    end
  end
end
