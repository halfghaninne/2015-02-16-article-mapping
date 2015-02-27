require 'pry'
require 'sqlite3'

require_relative "database_methods"

class MatchAwL
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :article_id, :location_id

  # Public: new
  # Creates a new Author Object with the given attributes.
  #
  # Parameters:
  # + options   :  Hash
  #   + location_id      :  Integer
  #   + article_id       :  Integer
  #
  # Returns:
  # Object.
  #
  # State Changes:
  # None.
    
  def initialize(options)
    @location_id = options["id"]
    # Uhhhh is having both ^ and v problematic??
    @location_id = options["location_id"]
    @article_id = options["article_id"]
  end 
  
end #class