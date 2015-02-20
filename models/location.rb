require 'pry'
require 'sqlite3'
require 'active_record'
require 'geocoder'

require_relative "database_methods"

class Location < ActiveRecord::Base
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :location_name, :street, :city, :state, :country, :address
  
  geocoded_by :address
  
  after_validation :geo_code # :if => :address_changed?

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
    
    address_array = []
    
    if @street == nil
      options.each_value { |value| address_array << value }
    else
      options.delete("location_name")
      options.each_value { |value| address_array << value }
    end
    
    @address = address_array.join(", ")

  end 
  
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
  
end