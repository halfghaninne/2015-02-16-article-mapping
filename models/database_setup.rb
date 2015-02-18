require 'pry'
require 'sqlite3'

DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS authors (id INTEGER PRIMARY KEY, name TEXT)")

DATABASE.execute("CREATE TABLE IF NOT EXISTS location_keys (id INTEGER PRIMARY 
                  KEY, location_name TEXT UNIQUE, business_name TEXT, street TEXT UNIQUE,
                  city TEXT NOT NULL, state TEXT NOT NULL, country TEXT)") 
#add in another field later - after figuring out what kind of input to pass into Google Maps API

DATABASE.execute("CREATE TABLE IF NOT EXISTS articles (id INTEGER PRIMARY KEY, 
                  date DATE, author INTEGER, title TEXT, text TEXT, FOREIGN KEY(author) 
                  REFERENCES authors(id))")

# not associated with an object class 
DATABASE.execute("CREATE TABLE IF NOT EXISTS articles_with_locations 
                  (article_id INTEGER, location_id INTEGER, 
                  FOREIGN KEY(article_id) REFERENCES articles(id), 
                  FOREIGN KEY(location_id) REFERENCES location_keys(id))")