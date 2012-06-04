#!usr/bin/env ruby
#-*- coding: utf-8 -*-

# Author: jasl

# This function is for traverse directory.
# The first argument is path where you want to traverse,
# second is an array and it's optional if you don't want
# to find given file extension, third is an array
# if you don't want to filter file.
# You can given a block to operate files as you want.
#
# Notice: The second and the third arguments are not support regex.
def traverse_dir path, ext_names = [], black_list = [], &block
	if File.directory? path
		Dir.foreach path do |file|
			unless /^\./i.match file or black_list.include?(file)
				file = path + '/' + file
				if File.directory? file
          traverse_dir(file, ext_names, black_list, &block)
				elsif ext_names.empty? or ext_names.include? File.extname(file)
					block.call file if block_given?
				end
			end
		end
	end
end

if ARGV.empty?
  puts 'give a path plz.'
  exit
end

file_path = ARGV[0]
ext_names = ['.rb']
black_list = []

lines = 0
count = 0

traverse_dir file_path, ext_names, black_list do |f|
  IO.readlines(f).each do |line|
    lines += 1 unless line == "\n" or line.include?('#')
  end
  count += 1
end

p "total files: #{count} lines: #{lines}"

