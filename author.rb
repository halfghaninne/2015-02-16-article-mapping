require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Author
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :name
  
  #
  #
  #
  #
  #
  
  def initialize(options)
    @name = options[:name]
  end 
  
end
