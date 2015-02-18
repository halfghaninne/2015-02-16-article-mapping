require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Article
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :date, :author, :text, :title
  
  #
  #
  #
  #
  #
  
  def initialize(options)
    @date = options["date"]
    @author = options["author_id"]
    @text = options["text"]
    @title = options["title"]
  end 
  
  #
  #
  #
  #
  #
  
  def fetch_by(options)
    v = []
    k = []
    options.each_key {|key| k << "#{key}"}
    if options.each_value {|value| value.kind_of? Integer}
      options.each_value {|value| v << value }
      
      search_value = v[0].to_i
      
    else options.each_value {|value| v << "#{value}"}
      search_value = v[0]
      
    end
    
    field = k[0].to_s
    
    search_query = "SELECT * FROM articles WHERE #{field} = #{search_value}"
    results = DATABASE.execute("#{search_query}")
    
    results_as_objects = []
    
    results.each do |r|
      results_as_objects << self.new(r)
    end
  
  end
  
end
