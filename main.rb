require 'sinatra'

require 'pry'
require 'sqlite3'

DATABASE = SQLite3::Database.new("article_info.db")

require_relative "models/database_setup.rb"
require_relative "models/author.rb"
require_relative "models/article.rb"
require_relative "models/location.rb"


#### I THINK IT WOULD BE GOOD HERE TO DEFINE @ VARIABLES FOR ALL ARTICLES ON THE HOMEPAGE IN A MODULE. ####

get "/" do
  erb :homepage
  
  # x = n-9
  # until x == n do |hash|
  #   @title = hash["title"]
  #   @author = hash["author_id"]
  #     return_array = Author.find_by_id("authors", @author.to_i)
  #     author_hash = return_array[0]
  #   @author_name = author_hash["name"]
  #   @text = hash["text"].byteslice(0..70)
  #
  #   @formatting_hash = {"title" => @title, "author_name" => @author_name,
  #                       "text" => @text}
  #
  #   @front_page_array << @formatting_hash
  # end
  
end

# get "/login_to_submit" do
#   erb :login
# end

get "/submit_draft" do
  @author_values_array = Author.all("authors")

  erb :"articles/submit_draft"
end

get "/review_draft" do
  @author_values_array = Author.all("authors")
  @author = params[:author].to_i
  @title = params[:title]
  @text = params[:article_text]

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
  
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
  # RIGHT NOW THIS IS PUTTING FOUR <br> TAGS BETWEEN PARAGRAPHS. UGH.
  
  return_array = Author.find_by_id("authors", @author.to_i)
  author_hash = return_array[0]
  @author_name = author_hash["name"]
  
  erb :"articles/new_article"
end
