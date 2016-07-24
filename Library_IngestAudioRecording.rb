def fakeDayOneIngest()
  puts "Found and parsed #{parsedEntry['UUID']}."
  parsedEntry['Creation Date']

  entryNode = DayOneEntry.merge(name: parsedEntry['UUID'])
  thisEntryCreator = Agent.merge(name: "Joshua Buxton")
  if parsedEntry['Location']
    if parsedEntry['Location']['Latitude'] && parsedEntry['Location']['Longitude']
      thisEntryLocationRounded = "#{parsedEntry['Location']['Latitude'].floor2_s(4)}, #{parsedEntry['Location']['Longitude'].floor2_s(4)}"
      thisEntryLocation = GeospatialNode.merge(name: thisEntryLocationRounded )

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

  #puts "thisEntrySecond"
  thisEntrySecond = parsedEntry['Creation Date'].strftime("%Y%m%d_%H%M%S")
  thisEntryDatetimeSecond = Second.merge(name: thisEntrySecond)
  # puts thisEntryDatetimeSecond.name
  if parsedEntry['Creator']
    if parsedEntry['Creator']['OS Agent'].include?("iOS")
      thisEntryDevice = Device.merge(name: parsedEntry['Creator']['Host Name'])
    elsif parsedEntry['Creator']['OS Agent'].include?("MacOS")
      thisEntryDevice = Computer.merge(name: parsedEntry['Creator']['Host Name'])
    end
  end

  entryNode.name = parsedEntry['UUID']
  if parsedEntry['Entry Text']
    entryNode.content = parsedEntry['Entry Text']
  end
  #entryNode.uuid = parsedEntry['UUID']
  entryNode.external_uuid = parsedEntry['UUID']
  entryNode.external_source = "DayOne"

  entryNode.save

  entryNode.creator = thisEntryCreator
  # puts "Connecting DayOne to second node"
  entryNode.datetimeRecordedAt = thisEntryDatetimeSecond
  # puts "Connecting DayOne to Device"
  if thisEntryDevice
    entryNode.deviceRecordedAt = thisEntryDevice
  end

  if thisEntryLocation
    entryNode.geospatialRecordedAt = thisEntryLocation

    thisEntryLocation.semanticZoomOut = thisEntryLocationZoom3
    thisEntryLocationZoom3.semanticZoomOut = thisEntryLocationZoom2
    thisEntryLocationZoom2.semanticZoomOut = thisEntryLocationZoom1
    thisEntryLocationZoom1.semanticZoomOut = thisEntryLocationZoom0
  end
  
  # puts "Adding DayOne's second to Tree"
  createTreeFromHere(thisEntryDatetimeSecond)

  if parsedEntry["Tags"]
    parsedEntry["Tags"].each do |thisTag|
      thisTagNode = Tag.merge( name: thisTag )
      entryNode.tags << thisTagNode
    end
  end
end



## Ideas for JSON generation: 
# 1. change all keys and hashes to lowercase
# 2. Include more data, such as OS version

def ingestAudioRecording(audiofilename, dateformat) #dateformat should be optional
  # For ingesting the "Raw" audio file. Can be cut in to segments later or separately, then imported and connected to the recording node
  
  # Check if a JSON already exists. If so, use it
    # if not, get the metadata, generate the JSON, and use it
    # IF dateformat nil, set it to "%Y%m%d_%H%M%S%z" (Double-check this)
    # Mark the STRFTIME format so that the time can be re-parsed from the filename programically
  # Parse JSON metadata
  # Map the JSON to the properties we care about
  # Set name
  # Set date
  # Set location, if it exists
  # Set ingest date to now
  # set ingestedFile to the file
  # set ingestedMetadataFile to the JSON file

end

