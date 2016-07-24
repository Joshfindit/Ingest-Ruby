class Agent

  # Agent (aka person, organization, etc: something which can affect change)
  # Name
  # Description
  # has_many: artefacts


  include Neo4j::ActiveNode
#  property :uuid
  property :username
  property :name
  property :description
  # property :scent
  # property :sound
  # property :taste
  property :alias
  # property :homeRoom
#  property :touch #reserved word

  property :updated_at

  property :details

  property :normalized_name
  validates_presence_of :name
  validate :set_normalized_name

  private

  def set_normalized_name
    self.normalized_name = self.name.downcase if self.name
  end

  # has_one :in, :room, type: :CONTAINS
  # has_many :out, :held, type: :HOLDING, model_class: :Thing
end