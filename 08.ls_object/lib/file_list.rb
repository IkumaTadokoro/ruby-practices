# frozen_string_literal: true

class FileList
  require_relative 'directory_entry'

  attr_reader :directory_entries

  def initialize(option)
    @option = option
    @directory_entries = file_names.map { |name| DirectoryEntry.new(name) }
  end

  def stats = directory_entries.map(&:stat)

  def total_blocks = stats.map(&:blocks).sum

  def max_size_length = stats.map(&:size).max.to_s.length

  def max_nlink_length = stats.map(&:nlink).max.to_s.length

  def max_file_name_length = directory_entries.compact.map(&:basename).max_by(&:length).length

  private

  def file_names
    patterns = args_is_file? ? @option.args : '*'
    flags = @option.has?(:a) ? File::FNM_DOTMATCH : 0
    base = args_is_directory? ? @option.args : nil

    files = Dir.glob(patterns, flags, base: base)
    file_names = args_is_directory? ? files.map { |file| "#{base}/#{file}" } : files
    @option.has?(:r) ? file_names.reverse! : file_names
  end

  def args_is_file? = @option.args && File.file?(@option.args)

  def args_is_directory? = @option.args && File.directory?(@option.args)
end
