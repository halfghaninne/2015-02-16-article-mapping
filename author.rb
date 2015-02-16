require 'pry'
require 'sqlite3'

#require_relative

class Author
  
  attr_reader :id
  
  attr_accessor :name
  
  #include Methods 
  
  def initialize(options)
    @name = options(:name)
  end 
  
end
