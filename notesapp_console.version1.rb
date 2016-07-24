#require 'neo4j-core'
require 'neo4j'
require 'securerandom'
require 'rexml/document'
require 'plist'
require 'json'
require 'paperclip'
require 'neo4jrb_paperclip'

# require local:

require_relative 'Class_Artefact'
require_relative 'Classes_AbsoluteDateNodes'
#require_relative 'Class_AbsoluteDateTimeRoot'
#require_relative 'Classes_AbsoluteTimes'
require_relative 'Class_GeospatialNode'
require_relative 'Classes_Devices'
require_relative 'Class_Tag'

require_relative 'Class_AudioRecording'
require_relative 'Class_DayOneEntry'
require_relative 'Class_Agent'
require_relative 'Library_ingestDayOne'
require_relative 'Library_TimeTree'
require_relative 'Library_CreateTestNodes'
require_relative 'Library_IngestAudioRecording'

## Quick Cyphers as notes:

## Should match all specific areas in an area 2016-02-27 @12:43:01
# MATCH (n)<-[r:SEMANTIC_ZOOM_OUT]-(m)<-[r2:SEMANTIC_ZOOM_OUT]-(o)<-[r3]-(p) where n.name = "45.83, -64.21" RETURN r, r2, r3 LIMIT 50

## Should match all notes in an area 2016-02-27 @16:42:57
# MATCH (n)<-[r:GEOSPATIAL_SEMANTIC_ZOOM_OUT]-(m)<-[r2:GEOSPATIAL_SEMANTIC_ZOOM_OUT]-(p)-[r4:GEOSPATIAL_RECORDED_AT]-(q) where n.name = "45.82, -64.20" RETURN r4 LIMIT 10

## Should match all 1s-resolution notes in a year:
# MATCH (n)<-[r1:DATETIME_SEMANTIC_ZOOM_OUT]-(m)<-[r2:DATETIME_SEMANTIC_ZOOM_OUT]-(p)<-[r3:DATETIME_SEMANTIC_ZOOM_OUT]-(p2)<-[r4:DATETIME_SEMANTIC_ZOOM_OUT]-(p3)<-[r6:DATETIME_SEMANTIC_ZOOM_OUT]-(p4)<-[r5:DATETIME_RECORDED_AT]-(q) where n.name = "2015" RETURN  r6, r4, r3, r2, r1, r5 LIMIT 100

## Same, but allows n-depth traversal
# MATCH (n)<-[r1:DATETIME_SEMANTIC_ZOOM_OUT*1..]-(m)<-[r2:DATETIME_RECORDED_AT]-(q) where n.name = "2015" RETURN  r1, r2 LIMIT 100
# Returned 444 nodes

# This time matching within a day:
# MATCH (n)<-[r1:DATETIME_SEMANTIC_ZOOM_OUT*1..]-(m)<-[r2:DATETIME_RECORDED_AT]-(q) where n.name = "20150203" RETURN  r1, r2 LIMIT 100 ## You get the idea
# Took 200ms and returned 244 nodes

# MATCH (n)<-[r1:DATETIME_SEMANTIC_ZOOM_OUT*1..]-(m)<-[r2:DATETIME_RECORDED_AT]-(q) where n.name = "20160203_23" RETURN  r1, r2 LIMIT 100
# Took 178ms. Thought it was slower than specifying the depth, but could have just been server lag as on re-run they were similar

session = Neo4j::Session.open(:server_db, "http://localhost:7474", { basic_auth: { username: 'neo4j', password: 'y2puv8VrUCHtAf'} })

class Integer
  def floor2(exp = 0)
   multiplier = 10 ** exp
   ((self / multiplier).floor) * multiplier
  end
end

class Float
  def floor2_s(n=0)
    int,dec=self.to_s.split('.')
    # puts "self: #{self}"
    if n == 0
      # puts "#{int}"
      "#{int}"
    else
      # puts "#{int}.#{dec[0..n-1]}"
      "#{int}.#{dec[0..n-1]}"
    end
  end
end


def reload()
  load("./notesapp_console.version1.rb")
end

def r()
  reload()
end


#:ARTEFACT_INGESTED_AT needs properties like username, and content that was edited? (still some conceptual work to be done here)








