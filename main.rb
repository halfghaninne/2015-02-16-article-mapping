require 'sinatra'

require 'pry'
require 'sqlite3'
require 'geocoder'

DATABASE = SQLite3::Database.new("article_info.db")

require_relative "models/database_setup.rb"
require_relative "models/author.rb"
require_relative "models/article.rb"
require_relative "models/location.rb"


#### I THINK IT WOULD BE GOOD HERE TO DEFINE @ VARIABLES FOR ALL ARTICLES ON THE HOMEPAGE IN A MODULE. ####

get "/" do
  erb :homepage
  
  ##########################################################
  # METHODS FOR BRINGING LATEST ARTICLES TO THE FRONT PAGE #
  ##########################################################
   
  # @article_values_array = Article.all("articles")
  #   # => an Array of Hashes
  # n = @article_values_array.length
  #
  # @front_page_array = []
  #
  # x == (n - 1)
  # until x == (n - 10) do
  #   hash = @article_values_array[x]
  #     @title = hash["title"]
  #     @author = hash["author_id"]
  #       return_array = Author.find_by_id("authors", @author.to_i)
  #       author_hash = return_array[0]
  #     @author_name = author_hash["name"]
  #     @text = hash["text"].byteslice(0..70)
  #
  #     @formatting_hash = {"title" => @title, "author_name" => @author_name,
  #                         "text" => @text}
  #
  #     @front_page_array << @formatting_hash
  #   x -= 1
  # end
  
end

# get "/login_to_submit" do
#   erb :login
# end

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
  @location_tag = params[:existing_location_tag] #numeric id value for location
  
  if params[:city] != nil
    
    @location_name = params[:location_name]
    @business_name = params[:business_name]
    @street = params[:street]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
    
  end

  erb :"articles/review_draft"

  # FIND OUT HOW TO INSERT UNIQUE IDENTIFIER INSTEAD
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
  
  #### 
  #### LOCATION STUFF
  ####
  ####
  
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
  # RIGHT NOW THIS IS PUTTING FOUR <br> TAGS BETWEEN PARAGRAPHS. UGH.
  
  return_array = Author.find_by_id("authors", @author.to_i)
  author_hash = return_array[0]
  @author_name = author_hash["name"]
  
  erb :"articles/new_article"
end
