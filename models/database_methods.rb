module DatabaseMethods
  
  def self.included(base)
    base.extend ClassMethods
  end
  
#########################################################
# Class Methods - for operations involving entire table #
#########################################################
  
  module ClassMethods
    
    #
    #
    #
    #
    # Returns an Author, Location, or Article Object
    
    def find_by_id(table_name, record_id)
      results = DATABASE.execute("SELECT *  FROM #{table_name} WHERE id = 
                                #{record_id}")
                                
      if results != nil 
        record_hash = results[0]

        if table_name == "authors"
          self.new("id" => record_hash["id"], "name" => record_hash["name"])
        
        elsif table_name == "location_keys"
          self.new("id" => record_hash["id"], "location_name" => record_hash["location_name"], 
          "street" => record_hash["street"], "city" => record_hash["city"], 
          "state" => record_hash["state"], "country" => record_hash["country"])
        
        elsif table_name == "articles"
            self.new("id" => record_hash["id"], "date" => record_hash["date"], 
            "author" => record_hash["author"], "title" => record_hash["title"], 
            "text" => record_hash["text"])
        
        # elsif table_name == "articles_with_locations"
        end #if loop
      
      else
        nil
      end #if else loop
      
    end
    
    #
    #
    #
    #
    # Returns an Author, Location, or Article Object
    
    def find_by_var(table_name, var_name, var_value)
      
      if var_value.is_a?(Integer)
        results = DATABASE.execute("SELECT * FROM #{table_name} WHERE #{var_name} 
                                  = #{var_value}")
        # => Returns Array of ONE Hash (for now)
  
      elsif 
        results = DATABASE.execute("SELECT * FROM #{table_name} WHERE #{var_name} 
                                  = '#{var_value}'")
      end #if loop
      
      record_hash = results[0]
      
      if table_name == "authors"
        self.new("id" => record_hash["id"], "name" => record_hash["name"])
        
      elsif table_name == "location_keys"
        self.new("id" => record_hash["id"], "location_name" => record_hash["location_name"], 
        "street" => record_hash["street"], "city" => record_hash["city"], 
        "state" => record_hash["state"], "country" => record_hash["country"])
        
      elsif table_name == "articles"
          self.new("id" => record_hash["id"], "date" => record_hash["date"], 
          "author" => record_hash["author"], "title" => record_hash["title"], 
          "text" => record_hash["text"])
          
      elsif table_name == "articles_with_locations"
          self.new(record_hash)
      end #if loop
    end #method
    
    #
    #
    #
    #
    # Returns: Array of Hashes
    
    # CHANGE TO RETURN AN OBJECT, NOT ARRAY   
    def all(table_name)
      
      many_results = DATABASE.execute("SELECT * FROM #{table_name}")
      # => Array of lots of hashes.
      
      objects_array = []
      
      many_results.each do |record_hash|
        if table_name == "authors"
          obj = self.new("id" => record_hash["id"], "name" => record_hash["name"])
          
        elsif table_name == "location_keys"
          obj = self.new("id" => record_hash["id"], "location_name" => record_hash["location_name"], 
          "street" => record_hash["street"], "city" => record_hash["city"], 
          "state" => record_hash["state"], "country" => record_hash["country"])
          
        elsif table_name == "articles"
          obj = self.new(record_hash)
          #obj = self.new(record_hash) might actually cause problems with id overwrite but for now, just go with it
        end # if loop
        
        objects_array << obj
  
      end # each do loop
      
      objects_array

    end # method
    
    #
    #
    #
    #
    #
    
    def delete (table_name, record_id)
      DATABASE.execute("DELETE FROM #{table_name} WHERE id = #{record_id}")
    end
    
  end
  
#########################################################
# Instance Methods - for operations within one record   #
#########################################################
  
  #
  #
  #
  #
  #
  
  def insert(table_name)
    if table_name == "authors"
      DATABASE.execute("INSERT INTO authors (name) VALUES ('#{@name}')")
      @id = DATABASE.last_insert_row_id
      
    elsif table_name == "location_keys"
      DATABASE.execute("INSERT INTO location_keys (location_name, street, city, 
                      state, country, address, latitude, longitude) VALUES ('#{@location_name}', '#{@street}', 
                      '#{@city}', '#{@state}', '#{@country}', '#{@address}', #{@latitude}, 
                      #{@longitude})")
      @id = DATABASE.last_insert_row_id
      
    elsif table_name == "articles"
      DATABASE.execute("INSERT INTO articles (date, author, text, title) VALUES 
                      ('#{@date}', #{@author}, '#{@text}', '#{@title}')")
      @id = DATABASE.last_insert_row_id
      
    elsif table_name == "articles_with_locations"
      DATABASE.execute("INSERT INTO articles_with_locations (article_id, location_id) 
                      VALUES (#{@article_id}, #{@location_id})")
      
    end
  end
  
  #
  #
  #
  #
  #
  
  def save(table_name)
    attributes = []
  
    instance_variables.each do |i|
      attributes << i.to_s.delete("@")
    end
  
    query_components_array = []
  
    attributes.each do |a|
      value = self.send(a)
    
      if value.is_a?(Integer)
        query_components_array << "#{a} = #{value}"
      else
        query_components_array << "#{a} = '#{value}'"
      end
    end
     
    query_string = query_components_array.join(", ")
  
    DATABASE.execute("UPDATE #{table_name} SET #{query_string} WHERE id =                             #{id}")
  end

  # def list_attributes
  #   attributes = []
  #   instance_variables.each do |i|
  #     attributes << i.to_s.delete("@")
  #   end
  #
  #   attribute_string = attributes.join("\n")
  #   puts "#{attribute_string}"
  # end
  
end
