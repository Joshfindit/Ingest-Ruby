# class Artefact
  # # Artefact (aka: media, story, object)

  # include Neo4j::ActiveNode
  # property :name
  # property :content

  # id_property :uuid, auto: :uuid

  # property :external_uuid
  # property :external_source # 

  # property :updated_at
  # property :created_at

  # property :normalized_name

  # validates_presence_of :name
  # validate :set_normalized_name

  # private

  # def set_normalized_name
  #   self.normalized_name = self.name.downcase if self.name
  # end

  # has_many :out, :recordingAgent, type: :CREATOR, model_class: :Agent
  # has_many :out, :subject, type: :SUBJECT, model_class: :Agent
  # has_one :out, :occurredAt, type: :ARTEFACT_OCCURRED_AT, model_class: :AbsoluteDateNode
  # has_one :out, :ingestedAt, type: :ARTEFACT_INGESTED_AT, model_class: :AbsoluteDateNode
  # has_many :out, :ingestedAt, type: :ARTEFACT_EDITED_AT, model_class: :AbsoluteDateNode

# end


class AudioRecording < Artefact
    # Get origional filename
  # Get metadata, including location, computer, and so-on. Need to specify on command-line
  # I have JSON: Forgot about that. 

  # Get foder of split files with JSON
  # Get OriginalFilen same and ingest
  # Iterate through each, and ingest
  # Save associated file (snippetFilename) to paperclip folder (samename.audiofileext instead of samename.json)


#   {
### property :name
#   "snippetFilename": "milo.20160101_002959-0400.flac",

property :md5AtSave
#   "md5AtSave": "f7908863427d8a09d8319e1d145c9060",

### Property: external_uuid (from Artefact)
#   "uuid": "f1322017-e20e-466f-97b5-c107ea24dbc1",

# relationship: referencesAbsoluteDatetime from Artefact
### Relationship: estimated Datetime
#   "representedDatetime": "2016-01-01 00:29:59 -0400",
### Relationship property
#   "representedDatetimeConfidence": "Cut with SoX",


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

  has_neo4jrb_attached_file :audioRecordingFile
  validates_attachment_content_type :audioRecordingFile, content_type: /\Aaudio\/.*\Z/

  def self.ingestParsedAudioRecording(filename)
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

  def self.ingestParsedAudioFolderOfRecordings(folder)

    jsonIndex = File.join("#{folder}**", "*.json")
    # puts jsonIndex

    Dir.glob(jsonIndex) {|file|
      # 'file' is the relative path and filename. As in 'soxflactemp.noconversion/index.json'
      puts file
      self.ingestParsedAudioRecording(file) #Sends index.json to the parsing function
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
end


class AudioRecordingSegment < AudioRecording
	has_one :out, :origionalArtefact, type: :ORIGINAL_AUDIORECORDING, model_class: :AudioRecording
	has_one :out, :previous, type: :SEGMENT_SEQUENCE_PREVIOUS, model_class: :AudioRecordingSegment

  has_neo4jrb_attached_file :audioRecordingFileSegment
  validates_attachment_content_type :audioRecordingFileSegment, content_type: /\Aaudio\/.*\Z/
end
