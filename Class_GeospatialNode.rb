class GeospatialNode
  include Neo4j::ActiveNode
  #Rough: ##.#### (about 10m)
  # When Zoomed out, ##.### > ##.## > ##.# > ## > GeoSpatialRootNode (Earth)
  property :name
  property :latitude
  property :longitude

  id_property :uuid, auto: :uuid

  property :updated_at
  property :created_at

  has_one :out, :semanticZoomOut, type: :GEOSPATIAL_SEMANTIC_ZOOM_OUT, model_class: :GeospatialNode
  has_many :in, :atCoordinates, type: :GEOSPATIAL_LOCATION
end