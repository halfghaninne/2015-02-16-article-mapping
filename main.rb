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

get "/" do
  
##########################################################
# METHODS FOR BRINGING LATEST ARTICLES TO THE FRONT PAGE #
##########################################################
   
  @article_objects_array = Article.get_ten
    # => an Array of Objects
    
  @front_page_array = []

  @article_objects_array.each do |selected_object|
      @id = selected_object.id
      @title = selected_object.title
      @author = selected_object.author 
        # => Integer
        
        author_object = Author.find_by_var("authors", "id", @author) 
          # => one Object
          
      @author_name = author_object.name
      @full_text = selected_object.text
      @text_bite = @full_text.byteslice(0..70)
      @short_date = selected_object.date.byteslice(5..9)
      @date = selected_object.date.byteslice(0..15)

      @formatting_hash = {"id" => @id, 
                          "title" => @title, 
                          "date" => @date, 
                          "short_date" => @short_date, 
                          "author_name" => @author_name,
                          "text_bite" => @text_bite}

      @front_page_array << @formatting_hash
      
  end #until loop
  
  erb :homepage
end

get "/articles" do
  @id = params[:id].to_i
  @title = params[:title]
  @date = params[:date]
  @text = article_object.text
  
#######################
# MOVE INTO A METHOD? #
#######################
    # Returns author name for this Object, using its @id
    article_object = Article.find_by_var("articles", "id", @id) 
      # => one Article Object
    @author = article_object.author
    author_object = Author.find_by_var("authors", "id", @author) 
      # => one Author Obj
  @author_name = author_object.name
#######################
  
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
  
#######################
# MOVE INTO A METHOD? #
#######################
    # Returns associated location name and address for Object, using its @id
    location_id_info_object = MatchAwL.find_by_var("articles_with_locations", "article_id", @id)
    @location_id = location_id_info_object.location_id
    location_object = Location.find_by_var("location_keys", "id", @location_id)
  @location_name = location_object.location_name
  @address = location_object.address
#######################
  
  @api_key = "AIzaSyABlSFznPfoZu61HT_6w3YwNdGkY0mx5Z8" 
  @search_query = "https://www.google.com/maps/embed/v1/search?key=#{@api_key}&q=#{@address}"  

  erb :"articles/article_template"
end

get "/submit_draft" do
  @author_objects_array = Author.all("authors") 
    # => Array of Author Objects
  @location_objects_array = Location.all("location_keys") 
    # => Array of Location Objects

  erb :"articles/submit_draft"
end

get "/review_draft" do
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

get "/new_article" do
  @date = params[:date]
  @author = params[:author].to_i
  @title = params[:title]
  @text = params[:article_text]
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
    
#######################
# MOVE INTO A METHOD? #
#######################  
  @sql_formatted_date = @date.byteslice(0..9)
  @sql_formatted_time = @date.byteslice(11..18)
  
  @sql_date_entry = @sql_formatted_date + " " + @sql_formatted_time
  
  @html_formatted_date = @sql_formatted_date + " " + @sql_formatted_time.byteslice(0..4)
#######################
  
  new_entry = Article.new("date" => @sql_date_entry, "author" => @author, "title" => @title, 
                          "text" => @text)

  new_entry.insert("articles")

  
  author_object = Author.find_by_var("authors", "id", @author) #one Author Obj
  @author_name = author_object.name
  
  
  
  
  ##########################################################
  #      METHODS FOR INSERTING OR ACCESSING ADDRESSES      #
  ##########################################################
  
  @api_key = "AIzaSyABlSFznPfoZu61HT_6w3YwNdGkY0mx5Z8"               
  
  if params[:city].length > 1
  
    @location_name = params[:location_name]
    @street = params[:street]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
  new_location_key = Location.new( "location_name" => @location_name, 
                                  "street" => @street, "city" => @city, 
                                  "state" => @state, "country" => @country )
  new_location_key.coordinates
  
  @address = new_location_key.address

  new_location_key.insert("location_keys")
  
  matched_location = MatchAwL.new("location_id" => new_location_key.id, "article_id" => new_entry.id)
  
  matched_location.insert("articles_with_locations")

  end
  
  if params[:existing_location_tag] != "nil"
    @existing_location_tag = params[:existing_location_tag].to_i

    location_object = Location.find_by_var("location_keys", "id", @existing_location_tag)
                    # => Returns one Location Object
    @location_name = location_object.location_name
    @street = location_object.street
    @city = location_object.city
    @state = location_object.state
    @country = location_object.country
    @address = location_object.address

    matched_location = MatchAwL.new("location_id" => location_object.id, "article_id" => new_entry.id)

    matched_location.insert("articles_with_locations")

  end
  
  @search_query = "https://www.google.com/maps/embed/v1/search?key=#{@api_key}&q=#{@address}"  
  #### CONSIDER INSERTING THIS INTO THE DATABASE AS ANOTHER LOCATION FIELD #####
  
  #consider using same article template erb but with an optional message of
  #publication (similar to Andrew Y's error message on his user page)
  
  erb :"articles/new_article"
  
end #route handler