# def look()
#   player = Person.find_by(username: 'morty')
#   #puts player.name
#   #puts player.desc

# #  puts "#{player.room[:name].tr!('_', ' ')} (#{player.room[:uuid][0,10]})" #If we move to room names with underscores instead of spaces
#   puts "#{player.room[:name]} (#{player.room[:uuid][0,10]})"
#   puts player.room[:desc]
# #  puts player.uuid

#   puts "\nContents:"
#   player.room.thing.each do |thing|
#     if thing.name != "morty"
#       puts "#{thing[:name]}"
#     end
#   end


#   puts "\nObvious Exits:"
#   player.room.door.each do |door|
#     print "#{door[:name]}  "
#   end
#   puts ""
# end

# def l()
#   look()
# end

# def e(string)
#   examine(string)
# end

# def examine(string)
#   # This should be refactored so that examine simply
#   # shows all properties and thier names
#   # without having to manually parse them
#   # [x] Done


#   player = Person.find_by(username: 'morty')

#   if examinedThing = player.room.thing.find_by(normalized_name: string.downcase) # Search starting with things in the room
#     displayAttributes(examinedThing)
#   elsif examinedThing = player.held.find_by(name: string) # Move to inventory
#     displayAttributes(examinedThing)
#   elsif examinedPlayer = player.room.person.find_by(normalized_name: string.downcase) # Move on to players in the room
#     displayAttributes(examinedPlayer)
#   elsif examinedDoor = player.room.door.find_by(name: string) # Now check if player is looking at a door
#     displayAttributes(examinedDoor)
#   else
#     puts "I don't see that here."
#   end
# end


# def lookat(string)
#   player = Person.find_by(username: 'morty')
#   if thing = player.room.thing.find_by(normalized_name: string.downcase)
#     puts thing[:desc]
#   elsif otherPlayer = player.room.person.find_by(normalized_name: string.downcase)
#     puts otherPlayer[:desc]
#   elsif door = player.room.door.find_by(normalized_name: string.downcase)
#     puts otherPlayer[:desc]
#   else
#     puts "I don't see that here."
#   end
# end


# def displayAttributes(object)
#   puts "#{object[:name]} (#{object[:uuid]})"
# #  puts thing[:desc]
#   object.attributes.each do |attribute|
#     if attribute[1] #If the attribute is set, show it. Otherwise don't.
#       puts "#{object[:name]}.#{attribute[0]} = \"#{attribute[1]}\""
#     end
#   end
#   puts "Owned by object[:owner]"
# end

# def go(doorName)
#   gotoexit(doorName)
# end

# def gotoexit(doorName)
#   player = Person.find_by(username: 'morty')
#   if potentialExit = player.room.door.find_by(name: doorName)
#     #puts "Door found: #{potentialExit}"
#     if potentialRoomUUID = potentialExit.roomTo.uuid #get the UUID of where we're going

#     # moveRoomsQuery is an ugly hack, but it works. THis should definitely change to the ActiveNode way of doing things
#     moveRoomsQuery = "
#       MATCH (a:Person { name:'morty' })<-[r:CONTAINS]-(b), (c:Room {uuid: '#{potentialRoomUUID}'})
#       MERGE (a)<-[r2:CONTAINS]-(c)
#       ON CREATE SET r2 += r
#       DELETE r
#       return r2
#     "
#     #session = Neo4j::Session.open(:server_db, "http://localhost:7474", { basic_auth: { username: 'neo4j', password: 'y2puv8VrUCHtAf'} })
#     session.query(moveRoomsQuery)

#     look()
#     end
# # This is the cypher query that moves a player:
# # MATCH (a:Person  { name:'morty' })<-[r:CONTAINS]-(b), (c:Room {uuid: '61bb3f21-c513-11e5-951c-0800274d3a1f'})
# # MERGE (a)<-[r2:CONTAINS]-(c)
# # ON CREATE SET r2 += r // This copies all relationship properties to r2
# # DELETE r
# # return r2
#   else
#       puts "Could not find the exit you specified."
#   end
# # Conversion to ActiveNode:

# end

# def create(name, description)
#   player = Person.find_by(username: 'morty')
#   object = Thing.new
#   object.name = name
#   object.desc = description
#   player.room.thing << object
# end
