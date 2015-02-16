require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Location
  
  include DatabaseMethods
  
  attr_reader :id
  
  #
  #
  #
  #
  #
  
  def initialize(options)
    @location_name = options[:location_name]
  end 
  
end
