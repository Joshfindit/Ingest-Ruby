class Device
  include Neo4j::ActiveNode
  property :name
  property :content

  id_property :uuid, auto: :uuid

  property :updated_at
  property :created_at

  property :normalized_name

  validates_presence_of :name
  validate :set_normalized_name

  private

  def set_normalized_name
    self.normalized_name = self.name.downcase if self.name
  end

  has_many :out, :creator, type: :CREATOR, model_class: :Agent
  has_many :out, :location, type: :GEOSPATIAL_LOCATION, model_class: :Agent
  has_many :in, :occurredAt, type: :DEVICE_RECORDED_AT, model_class: :Artefact
end


class Computer < Device
  property :model_identifier
  property :hostname
  property :mac_address
  property :type #laptop, desktop, tablet, embedded

#     <key>Device Agent</key>
#     <string>Macintosh/MacBookPro5,1</string>
#     <key>Generation Date</key>
#     <date>2015-11-30T03:13:15Z</date>
#     <key>Host Name</key>
#     <string>preston</string>
#     <key>OS Agent</key>

end