def ingestAppleVoiceMemo(voicememoJSONfilename) #dateformat should be optional
  # For ingesting the "Raw" audio file. Can be cut in to segments later or separately, then imported and connected to the recording node
  
  # Check if a JSON already exists (check for a JSON along side the file). If so, use it
    # if not, get the metadata, generate the JSON, and use it
    # IF dateformat nil, set it to "%Y%m%d_%H%M%S%z" (Double-check this)
    # Mark the STRFTIME format so that the time can be re-parsed from the filename programically
  # Parse JSON metadata
  # Map the JSON to the properties we care about
  # Set name
  # Set date
  # Set location, if it exists
  # Set ingest date to now
  # set ingestedFile to the file
  # set ingestedMetadataFile to the JSON file

   # require 'json'
  # Only use for a folder created from a single recording. Support for multiple recordings in one folder requires parsing I don't wanna do right now
  
  #screap the JSON index file. We're reading each segment's JSON
  # Get the full path and filename separately
  # puts voicememoFile = Pathname.new(voicememofilename)
  puts voicememoJsonFilePath = Pathname.new(voicememoJSONfilename)
  puts voicememoJsonFileFolder = voicememoJsonFilePath.expand_path.dirname

  # Grab the file named the same, but ending in JSON
  # snippetJsonFile = File.read("#{audioSegmentFolder}/#{audioSegmentFileWithoutExtention}.json")
  voicememoJsonFile = File.read(voicememoJSONfilename)
  # Parse that JSON and ingest
  if voicememoJSONFileParsed = JSON.parse(voicememoJsonFile)
    # ingestParsedAudioRecording(file)
    puts voicememoPathname = Pathname.new(voicememoJSONFileParsed['originalFilename'])
    voicememoFileWithoutExtention = voicememoPathname.basename(".*")
    
    if voiceMemoFile = File.new("#{voicememoJsonFileFolder}/#{voicememoFileWithoutExtention}.m4a")
      voicememoNode = AudioRecording.merge(name: voicememoJSONFileParsed['originalFilename'])

      # puts voicememoJSONFileParsed['OriginalLocation']

      # if audioSegmentJSONFileParsed['original']['OriginalLocation']
      #   if audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'] && audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'] ##Later, change the parsing tool to use capital 'L's
      #     thisEntryLocationRounded = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(4)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(4)}"
      #     puts "thisEntryLocationRounded: #{thisEntryLocationRounded}"
      #     thisEntryLocation = GeospatialNode.merge(name: thisEntryLocationRounded )

      #     thisEntryLocationZoom3Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(3)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(3)}"
      #     thisEntryLocationZoom2Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(2)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(2)}"
      #     thisEntryLocationZoom1Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(1)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(1)}"
      #     thisEntryLocationZoom0Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(0)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(0)}"
      #     thisEntryLocationZoom3 = GeospatialNode.merge(name: thisEntryLocationZoom3Floored )
      #     thisEntryLocationZoom2 = GeospatialNode.merge(name: thisEntryLocationZoom2Floored )
      #     thisEntryLocationZoom1 = GeospatialNode.merge(name: thisEntryLocationZoom1Floored )
      #     thisEntryLocationZoom0 = GeospatialNode.merge(name: thisEntryLocationZoom0Floored )
      #   end
      # end

      # if thisEntryLocation
      #   audioSegmentNode.geospatialRecordedAt = thisEntryLocation

      #   thisEntryLocation.semanticZoomOut = thisEntryLocationZoom3
      #   thisEntryLocationZoom3.semanticZoomOut = thisEntryLocationZoom2
      #   thisEntryLocationZoom2.semanticZoomOut = thisEntryLocationZoom1
      #   thisEntryLocationZoom1.semanticZoomOut = thisEntryLocationZoom0
      # end


      # if originalAudioFileNode = AudioRecording.merge(name: audioSegmentJSONFileParsed['original']['OriginalFilename'])
      #   audioSegmentNode.origionalArtefact = originalAudioFileNode
      # end

      puts "voicememoJSONFileParsed['originalMetaDataDumpRaw']['Release Date']: #{voicememoJSONFileParsed['originalMetaDataDumpRaw']['Release Date']}"
      # puts "Time.parse(voicememoJSONFileParsed['Release Date']): #{Time.parse(voicememoJSONFileParsed['Release Date'])}"

      if thisVoicememoSecond = Time.parse(voicememoJSONFileParsed['originalMetaDataDumpRaw']['Release Date']).strftime("%Y%m%d_%H%M%S")
        thisVoicememoDatetimeSecond = Second.merge(name: thisVoicememoSecond)
        voicememoNode.datetimeRecordedAt = thisVoicememoDatetimeSecond
        createTreeFromHere(thisVoicememoDatetimeSecond)
      end


      # if parsedEntry['origional']['OriginalComputer']
      #   if parsedEntry['Creator']['OS Agent'].include?("iOS")
      #     thisEntryDevice = Device.merge(name: parsedEntry['Creator']['Host Name'])
      #   elsif parsedEntry['Creator']['OS Agent'].include?("MacOS")
      #     thisEntryDevice = Computer.merge(name: parsedEntry['Creator']['Host Name'])
      #   end
      # end

      # puts "audioSegmentJSONFileParsed['original']: #{audioSegmentJSONFileParsed['original']}"

      if thisVoicememoDevice = Computer.merge(name: voicememoJSONFileParsed['originalMetaDataDumpRaw']['Artist'])
        # puts "Connecting recording to Device"
        puts thisVoicememoDevice.name
        puts voicememoNode.deviceRecordedAt = thisVoicememoDevice
      end
      

      voicememoNode.ingestedFile = voiceMemoFile
      voicememoNode.ingestedMetadataFile = voicememoJsonFile

      voicememoNode.save

      # puts audioSegmentJSONFileParsed
      # puts audioSegmentJSONFileParsed['original']
      # puts audioSegmentJSONFileParsed['original']['OriginalLocation']
      # audioSegmentJSONFileParsed is the metadata for the segment
      # Example (Note: updated 2016-02-29 @00:49:50 because of the Location being stored in an array in a hash: super annoying. Had to change the snipper:

        # {
        #   "snippetFilename"=>"milo.20160205_080231-0400.mp3", 
        #   "md5AtSave"=>"3ed3d488bb66d6546f279e64b7d9d7ec", 
        #   "uuid"=>"5c7ee3ab-e1d0-44c4-a158-27ee5fe8fbbf", 
        #   "representedDatetime"=>"2016-02-05 08:02:31 -0400", 
        #   "representedDatetimeConfidence"=>"Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.", 
        #   "original"=>{
        #     "OriginalFilename"=>"20160205_075709-0400.mp3", 
        #     "OriginalComputer"=>"milo", 
        #     "OriginalComputerMACAddress"=>"74:d4:35:8f:12:64", 
        #     "OriginalLocation"=>{
        #       "latitude"=>"45.828473", 
        #       "longitude"=>"-64.20747"
        #     }, 
        #     "OriginalFilenameConfidence"=>"100%", 
        #     "OriginalComputerConfidence"=>"User Specified", 
        #     "OriginalLocationConfidence"=>"User Specified", 
        #     "OriginalFileRubyTime"=>"2016-02-05 07:57:09 -0400", 
        #     "OrigionalDuration"=>1797
        #   }
        # }
      # Copy the file in to the system
    else
      puts "Couldn't read JSON for audio file segment"
      return false
    end
  else
    puts "M4A file does not exist"
    return false
  end
