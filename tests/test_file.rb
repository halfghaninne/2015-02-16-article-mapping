require 'pry'
require 'minitest/autorun'

require 'sqlite3'

DATABASE = SQLite3::Database.new("article_info_test.db")

require_relative 'database_setup.rb'
require_relative 'article.rb'
require_relative 'author.rb'
require_relative 'location.rb'

class DatabaseTest < Minitest::Test
  
  def setup
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
    id = newauthor.id
    results = DATABASE.execute("SELECT name FROM authors WHERE id = #{id}")
    
    added_record = results[0]
        
    assert_equal(1, results.length)
    assert_equal("Tester Testington", added_record["name"])
  end
  
  def test_list_all_authors
    DATABASE.execute("DELETE FROM authors")
    a1 = Author.new(name: "Tester Testington")
    a2 = Author.new(name: "Test Faker")
    a1.insert("authors")
    a2.insert("authors")
    
    return_table = Author.all("authors")
    
    assert_equal(2, return_table.length)
  end
  
  def test_delete_author
    DATABASE.execute("DELETE FROM authors")
    a1 = Author.new(name: "Tester Testington")
    a2 = Author.new(name: "Test Faker")
    a1.insert("authors")
    a2.insert("authors")
    
    Author.delete("authors", 2)
    
    results = DATABASE.execute("SELECT * FROM authors")
    remaining_record = results[0]
    
    return_table = Author.all("authors")
    
    #binding.pry #check return value of remaining_record
    
    assert_equal(1, remaining_record["id"])
    assert_equal(1, return_table.length)
  end

##############################
#       Location Tests       #
##############################

  def test_add_location
    newloc = Location.new(location_name: "Donut Stop")
    newloc.insert("location_keys")
    id = newloc.id
    results = DATABASE.execute("SELECT location_name FROM location_keys WHERE id = #{id}")
    
    added_record = results[0]
    
    assert_equal(1, results.length)
    assert_equal("Donut Stop", added_record["location_name"])
  end
  
  def test_list_all_locations
    DATABASE.execute("DELETE FROM location_keys")
    l1 = Location.new(name: "Donut Stop")
    l2 = Location.new(name: "Omaha Code School")
    l1.insert("location_keys")
    l2.insert("location_keys")
    
    return_table = Location.all("location_keys")
    
    assert_equal(2, return_table.length)
  end
  
  def delete_location
    DATABASE.execute("DELETE FROM location_keys")
    l1 = Location.new(name: "Donut Stop")
    l2 = Location.new(name: "Omaha Code School")
    l1.insert("location_keys")
    l2.insert("location_keys")
        
    Location.delete("location_keys", 2)
    
    results = DATABASE.execute("SELECT * FROM location_keys")
    remaining_record = results[0]
    
    return_table = Location.all("location_keys")
        
    assert_equal(1, remaining_record["id"])
    assert_equal(1, return_table.length)
  end

##############################
#       Article Tests        #
##############################

  def test_add_article
    newauthor = Author.new(name: "Place Holder")
    newauthor.insert("authors")
    
    newart = Article.new("date" => "2015-02-16 15:21:00.000", "author_id" => 1, 
                        "text" => "This is sample text of an article. I am a little
                        nervous about entering in all of this text in the form of
                        a string. I am curious to think how this might be formatted
                        from HTML user interface to Ruby back-end operations. 
                        I am particularly worried about paragraph separation and 
                        special characters. Yikes.")
                        
    newart.insert("articles")
    
    results = DATABASE.execute("SELECT * FROM articles")
    added_record = results[0]
    
    return_table = Article.all("articles")
    
    assert_equal(1, added_record["id"])
    assert_equal(1, return_table.length)
  end

  # def test_list_all_articles
  # end

  def delete_article
  end



end