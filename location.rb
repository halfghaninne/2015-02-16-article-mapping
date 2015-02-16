require 'pry'
require 'sqlite3'

#require_relative

class Location
  
  attr_reader :id
  
  #include Methods 
  
  def initialize(options)
    @location_name = options(:location_name)
  end 
  
end
