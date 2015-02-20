require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Location
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :location_name, :street, :city, :state, :country
  
  #
  #
  #
  #
  #
  
  def initialize(options)
    @location_name = options["location_name"]
    @street = options["street"]
    @city = options["city"]
    @state = options["state"]
    @country = options["country"]
    
    @address_array = []
    
    if @street == nil
      options.each_value { |value| @address_array << value }
    else
      options.delete("location_name")
      options.each_value { |value| @address_array << value }
    end

  end 
  
  def address
    @address_array.join(", ")
  end
  
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
  
end

binding.pry
