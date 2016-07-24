class Artefact
  # Artefact (aka: media, story, object)

  include Neo4j::ActiveNode
  #include Paperclip::Glue #For paperclip by itself
  include Neo4jrb::Paperclip #For paperclip using the neo4j gem

  property :name
  property :content

  id_property :uuid, auto: :uuid

  property :external_uuid
  property :external_source # 

  property :updated_at
  property :created_at

  property :normalized_name

  validates_presence_of :name
  validate :set_normalized_name

  private

  def set_normalized_name
    self.normalized_name = self.name.downcase if self.name
  end

  Paperclip.options[:content_type_mappings] = { doentry: 'application/xml' }
  has_neo4jrb_attached_file :ingestedFile

#  has_neo4jrb_attached_file :genericaudiofile
#  validates_attachment_content_type :genericaudiofile, content_type: /\Aaudio\/.*\Z/


  # A reationship is made to "ARTEFACT_INGESTED_AT" with the username of the user who added it.
  # This separates User and Creator where the Creator is the Agent who created the knowledge, and the User is the one who entered it
  has_many :out, :creator, type: :CREATOR, model_class: :Agent

#  has_many :out, :tags, type: :CONCEPTUAL_TAG, model_class: :Tag, rel_class: :Conceptually_Tagged
  has_many :out, :tags, rel_class: :Conceptually_Tagged

  has_one :out, :deviceRecordedAt, type: :DEVICE_RECORDED_AT, model_class: :Device
  
  has_one :out, :occurredAt, type: :ARTEFACT_OCCURRED_AT, model_class: :AbsoluteDateNode
  has_one :out, :ingestedAt, type: :ARTEFACT_INGESTED_AT, model_class: :AbsoluteDateNode
  has_many :out, :ingestedAt, type: :ARTEFACT_EDITED_AT, model_class: :AbsoluteDateNode # When an edit is saved, that edit creates a node. Look in to GitHub Graph theory to understand how to incorporate this for edit history.
  has_one :out, :datetimeRecordedAt, type: :DATETIME_ARTEFACT_RECORDED_AT, model_class: :AbsoluteDateNode
  has_many :out, :referencesAbsoluteDatetime, type: :REFERENCES_ABSOLUTE_DATETIME, model_class: :AbsoluteDateNode

  has_many :out, :refersTo, type: :REFERS_TO # Can refer to an Artefact, an Agent, a datetime, or any other node.
  has_many :in, :isReferredToBy, type: :REFERS_TO

  has_one :out, :geospatialRecordedAt, type: :GEOSPATIAL_RECORDED_AT, model_class: :GeospatialNode
end


class Conceptually_Tagged
  include Neo4j::ActiveRel
#  before_save :do_this

  from_class :Artefact
  to_class   :Tag
  type 'CONCEPTUAL_TAG'

  creates_unique :all #only count it as a unique relationship when all properties match (and therefore don't duplicate it)

end
