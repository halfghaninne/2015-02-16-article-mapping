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
    @id = options["id"]
    @date = options["date"]
    @author = options["author"].to_i
    @title = options["title"]
    @text = options["text"]
  end 
  
  def self.get_ten
    articles_hashes = DATABASE.execute("SELECT * FROM articles ORDER BY id DESC LIMIT 10")

    articles_array = []
    
    articles_hashes.each do |hash|
      obj = self.new(hash)
      articles_array << obj
    end # each loop
    
    articles_array 
    
  end #method
  
  
  # def fetch_by(options)
  #   v = []
  #   k = []
  #   options.each_key {|key| k << "#{key}"}
  #   if options.each_value {|value| value.kind_of? Integer}
  #     options.each_value {|value| v << value }
  #
  #     search_value = v[0].to_i
  #
  #   else options.each_value {|value| v << "#{value}"}
  #     search_value = v[0]
  #
  #   end
  #
  #   field = k[0].to_s
  #
  #   search_query = "SELECT * FROM articles WHERE #{field} = #{search_value}"
  #   results = DATABASE.execute("#{search_query}")
  #
  #   results_as_objects = []
  #
  #   results.each do |r|
  #     results_as_objects << self.new(r)
  #   end

  
end
