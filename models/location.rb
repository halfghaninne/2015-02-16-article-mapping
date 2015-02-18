require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Location
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :location_name, :business_name, :street, :city, :state, :country
  
  #
  #
  #
  #
  #
  
  def initialize(options)
    @location_name = options["location_name"]
    @business_name = options["business_name"]
    @street = options["street"]
    @city = options["city"]
    @state = options["state"]
    @country = options["country"]
  end 
  
end