#   end
# end

  # Get origional filename
  # Get metadata, including location, computer, and so-on. Need to specify on command-line
  # I have JSON: Forgot about that. 

  # Get foder of split files with JSON
  # Get OriginalFilename and ingest
  # Iterate through each, and ingest, linking each to the previous (except for the first )


  ### How to link to previous (one example)
  # def calculate
  # @points = Point.all

  # @points.each_with_index do |point, i|
  #   previous_point = @points[i-1] unless i==0
  
  #   if previous_point.nil?
  #     # First element, there is no previous and we need to merge a node
  #     puts "i: #{i}. point: #{point}"

  #   elsif previous_point
  #     # second element, there is a previous and we need to merge a node + relationship with the previous
  #     puts "i: #{i}. previous_point: #{previous_point}. point: #{point}"
  #   end
  # end

  # Save associated file (snippetFilename) to paperclip folder (samename.audiofileext instead of samename.json)
#   {
### Property
#   "snippetFilename": "milo.20160101_002959-0400.flac",

### Proeperty
#   "md5AtSave": "f7908863427d8a09d8319e1d145c9060",

### Property: external UUID
#   "uuid": "f1322017-e20e-466f-97b5-c107ea24dbc1",

### Relationship: estimated Datetime 
#   "representedDatetime": "2016-01-01 00:29:59 -0400",
### Relationship property
#   "representedDatetimeConfidence": "Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.",


