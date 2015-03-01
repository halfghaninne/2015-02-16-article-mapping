require 'sinatra'

require 'pry'
require 'sqlite3'
require 'geocoder'

DATABASE = SQLite3::Database.new("article_info.db")

require_relative "models/database_setup.rb"
require_relative "models/author.rb"
require_relative "models/article.rb"
require_relative "models/location.rb"
require_relative "models/match_article_location.rb"
require_relative "helpers/helpers.rb"

helpers MainHelper

get "/" do
  
  format_for_homepage
  
  erb :homepage
end

get "/articles/:date/:id/:title" do
  @id = params[:id].to_i
  @title = params[:title]
  @date = params[:date]
  
  get_article_info(@id)
    @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
    
  get_author_name(@author)
  
  get_location_info(@id)
  
  get_map_embed(@address)
  
  erb :"articles/article_template"
end

get "/submit/new" do
  @author_objects_array = Author.all("authors") 
    # => Array of Author Objects
  @location_objects_array = Location.all("location_keys") 
    # => Array of Location Objects

  erb :"articles/submit_draft"
end

get "/submit/review" do
  @author_objects_array = Author.all("authors")
  @location_objects_array = Location.all("location_keys")
  
  @author = params[:author].to_i
  @title = params[:title]
  @text = params[:article_text]
  @existing_location_tag = params[:existing_location_tag].to_i 
    # => Integer id value for location
  
  # If city field has input, set params to variables to make a new location
  if params[:city] != nil 
    
    @location_name = params[:location_name]
    @street = params[:street]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
    
  end #if loop
  
  erb :"articles/review_draft"

end

#consider using same article template erb but with an optional message of
#publication (similar to Andrew Y's error message on his user page)
get "/submit/success" do
  @date = params[:date]
  @author = params[:author].to_i
  @title = params[:title]
  @text = params[:article_text]
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
    
  format_date(@date)
  
  new_entry = Article.new("date" => @sql_date_entry, "author" => @author, "title" => @title, 
                          "text" => @text)

  new_entry.insert("articles")
  
  @id = new_entry.id 
  
  author_object = Author.find_by_var("authors", "id", @author) #one Author Obj
  @author_name = author_object.name
  
####################################################################  
### Assigning Address - could still be moved into another method ###
####################################################################
  
  if params[:city].length > 1
    make_new_location(params) #params is an option Hash 
    match_location(@location_id, @id)
     
  end #if loop

  if params[:existing_location_tag] != "nil"
    retrieve_location(params)
    match_location(@location_id, @id)
    
  end #if loop
    
  get_map_embed(@address)
  
  erb :"articles/new_article"
  
end #route handler
