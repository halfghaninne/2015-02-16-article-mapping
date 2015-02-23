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
    # Returns Array of Hashes
    
    def find_by_id(table_name, record_id)
      results = DATABASE.execute("SELECT *  FROM #{table_name} WHERE id = 
                                #{record_id}")
      # author_hash = results[0]
      # self.new("id" => author_hash["id"], "name" => author_hash["name"])
      
    end
    
    #
    #
    #
    #
    # Returns: Array of Hashes
    ##### NEED TO TEST THIS METHOD ######
    
    def find_by_var(table_name, var_name, var_value)
      if var_value.is_a?(Integer)
        results = DATABASE.execute("SELECT * FROM #{table_name} WHERE #{var_name} 
                                  = #{var_value}")
      elsif 
        results = DATABASE.execute("SELECT * FROM #{table_name} WHERE #{var_name} 
                                  = '#{var_value}'")
      end
    end
    
    #
    #
    #
    #
    # Returns: Array of Hashes
    
    # CHANGE TO RETURN AN OBJECT, NOT ARRAY   
    def all(table_name)
      DATABASE.execute("SELECT * FROM #{table_name}")
    end
    
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
  
  #### REVISIT - quotes around the strings create issues for NULL values ####
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
  
  #
  #
  #
  #
  #
  
  def list_attributes
    attributes = []
    instance_variables.each do |i|
      attributes << i.to_s.delete("@")
    end
  
    attribute_string = attributes.join("\n")
    puts "#{attribute_string}"
  end
  
end
