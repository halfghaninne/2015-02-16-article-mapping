require 'pry'
require 'sqlite3'

require_relative "database_methods"

class MatchAwL
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :article_id, :location_id
  
  def initialize(options)
    @location_id = options["id"]
    #REALLY DO NOT LIKE THIS
    @location_id = options["location_id"]
    @article_id = options["article_id"]
  end 
  
end