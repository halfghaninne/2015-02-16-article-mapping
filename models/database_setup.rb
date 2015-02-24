require 'pry'
require 'sqlite3'

DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS authors (id INTEGER PRIMARY KEY, name TEXT)")

DATABASE.execute("CREATE TABLE IF NOT EXISTS location_keys (id INTEGER PRIMARY 
                  KEY, location_name TEXT NOT NULL, street TEXT,
                  city TEXT NOT NULL, state TEXT NOT NULL, country TEXT, address TEXT, 
                  latitude FLOAT, longitude FLOAT)") 
                  # consider adding in a google maps url string as a field.
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS articles (id INTEGER PRIMARY KEY, 
                  date DATE, author INTEGER, title TEXT, text TEXT, FOREIGN KEY(author) 
                  REFERENCES authors(id))")
                  # consider adding in an image field lol

# not associated with an object class 
DATABASE.execute("CREATE TABLE IF NOT EXISTS articles_with_locations 
                  (article_id INTEGER, location_id INTEGER, 
                  FOREIGN KEY(article_id) REFERENCES articles(id), 
                  FOREIGN KEY(location_id) REFERENCES location_keys(id))")