def ingestDayOneEntry(filename)
  # require "rexml/document"
  # Note: There is no reason to add the "origional" and "current" metadata layer in the other artefact types
  # Change this to be just origional

  file = File.new( filename ) # Create file object from filename
  
  # Check if it parses successfully as an XML file
  if parsedEntry = Plist::parse_xml(file)

    # Report to the user
    puts "Found and parsed #{parsedEntry['UUID']}."
    parsedEntry['Creation Date']

    # The filename is unique since it's a pre-generated UUID, so we can use it as a primary key
    # Merge based on the name
    entryNode = DayOneEntry.merge(name: parsedEntry['UUID'])


    # Creator: Set the creator staticly (Will switch to via metadata later)
    thisEntryCreator = Agent.merge(name: "Joshua Buxton")


    # Geospatial: If the entry has a location, merge it to the location node based on the lat/long
    if parsedEntry['Location']
      if parsedEntry['Location']['Latitude'] && parsedEntry['Location']['Longitude']

        # We're only going to 4 decimal places, which is about 10m
        thisEntryLocationRounded = "#{parsedEntry['Location']['Latitude'].floor2_s(4)}, #{parsedEntry['Location']['Longitude'].floor2_s(4)}"
        # Connect this entry to it's 10m area. Using the format `lat, long` (example: `45.538, -64.249`) as unique identifier
        thisEntryLocation = GeospatialNode.merge(name: thisEntryLocationRounded )

        # Merge from the specific to the general, connecting finally to the integer value (example: `45, -64). Using a tree structure to support zoom in/out
        thisEntryLocationZoom3Floored = "#{parsedEntry['Location']['Latitude'].floor2_s(3)}, #{parsedEntry['Location']['Longitude'].floor2_s(3)}"
        thisEntryLocationZoom2Floored = "#{parsedEntry['Location']['Latitude'].floor2_s(2)}, #{parsedEntry['Location']['Longitude'].floor2_s(2)}"
        thisEntryLocationZoom1Floored = "#{parsedEntry['Location']['Latitude'].floor2_s(1)}, #{parsedEntry['Location']['Longitude'].floor2_s(1)}"
        thisEntryLocationZoom0Floored = "#{parsedEntry['Location']['Latitude'].floor2_s(0)}, #{parsedEntry['Location']['Longitude'].floor2_s(0)}"
        thisEntryLocationZoom3 = GeospatialNode.merge(name: thisEntryLocationZoom3Floored )
        thisEntryLocationZoom2 = GeospatialNode.merge(name: thisEntryLocationZoom2Floored )
        thisEntryLocationZoom1 = GeospatialNode.merge(name: thisEntryLocationZoom1Floored )
        thisEntryLocationZoom0 = GeospatialNode.merge(name: thisEntryLocationZoom0Floored )
        
      end
    end

    # DateTime: Connect the entry to the node for the second it was created
    thisEntrySecond = parsedEntry['Creation Date'].strftime("%Y%m%d_%H%M%S")
    thisEntryDatetimeSecond = Second.merge(name: thisEntrySecond)
    # puts thisEntryDatetimeSecond.name

    # Device it was recorded at: (For example: iPhone, laptop, etc.). Using the host name as unique identifier for now
    if parsedEntry['Creator'] # In DayOne, `Creator` actually means the device
      if parsedEntry['Creator']['OS Agent'].include?("iOS") #Doing different node types depending on if it's mobile or not
        thisEntryDevice = Device.merge(name: parsedEntry['Creator']['Host Name'])
      elsif parsedEntry['Creator']['OS Agent'].include?("MacOS")
        thisEntryDevice = Computer.merge(name: parsedEntry['Creator']['Host Name'])
      end
    end


    # Process the metadata and content of the entry.
    # Up until now, we have created nodes through merge, but not the relationships. Leave the critical processing to the end, so that we can fail small.
    # entryNode.name = parsedEntry['UUID']
    if parsedEntry['Entry Text']
      entryNode.content = parsedEntry['Entry Text']
    end
    #entryNode.uuid = parsedEntry['UUID']
    entryNode.external_uuid = parsedEntry['UUID']
    entryNode.external_source = "DayOne"

    entryNode.ingestedFile = file
    entryNode.save # Entry node is now created

    # Connect to the creator
    entryNode.creator = thisEntryCreator

    # puts "Connecting DayOne entry to node for the second it was created"
    entryNode.datetimeRecordedAt = thisEntryDatetimeSecond
    # puts "Connecting DayOne to the Device it was recorded on"
    if thisEntryDevice
      entryNode.deviceRecordedAt = thisEntryDevice
    end

    # Connect the entry to it's location, and the geospatial tree
    if thisEntryLocation
      entryNode.geospatialRecordedAt = thisEntryLocation

      thisEntryLocation.semanticZoomOut = thisEntryLocationZoom3
      thisEntryLocationZoom3.semanticZoomOut = thisEntryLocationZoom2
      thisEntryLocationZoom2.semanticZoomOut = thisEntryLocationZoom1
      thisEntryLocationZoom1.semanticZoomOut = thisEntryLocationZoom0
    end
    
    # puts "Adding DayOne's second to Tree"
    # This function creates the same type of tree, but for time.
    # Example: 20151122_022100 > 20151122_0221 > 20151122_02 > 20151122 > 201511 > 2015
    createTreeFromHere(thisEntryDatetimeSecond)


    # An entry can have multiple tags. Each Tag is a node with the name as unique identifier. Connect the entry to each tag.
    if parsedEntry["Tags"]
      parsedEntry["Tags"].each do |thisTag|
        thisTagNode = Tag.merge( name: thisTag )
        entryNode.tags << thisTagNode
      end
    end


    # Example Parsed DayOne entry:
      # Creation Date
      # Creator
        # Device Agent
        # Generation Date
        # Host Name
        # OS Agent
        # Software Agent
      # Entry Text
      # Location
        # Latitude
        # Longitude
      # Starred
      # Time Zone
      # UUID

  else
    puts "Failed to parse DayOne Entry"
  end
end


def ingestDayOneFolderOfEntries()
  beginning_time = Time.now #Used to calculate how long it takes to process

  rbfiles = File.join("**", "*.doentry")
  Dir.glob(rbfiles) {|file|
    ingestDayOneEntry(file)
    puts file
  }

  end_time = Time.now #Used to calculate how long it takes to process
  puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds" #Used to calculate how long it takes to process
end
