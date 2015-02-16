require 'pry'
require 'sqlite3'

DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS authors (id INTEGER PRIMARY KEY, name TEXT)")

DATABASE.execute("CREATE TABLE IF NOT EXISTS location_keys (id INTEGER PRIMARY 
                  KEY, location_name TEXT)") 
#add in another field later - after figuring out what kind of input to pass into Google Maps API

DATABASE.execute("CREATE TABLE IF NOT EXISTS articles (id INTEGER PRIMARY KEY, 
                  date DATE, time TIME, author INTEGER, text TEXT, FOREIGN KEY(author) 
                  REFERENCES authors(id))")

DATABASE.execute("CREATE TABLE IF NOT EXISTS articles_with_locations 
                  (article_id INTEGER, location_id INTEGER, 
                  FOREIGN KEY(article_id) REFERENCES articles(id), 
                  FOREIGN KEY(location_id) REFERENCES location_keys(id))")