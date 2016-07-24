class Tag
  include Neo4j::ActiveNode
  property :name

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

  has_many :in, :tagged, rel_class: :Conceptually_Tagged
end
