class AbsoluteDateTimeRoot
  include Neo4j::ActiveNode

  property :name, type: String, constraint: :unique
  id_property :uuid, auto: :uuid
end