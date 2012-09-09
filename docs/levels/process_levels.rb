#!/usr/bin/env ruby

names = []
Dir['./**/*.txt'].each do |f| 
  file = File.open(f, 'r')
  raw = file.read
  
  #strip out newlines, convert \" to ', and get rid of extra whitespace
  level = raw.gsub("\n","").gsub("\"","'").gsub(/( |('.*?'))/, "\\2")
  id = f.split('/').last.split('.').first.to_i
  names << "LEVEL_#{id}"
  
  #because you can't stop p from putting start and end quotes, using QQ instead of quotes to make post-processing easier
  p "public static var LEVEL_#{id}:String = SINGLEQUOTE#{level}SINGLEQUOTE;"
end

p "public static function get levels():Array { return[#{names.join(',')}];}"

#./process_levels.rb | sed -e 's/\"//g' -e "s/\'/\"/g" -e "s/SINGLEQUOTE/\'/g" | pbcopy