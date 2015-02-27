require 'pry'
require 'sqlite3'

require_relative "database_methods"

class Article
  
  include DatabaseMethods
  
  attr_reader :id
  
  attr_accessor :date, :author, :text, :title
  
  # Public: new
  # Creates a new Author Object with the given attributes.
  #
  # Parameters:
  # + options   :  Hash
  #   + id      :  Integer
  #   + date    :  String
  #   + author  :  Integer
  #   + title   :  String
  #   + text    :  String
  #
  # Returns:
  # Object.
  #
  # State Changes:
  # None.
  
  def initialize(options)
    @id = options["id"]
    @date = options["date"]
    @author = options["author"].to_i
    @title = options["title"]
    @text = options["text"]
  end 
  
  # Private: .get_ten
  # Retrieves the last ten items (Objects) from the articles database.
  #
  # Parameters:
  # None.
  #
  # Returns:
  # Array of Article Objects.
  #
  # State Changes:
  # None.
  
  def self.get_ten
    articles_hashes = DATABASE.execute("SELECT * FROM articles ORDER BY id DESC LIMIT 10")

    articles_array = []
    
    articles_hashes.each do |hash|
      obj = self.new(hash)
      articles_array << obj
    end # each loop
    
    articles_array 
    
  end #method

end #class

############################################################
#     Skeletons of unused methods for later purposes       #
#   needs to be moved up into the above Class to be used   #
############################################################

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
