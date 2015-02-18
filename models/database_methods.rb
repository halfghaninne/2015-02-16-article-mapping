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
  
  def insert(table_name)
    if table_name == "authors"
      DATABASE.execute("INSERT INTO authors (name) VALUES ('#{@name}')")
      @id = DATABASE.last_insert_row_id
      
    elsif table_name == "location_keys"
      DATABASE.execute("INSERT INTO location_keys (location_name) VALUES 
                        ('#{@location_name}')")
      @id = DATABASE.last_insert_row_id
      
    elsif table_name == "articles"
      DATABASE.execute("INSERT INTO articles (date, author, text) VALUES 
                      ('#{@date}', #{@author}, '#{@text}')")
      @id = DATABASE.last_insert_row_id
      
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
