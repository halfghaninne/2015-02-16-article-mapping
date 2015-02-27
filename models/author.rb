require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Author
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :name
  
  # Public: new
  # Creates a new Author Object with the given attributes.
  #
  # Parameters:
  # + options   :  Hash
  #   + id      : Integer
  #   + name    : String
  #
  # Returns:
  # Object
  #
  # State Changes:
  # None.
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
  end 
  
end #class