### Relationship to "Origional" artefact
#   "original": {

### relationship to 'OriginalFilename' node
#     "OriginalFilename": "2016-01-01@000000.flac",

### Relationship from OriginalFilename node to OriginalComputer node
#     "OriginalComputer": "milo",
#     "OriginalComputerMACAddress": "74:d4:35:8f:12:64",

### Relationship from OriginalFilename to location
#     "OriginalLocation": [
#       {
#         "latitude": "45.828473",
#         "longitude": "-64.20747"
#       }
#     ],

#     "OriginalFilenameConfidence": "100%",

### Property to Computer relationship
#     "OriginalComputerConfidence": "User Specified",

### Property on the Location relationship 
#     "OriginalLocationConfidence": "User Specified",

### What is this?
#     "OriginalFileRubyTime": "2016-01-01 00:00:00 -0400"
#   }
# }


# {
#   "snippetFilename": "milo.20160101_000000-0400.wav",
#   "md5AtSave": "f9358affbacd0dfa146a80fdc6c914ea",
#   "uuid": "d64a34f4-5ac8-4d40-81ce-7ab1db1c2408",
#   "representedDatetime": "2016-01-01 00:00:00 -0400",
#   "representedDatetimeConfidence": "Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.",
#   "original": {
#     "OriginalFilename": "2016-01-01@000000.wav",
#     "OriginalComputer": "milo",
#     "OriginalComputerMACAddress": "74:d4:35:8f:12:64",
#     "OriginalLocation": [
#       {
#         "latitude": "45.828473",
#         "longitude": "-64.20747"
#       }
#     ],
#     "OriginalFilenameConfidence": "100%",
#     "OriginalComputerConfidence": "User Specified",
#     "OriginalLocationConfidence": "User Specified",
#     "OriginalFileRubyTime": "2016-01-01 00:00:00 -0400"
#   }
# }

end



