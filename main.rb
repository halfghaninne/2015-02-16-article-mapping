require 'sinatra'

require 'pry'
require 'sqlite3'

DATABASE = SQLite3::Database.new("article_info.db")

require_relative "database_setup.rb"