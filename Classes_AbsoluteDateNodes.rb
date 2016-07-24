

# Time tree (on-demand, hopefully)

  # Provided by graphaware-neo4j-timetree
  # Year
  # Month
  # Day
  # Hour
  # Minute
  # Second
  # Millisecond


  # Suggested by Iian
    # Proximity: String; # Used to capture things like whether the event happened around a certain time, before, after, etc.
      # Values: "c", "<", ">", "<=", ">="

    # Milennia: String;
      # Values: "AD", "BC"

    # IsDecade: Boolean;
      # TRUE indicates that the event happened sometime in that decade. E.g., if you only knew that something happened in the 1490s then 'IsDecade' would be TRUE and 'Year' would be 1490.

    # Month: Nullable<Int>;
      # Values 1 to 12 represents calendar months,
      # values 13 to 16 represent the seasons, 
      # and values 17 and 18 represent 'Early' and 'Late'.
      # What this means is that you can record that an event took place in 'Summer, 1490' or that it occurred 'Late 1494' or even 'Late 1520s', if 'IsDecade' is TRUE.

    # In retrospect I should probably have split the early/late off into its own boolean flag, so you could say things like 'Late Autumn 1464'.

    # The season and lateness values may seem like overkill but I came across a surprising number of art history events that couldn't be dated any more precisely than that.

    # In addition, each event also has another optional HistoricalDate value representing the end of a date range. For example, lots of art works are dated like '1503-1505' meaning that it was made sometime between 1503 and 1505.


  # Suggested by me, modified from Iian:

     # Proximity: String; # Used to capture things like whether the event happened around a certain time, before, after, etc.
        # Values: "c", "<", ">", "<=", ">="

    # [:RANGE_BEGIN] and [:RANGE_END] Allows a node's time to be within a range of decade/day/ms/etc
      # When both connect to the same node, [:RANGE_BEGIN] is assumed as the beginning of the node, and [:RANGE_END] is assumed as the end
        # Example: (n1:event)-[:RANGE_BEGIN]->(1490) and (n1)-[:RANGE_END]-(1490) means between 1490-01-01 and 1490-12-31
    
    # Season -> Late/mid/early
      # Does not define a date range as this is subjective and can vary wildly for each year at each location for each person 
    
    # Quarter: Specific date ranges by month
      # Q1: January, February and March
      # Q2: April, May and June
      # Q3: July, August and September
      # Q4: October, November and December



class AbsoluteDateNode
  include Neo4j::ActiveNode
  

  id_property :uuid, auto: :uuid

  has_many :in, :artefact, type: :AT_DATETIME, model_class: :Artefact

  property :normalized_name

  validates_presence_of :name
  validate :set_normalized_name

  private

  def set_normalized_name
    self.normalized_name = self.name.downcase if self.name
  end
end


class AbsoluteDateTimeRoot
  include Neo4j::ActiveNode

  property :name, type: String, constraint: :unique
  id_property :uuid, auto: :uuid
end


class Century < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :century
  
  # def set_name
  #   self.century = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :AbsoluteDateTimeRoot, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Decade
end

class Decade < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :decade

  # def set_name
  #   self.decade = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Century, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Year
end

class Year < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :year

  # def set_name
  #   self.year = self.name if self.name
  # end
  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Decade, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Month
end

class Quarter < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :quarter, type: Integer
  # 1, 2, 3, 4 = Q1, Q2, Q3, Q4

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Year, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Month
end

class Season < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :season, type: String

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Year, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Month
end

class Month < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :month

  # def set_name
  #   self.month = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Year, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Month
end

class Day < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :day

  # def set_name
  #   self.century = self.name if self.name
  # end
  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Month, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Day
end

class Hour < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :hour

  # def set_name
  #   self.hour = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Day, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Minute
end

class Minute < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :minute

  # def set_name
  #   self.minute = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Hour, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Second
end

class Second < AbsoluteDateNode
  property :name, type: String, constraint: :unique
  property :second
  property :unixtime, type: DateTime

  # def set_name
  #   self.second = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Minute, unique: true
  has_many :in, :datetimeChild, type: :DATETIME_SEMANTIC_ZOOM_IN, model_class: :Millisecond
end

class Millisecond < AbsoluteDateNode #Note: We are only considering ms for events since 1800, which makes a minimum of -5,364,648,000,000ms (5364648000000  2147483648)
  property :name, type: String, constraint: :unique
  property :millisecond
  property :unixtime_millisecond

  # def set_name
  #   self.millisecond = self.name if self.name
  # end

  has_one :out, :datetimeParent, type: :DATETIME_SEMANTIC_ZOOM_OUT, model_class: :Second, unique: true
end