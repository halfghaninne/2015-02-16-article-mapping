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

#### I THINK IT WOULD BE GOOD HERE TO DEFINE @ VARIABLES FOR ALL ARTICLES ON THE HOMEPAGE IN A MODULE. ####

get "/" do
  
  ##########################################################
  # METHODS FOR BRINGING LATEST ARTICLES TO THE FRONT PAGE #
  ##########################################################
   
  @article_values_array = Article.all("articles")
    # => an Array of Hashes
  n = @article_values_array.length

  @front_page_array = []

  x = (n - 1) #index of each item, starting from last (most-recent) item
  until x == (n - 10) do
    selected_hash = @article_values_array[x]
      @id = selected_hash["id"].to_i
      @title = selected_hash["title"]
      @author = selected_hash["author"].to_i # Integeter
        return_array = Author.find_by_id("authors", @author) # Array of one Hash
        @author_hash = return_array[0] #the Hash returned above
      @author_name = @author_hash["name"]
      @text_bite = selected_hash["text"].byteslice(0..70)
      @full_text = selected_hash["text"]
      @short_date = selected_hash["date"].byteslice(5..9)
      @date = selected_hash["date"].byteslice(0..15)

      @formatting_hash = {"id" => @id, "title" => @title, "date" => @date, "short_date" => @short_date, "author_name" => @author_name,
                          "text_bite" => @text_bite}

      @front_page_array << @formatting_hash
    x -= 1
  end
  
  erb :homepage
end

# get "/login_to_submit" do
#   erb :login
# end

get "/articles" do
  @article_id = params[:id]
  @title = params[:title]
  @date = params[:date]

  erb :"articles/article_template"
end

get "/submit_draft" do
  @author_values_array = Author.all("authors")
  
  @location_values_array = Location.all("location_keys")

  erb :"articles/submit_draft"
end

get "/review_draft" do
  @author_values_array = Author.all("authors")
  @author = params[:author].to_i
  @title = params[:title]
  @text = params[:article_text]
  
  @location_values_array = Location.all("location_keys")
  @existing_location_tag = params[:existing_location_tag].to_i #numeric id value for location
  
  if params[:city] != nil # If there is input in this field, set these params to variables to make a new location
    
    @location_name = params[:location_name]
    @street = params[:street]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
    
  end

  erb :"articles/review_draft"

  # EXTENSION: FIND OUT HOW TO INSERT UNIQUE IDENTIFIER INSTEAD
end

get "/new_article" do
  @date = params[:date]
  @author = params[:author]
  @title = params[:title]
  @text = params[:article_text]
  
  @sql_formatted_date = @date.byteslice(0..9)
  @sql_formatted_time = @date.byteslice(11..18)
  
  @sql_date_entry = @sql_formatted_date + " " + @sql_formatted_time
  
  @html_formatted_date = @sql_formatted_date + " " + @sql_formatted_time.byteslice(0..4)
  
  new_entry = Article.new("date" => @sql_date_entry, "author_id" => @author, "title" => @title, 
                          "text" => @text)

  new_entry.insert("articles")
  
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
  # RIGHT NOW THIS IS PUTTING FOUR <br> TAGS BETWEEN PARAGRAPHS. UGH.
  
  return_array = Author.find_by_id("authors", @author.to_i)
  author_hash = return_array[0]
  @author_name = author_hash["name"]
  
  #### ADRESSES ###
  #################
  
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

    found_location = Location.find_by_id("location_keys", @existing_location_tag)
                    # => Returns Array with one Hash
    location_info = found_location[0]
    @location_name = location_info["location_name"]
    @street = location_info["street"]
    @city = location_info["city"]
    @state = location_info["state"]
    @country = location_info["country"]
    @address = location_info["address"]

    matched_location = MatchAwL.new("location_id" => location_info["id"], "article_id" => new_entry.id)

    matched_location.insert("articles_with_locations")

  end
  
@search_query = "https://www.google.com/maps/embed/v1/search?key=#{@api_key}&q=#{@address}"  
  
  
  erb :"articles/new_article"
end
