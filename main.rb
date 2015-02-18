require 'sinatra'

require 'pry'
require 'sqlite3'

DATABASE = SQLite3::Database.new("article_info.db")

require_relative "database_setup.rb"
require_relative "author.rb"
require_relative "article.rb"
require_relative "location.rb"


#### I THINK IT WOULD BE GOOD HERE TO DEFINE @ VARIABLES FOR ALL ARTICLES ON THE HOMEPAGE IN A MODULE. ####

get "/" do
  erb :homepage
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
  # @date = params[:date]
  @author = params[:author]
  @title = params[:title]
  @text = params[:article_text]
  
  @formatted_text = @text.gsub(/[\r\n\r\n\r\n\r\n]/, "<br>")
  # RIGHT NOW THIS IS PUTTING FOUR <br> TAGS BETWEEN PARAGRAPHS. UGH.
  
  return_array = Author.find_by_id("authors", @author.to_i)
  author_hash = return_array[0]
  @author_name = author_hash["name"]
  
  erb :"articles/new_article"
end
