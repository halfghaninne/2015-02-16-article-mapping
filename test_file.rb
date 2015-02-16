require 'pry'
require 'minitest/autorun'

require 'sqlite3'

DATABASE = SQLite3::Database.new("article_info_test.db")

require_relative 'database_setup.rb'
require_relative 'article.rb'
require_relative 'author.rb'
require_relative 'location.rb'

class DatabaseTest < Minitest::Test
  
  def clear_setup
    DATABASE.execute("DELETE FROM articles")
    DATABASE.execute("DELETE FROM location_keys")
    DATABASE.execute("DELETE FROM authors")
  end
  
##############################
#       Author Tests         #
##############################

  def test_author_creation
    newauthor = Author.new(name: "Tester Testington")
    newauthor.insert("authors")
    results = DATABASE.execute("SELECT name FROM authors WHERE id = #{newauthor.id}")
    
    added_record = results[0]
    
    assert_equal(1, results.length)
    assert_equal("Tester Testington", added_record[:name])
  end
  
  def test_list_all_authors
    DATABASE.execute("DELETE FROM authors")
    a1 = Author.new(name: "Tester Testington")
    a2 = Author.new(name: "Test Faker")
    a1.insert
    a2.insert
    
    assert_equal(2, Author.all.length)
  end
  
  def test_delete_author
    DATABASE.execute("DELETE FROM authors")
    a1 = Author.new(name: "Tester Testington")
    a2 = Author.new(name: "Test Faker")
    a1.insert
    a2.insert
    
    Author.delete("authors", 2)
    
    results = DATABASE.execute("SELECT * FROM authors")
    remaining_record = results[0]
    
    #binding.pry #check return value of remaining_record
    
    assert_equal(1, remaining_record["id"])
    assert_equal(1, Author.all.length)
  end

##############################
#       Location Tests       #
##############################

##############################
#       Article Tests        #
##############################