def ingestParsedAudioRecording(filename)
  # require 'json'
  # Only use for a folder created from a single recording. Support for multiple recordings in one folder requires parsing I don't wanna do right now
  
  #screap the JSON index file. We're reading each segment's JSON
  # Get the full path and filename separately
  puts jsonPathname = Pathname.new(filename)
  puts audioSegmentFolder = jsonPathname.expand_path.dirname
  

  # parse the JSON
  # jsonFile = File.read(filename)
  # if jsonFileParsed = JSON.parse(jsonFile)
  #   puts jsonFileParsed
  #   jsonFileParsed.each do |jsonFileParsedEntry|
      # puts jsonFileParsedEntry


      #puts jsonFileParsedEntry['file'] ## THe name of the audiofile
      
      # Iterate through the file and grab each filename (which is the audio file)
      # Grab the file named the same, but ending in JSON
      # snippetJsonFile = File.read("#{audioSegmentFolder}/#{audioSegmentFileWithoutExtention}.json")
      snippetJsonFile = File.read(filename)
      # Parse that JSON and ingest
      if audioSegmentJSONFileParsed = JSON.parse(snippetJsonFile)
        # ingestParsedAudioRecording(file)

        puts audioSegmentPathname = Pathname.new(audioSegmentJSONFileParsed['snippetFilename'])
        audioSegmentFileWithoutExtention = audioSegmentPathname.basename(".*")
        audioSegmentNode = AudioRecordingSegment.merge(name: audioSegmentJSONFileParsed['snippetFilename'])

        puts audioSegmentJSONFileParsed['original']['OriginalLocation']

        if audioSegmentJSONFileParsed['original']['OriginalLocation']
          if audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'] && audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'] ##Later, change the parsing tool to use capital 'L's
            thisEntryLocationRounded = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(4)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(4)}"
            puts "thisEntryLocationRounded: #{thisEntryLocationRounded}"
            thisEntryLocation = GeospatialNode.merge(name: thisEntryLocationRounded )

            thisEntryLocationZoom3Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(3)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(3)}"
            thisEntryLocationZoom2Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(2)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(2)}"
            thisEntryLocationZoom1Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(1)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(1)}"
            thisEntryLocationZoom0Floored = "#{audioSegmentJSONFileParsed['original']['OriginalLocation']['latitude'].to_f.floor2_s(0)}, #{audioSegmentJSONFileParsed['original']['OriginalLocation']['longitude'].to_f.floor2_s(0)}"
            thisEntryLocationZoom3 = GeospatialNode.merge(name: thisEntryLocationZoom3Floored )
            thisEntryLocationZoom2 = GeospatialNode.merge(name: thisEntryLocationZoom2Floored )
            thisEntryLocationZoom1 = GeospatialNode.merge(name: thisEntryLocationZoom1Floored )
            thisEntryLocationZoom0 = GeospatialNode.merge(name: thisEntryLocationZoom0Floored )
          end
        end

        if thisEntryLocation
          audioSegmentNode.geospatialRecordedAt = thisEntryLocation

          thisEntryLocation.semanticZoomOut = thisEntryLocationZoom3
          thisEntryLocationZoom3.semanticZoomOut = thisEntryLocationZoom2
          thisEntryLocationZoom2.semanticZoomOut = thisEntryLocationZoom1
          thisEntryLocationZoom1.semanticZoomOut = thisEntryLocationZoom0
        end


        if originalAudioFileNode = AudioRecording.merge(name: audioSegmentJSONFileParsed['original']['OriginalFilename'])
          audioSegmentNode.origionalArtefact = originalAudioFileNode
        end

        if thisEntrySecond = Time.parse(audioSegmentJSONFileParsed['representedDatetime']).strftime("%Y%m%d_%H%M%S")
          thisEntryDatetimeSecond = Second.merge(name: thisEntrySecond)
          audioSegmentNode.datetimeRecordedAt = thisEntryDatetimeSecond
          createTreeFromHere(thisEntryDatetimeSecond)
        end


        # if parsedEntry['origional']['OriginalComputer']
        #   if parsedEntry['Creator']['OS Agent'].include?("iOS")
        #     thisEntryDevice = Device.merge(name: parsedEntry['Creator']['Host Name'])
        #   elsif parsedEntry['Creator']['OS Agent'].include?("MacOS")
        #     thisEntryDevice = Computer.merge(name: parsedEntry['Creator']['Host Name'])
        #   end
        # end

        # puts "audioSegmentJSONFileParsed['original']: #{audioSegmentJSONFileParsed['original']}"

        if thisEntryDevice = Computer.merge(name: audioSegmentJSONFileParsed['original']['OriginalComputer'])
          # puts "Connecting recording to Device"
          puts thisEntryDevice.name
          puts audioSegmentNode.deviceRecordedAt = thisEntryDevice
        end
        

        # puts audioSegmentJSONFileParsed
        # puts audioSegmentJSONFileParsed['original']
        # puts audioSegmentJSONFileParsed['original']['OriginalLocation']
        # audioSegmentJSONFileParsed is the metadata for the segment
        # Example (Note: updated 2016-02-29 @00:49:50 because of the Location being stored in an array in a hash: super annoying. Had to change the snipper:

          # {
          #   "snippetFilename"=>"milo.20160205_080231-0400.mp3", 
          #   "md5AtSave"=>"3ed3d488bb66d6546f279e64b7d9d7ec", 
          #   "uuid"=>"5c7ee3ab-e1d0-44c4-a158-27ee5fe8fbbf", 
          #   "representedDatetime"=>"2016-02-05 08:02:31 -0400", 
          #   "representedDatetimeConfidence"=>"Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.", 
          #   "original"=>{
          #     "OriginalFilename"=>"20160205_075709-0400.mp3", 
          #     "OriginalComputer"=>"milo", 
          #     "OriginalComputerMACAddress"=>"74:d4:35:8f:12:64", 
          #     "OriginalLocation"=>{
          #       "latitude"=>"45.828473", 
          #       "longitude"=>"-64.20747"
          #     }, 
          #     "OriginalFilenameConfidence"=>"100%", 
          #     "OriginalComputerConfidence"=>"User Specified", 
          #     "OriginalLocationConfidence"=>"User Specified", 
          #     "OriginalFileRubyTime"=>"2016-02-05 07:57:09 -0400", 
          #     "OrigionalDuration"=>1797
          #   }
          # }
        # Copy the file in to the system
      else
        puts "Couldn't read JSON for audio file segment"
      end  
  #   end
  # end

  # Get origional filename
  # Get metadata, including location, computer, and so-on. Need to specify on command-line
  # I have JSON: Forgot about that. 

  # Get foder of split files with JSON
  # Get OriginalFilename and ingest
  # Iterate through each, and ingest, linking each to the previous (except for the first )


  ### How to link to previous (one example)
  # def calculate
  # @points = Point.all

  # @points.each_with_index do |point, i|
  #   previous_point = @points[i-1] unless i==0
  
  #   if previous_point.nil?
  #     # First element, there is no previous and we need to merge a node
  #     puts "i: #{i}. point: #{point}"

  #   elsif previous_point
  #     # second element, there is a previous and we need to merge a node + relationship with the previous
  #     puts "i: #{i}. previous_point: #{previous_point}. point: #{point}"
  #   end
  # end

  # Save associated file (snippetFilename) to paperclip folder (samename.audiofileext instead of samename.json)
