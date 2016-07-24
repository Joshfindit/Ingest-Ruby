#!/usr/bin/env ruby
require 'optparse'
require 'time'
require 'date'
require 'json'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: Splits a datetime-sensitve (mp3) audio file in to mini-segments and adds json metadata next to it."

  opts.on('-c', '--command "Cypher command"', 'Command to run against the server') { |v| options[:command] = v }
  opts.on('-s', '--suppress', 'Suppress all output except for success') { |v| options[:suppressOutput] = v }

end.parse!

#if options[:timeFormat].nil?
#	options[:timeFormat] = "%Y-%m-%d@%H%M%S"
#end



#-d '{"statements":[{"statement":"MATCH (p1:PROFILES)-[:RELATION]-(p2) RETURN ..."}]}'


puts `curl -s  -H accept:application/json -H content-type:application/json -u neo4j:neo4j -d "#{options[:command]}" http://localhost:7474/db/manage/server/console`

