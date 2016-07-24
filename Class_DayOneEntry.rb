class DayOneEntry < Artefact
# Parse the xml, then store the file at /artefact/<uuid>

# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>

# has_one :out, :datetimeRecordedAt, type: :DATETIME_RECORDED_AT, model_class: :AbsoluteDateNode
#   <key>Creation Date</key>
#   <date>2015-11-30T03:13:15Z</date>


# has_many :out, :creator, type: :CREATOR, model_class: :Agent

#property :creator # Josh
#   <key>Creator</key>
#   <dict>

# has_one :out, :deviceRecordedAt, type: :DEVICE_RECORDED_AT, model_class: :Device
#relationship_to Computer: (name is hostname. Data is properties)
#     <key>Device Agent</key>
#     <string>Macintosh/MacBookPro5,1</string>
#     <key>Generation Date</key>
#     <date>2015-11-30T03:13:15Z</date>
#     <key>Host Name</key>
#     <string>preston</string>
#     <key>OS Agent</key>

# Computer has a relationship to it's software versions? Seems like a good place for just plopping in to a string
#     <string>MacOS/10.11.1</string>
#     <key>Software Agent</key>
#     <string>Day One Mac/1.10.2</string>
#   </dict>

property :content
#   <key>Entry Text</key>
#   <string>Walk and Talk: Carey woke up around 10, took the pill, and asked about going on a walk.
# I got ready (changed pants, put on socks), and went out with her. The puppy came too.
# It was cold.</string>

#has_one :out, :geospatialRecordedAt, type: :GEOSPATIAL_RECORDED_AT, model_class: :GeospatialNode #create node by truncating coordinates. Name is (-)##.####,(-)##.####

#GPS Coordinates of 4 digits of precision are perfectly fine: 45.8284, -64.2077 (45.8284, -64.2078 would be across the street)
#   <key>Location</key>
#   <dict>
#     <key>Administrative Area</key>
#     <string>NS</string>
#     <key>Country</key>
#     <string>Canada</string>
#     <key>Latitude</key>
#     <real>45.828465065913889</real>
#     <key>Locality</key>
#     <string>Amherst</string>
#     <key>Longitude</key>
#     <real>-64.207734875081428</real>
#     <key>Place Name</key>
#     <string>15 Spring St</string>
#   </dict>
#   <key>Starred</key>
#   <false/>


# has_many :out, :tag, type: :CONCEPTUAL_TAG, model_class: :Tag

# Relationship to tags: Artefact_Tag_<name>
#   <key>Tags</key>
#   <array>
#     <string>Anxiety Progress</string>
#   </array>


#   <key>Time Zone</key>
#   <string>America/Halifax</string>

#property :uuid #Already defined
# Sending to external_id
#   <key>UUID</key>
#   <string>9230DAADD0DB43C2B35DAC0593D7FF3C</string>

# Weather: Discard for now
#   <key>Weather</key>
#   <dict>
#     <key>Celsius</key>
#     <string>-6</string>
#     <key>Description</key>
#     <string>Mostly Clear</string>
#     <key>Fahrenheit</key>
#     <string>21</string>
#     <key>IconName</key>
#     <string>cloudyn.png</string>
#     <key>Relative Humidity</key>
#     <integer>74</integer>
#     <key>Service</key>
#     <string>HAMweather</string>
#     <key>Sunrise Date</key>
#     <date>2015-11-29T11:35:39Z</date>
#     <key>Sunset Date</key>
#     <date>2015-11-29T20:35:11Z</date>
#     <key>Wind Bearing</key>
#     <integer>320</integer>
#     <key>Wind Chill Celsius</key>
#     <integer>-13</integer>
#     <key>Wind Speed KPH</key>
#     <integer>22</integer>
#   </dict>
# </dict>
# </plist>

end