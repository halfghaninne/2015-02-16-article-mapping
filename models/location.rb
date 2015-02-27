require 'pry'
require 'sqlite3'
require 'geocoder'

require_relative "database_methods"

class Location
  
  include DatabaseMethods
  
  attr_reader :id, :latitude, :longitude
  
  attr_accessor :location_name, :street, :city, :state, :country, :address

  # Public: new 
  # Creates new Location Object with the given attributes
  #
  # Parameters:
  # + options   :  Hash
  #   + id            : Integer
  #   + location_name : String
  #   + street        : String
  #   + city          : String
  #   + state         : String
  #   + country       : String
  #  (+ longitude     : Float)
  #  (+ latitude      : Float)
  #
  # Returns: 
  # Object / Instance containing the parameters
  #
  # State Changes:
  # None.
  
  def initialize(options)
    @id = options["id"]
    @location_name = options["location_name"]
    @street = options["street"]
    @city = options["city"]
    @state = options["state"]
    @country = options["country"]
    
    address_array = []
    
    short_options = {"location_name" => @location_name, 
                      "street" => @street,
                      "city" => @city, 
                      "state" => @state, 
                      "country" => @country}
                      
    #this loop checks to see if information for a new location has been entered      into the form. if it has, it enters that information into an array for an       address string (@address) that will be passed to Google as a search query
    if @street.length < 1
      short_options.each_value { |value| address_array << value }
    else
      short_options.delete("location_name")
      short_options.each_value { |value| address_array << value }
    end #if loop
    
    @address = address_array.join(", ")
    
    if is_geocoded? == true
      @latitude = options["latitude"]
      @longitude = options["longitude"]
    else
      self.coordinates
    end #if loop
    
  end #method
  
  # Private: is_geocoded?
  # Checks to see if the Object/record has values for attributes/fields
  # @longitude and @latitude.
  #
  # Parameters:
  # None.
  #
  # Returns: 
  # Boolean true or false - whether the object has values for @longitude and
  # @latitude
  #
  # State Changes:
  # None.
  
  def is_geocoded?
    !(@latitude == nil || @longitude == nil)
  end 
  
  # Private: coordinates
  # Sets two attributes for the Object - @latitude and @longitude.
  # 
  # Parameters:
  # None.
  #
  # Returns: 
  # Float - @longitude value
  # Float - @latitude value
  #
  # State Changes:
  # Yes - @latitude and @longitude.
  
  def coordinates
    geocoder_search_result = Geocoder.search(@address)
        # => Returns an array of results
    @latitude = geocoder_search_result[0].latitude
    @longitude = geocoder_search_result[0].longitude
  end 
   
end #class

############################################################
#     Skeletons of unused methods for later purposes       #
#   needs to be moved up into the above Class to be used   #
############################################################

  # def address
  #   @address_array.join(", ")
  # end

  # attributes = []
  #
  # instance_variables.each do |i|
  #   attributes << i.to_s.delete("@")
  # end
  #
  # query_components_array = []
  #
  # attributes.each do |a|
  #   value = self.send(a)
  #
  #   if value.is_a?(Integer)
  #     query_components_array << "#{a} = #{value}"
  #   else
  #     query_components_array << "#{a} = '#{value}'"
  #   end
  # end
  #
  # query_string = query_components_array.join(", ")