#   {
### Property
#   "snippetFilename": "milo.20160101_002959-0400.flac",

### Proeperty
#   "md5AtSave": "f7908863427d8a09d8319e1d145c9060",

### Property: external UUID
#   "uuid": "f1322017-e20e-466f-97b5-c107ea24dbc1",

### Relationship: estimated Datetime 
#   "representedDatetime": "2016-01-01 00:29:59 -0400",
### Relationship property
#   "representedDatetimeConfidence": "Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.",


### Relationship to "Origional" artefact
#   "original": {

### relationship to 'OriginalFilename' node
#     "OriginalFilename": "2016-01-01@000000.flac",

### Relationship from OriginalFilename node to OriginalComputer node
#     "OriginalComputer": "milo",
#     "OriginalComputerMACAddress": "74:d4:35:8f:12:64",

### Relationship from OriginalFilename to location
#     "OriginalLocation": [
#       {
#         "latitude": "45.828473",
#         "longitude": "-64.20747"
#       }
#     ],

#     "OriginalFilenameConfidence": "100%",

### Property to Computer relationship
#     "OriginalComputerConfidence": "User Specified",

### Property on the Location relationship 
#     "OriginalLocationConfidence": "User Specified",

### What is this?
#     "OriginalFileRubyTime": "2016-01-01 00:00:00 -0400"
#   }
# }


# {
#   "snippetFilename": "milo.20160101_000000-0400.wav",
#   "md5AtSave": "f9358affbacd0dfa146a80fdc6c914ea",
#   "uuid": "d64a34f4-5ac8-4d40-81ce-7ab1db1c2408",
#   "representedDatetime": "2016-01-01 00:00:00 -0400",
#   "representedDatetimeConfidence": "Unknown. Cut with FFMPEG. Needs testing to find out how accurate it is.",
#   "original": {
#     "OriginalFilename": "2016-01-01@000000.wav",
#     "OriginalComputer": "milo",
#     "OriginalComputerMACAddress": "74:d4:35:8f:12:64",
#     "OriginalLocation": [
#       {
#         "latitude": "45.828473",
#         "longitude": "-64.20747"
#       }
#     ],
#     "OriginalFilenameConfidence": "100%",
#     "OriginalComputerConfidence": "User Specified",
#     "OriginalLocationConfidence": "User Specified",
#     "OriginalFileRubyTime": "2016-01-01 00:00:00 -0400"
#   }
# }

end



def ingestParsedAudioFolderOfRecordings()

  jsonIndex = File.join("**", "*.json")
  # puts jsonIndex

  Dir.glob(jsonIndex) {|file|
    # 'file' is the relative path and filename. As in 'soxflactemp.noconversion/index.json'
    puts file
    ingestParsedAudioRecording(file) #Sends index.json to the parsing function
    # Each index.json afterwards will be for different folders (hopefully)

    # puts jsonFile.absolute_path
    # if jsonFileParsed = JSON.parse(jsonFile)
    #     jsonFileParsed.each do |jsonFileParsedEntry|
    #         puts jsonFileParsedEntry['file']
    #         snippetJsonFile = File.read("#{jsonFileParsedEntry['file']}")
    #     end
    # end
  }
  # for each file in folder
  #   #ingestDayOneEntry(file)
  #   puts file
  # end
end
