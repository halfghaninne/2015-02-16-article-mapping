#
#
#
#
#
#
#

module MainHelper
  
  # Private: format_for_homepage
  # * description here *
  #
  # Parameters:
  # None.
  #
  # Returns:
  # Array of Hashes - @front_page_array - to be looped through on the homepage.
  #
  # State Changes:
  # None.
  
  def format_for_homepage
  
  @article_objects_array = Article.get_ten
    # => an Array of Objects
    
  @front_page_array = []

    @article_objects_array.each do |selected_object|
        @id = selected_object.id
        @title = selected_object.title
        @author = selected_object.author 
          # => Integer
        
          author_object = Author.find_by_var("authors", "id", @author) 
            # => one Object
          
        @author_name = author_object.name
        @full_text = selected_object.text
        @text_bite = @full_text.byteslice(0..70)
        @short_date = selected_object.date.byteslice(5..9)
        @date = selected_object.date.byteslice(0..15)

        @formatting_hash = {"id" => @id, 
                            "title" => @title, 
                            "date" => @date, 
                            "short_date" => @short_date, 
                            "author_name" => @author_name,
                            "text_bite" => @text_bite}

        @front_page_array << @formatting_hash
      
    end #each loop
  
  end #method
  
  #
  #
  #
  # Returns:
  # String - @text - text field associated with unique Article record
  # Integer - @author - the author id associated with the unique record
  #
  # State Changes:
  # None.
  
  def get_article_info(article_id)
    article_object = Article.find_by_var("articles", "id", article_id) 
      # => one Article Object
    @text = article_object.text  
    @author = article_object.author
  end #method
  
  # Private: get_author_name
  # 
  #
  # Parameters:
  # + author    : Integer
  #
  # Returns:
  # String - @author_name - name associated with the unique Author record.
  #
  # State Changes:
  # None.
  
  def get_author_name(author)
    author_object = Author.find_by_var("authors", "id", author) 
      # => one Author Obj
    @author_name = author_object.name
  
  end #method
  
  # Private: get_location_info
  #
  # Parameters:
  # + article_id    :  Integer
  #
  # Returns:
  # String - @location_name - name of Location Object associated with this
  # specific Article Object
  # String - @address - string of location info for this Location Object
  #
  # State Changes:
  # None.
  
  def get_location_info(article_id)
    
    location_id_info_object = MatchAwL.find_by_var("articles_with_locations", "article_id", article_id)
    location_id = location_id_info_object.location_id
    location_object = Location.find_by_var("location_keys", "id", location_id)
    @location_name = location_object.location_name
    
    @address = location_object.address
  
  end #method
  
  #
  #
  #
  #
  # Returns:
  # String - @sql_date_entry
  # String - @html_formatted_date
  #
  # State Changes:
  # None.
  
  def format_date(date)
    sql_formatted_date = date.byteslice(0..9)
    sql_formatted_time = date.byteslice(11..18)
  
    @sql_date_entry = sql_formatted_date + " " + sql_formatted_time
    
    @html_formatted_date = sql_formatted_date + " " + sql_formatted_time.byteslice(0..4)
  end
  
  def make_new_location(params) #params is an options Hash
    
    @location_name = params[:location_name]
    @street = params[:street]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
    
    new_location_key = Location.new( "location_name" => @location_name, 
                                    "street" => @street, 
                                    "city" => @city, 
                                    "state" => @state, 
                                    "country" => @country )
    # new_location_key.coordinates

    @address = new_location_key.address

    new_location_key.insert("location_keys")
    
    @location_id = new_location_key.id
  
  end #method
  
  #
  #
  #
  #
  #
  #
  
  def match_location(location_id, article_id)
    
    matched_location = MatchAwL.new("location_id" => location_id, "article_id" => article_id)

    matched_location.insert("articles_with_locations")
    
  end
  
  #
  #
  #
  #
  #
  #
  
  
  def retrieve_location(params) #params is an options Hash
    
    @existing_location_tag = params[:existing_location_tag].to_i

    existing_location_object = Location.find_by_var("location_keys", "id", @existing_location_tag)
                   # => Returns one Location Object
    @location_name = existing_location_object.location_name
    @street = existing_location_object.street
    @city = existing_location_object.city
    @state = existing_location_object.state
    @country = existing_location_object.country
    @address = existing_location_object.address
    
    @location_id = existing_location_object.id
   
  end #method
  
  #
  #
  #
  #
  #
  
  def get_map_embed(address)
    @api_key = "AIzaSyABlSFznPfoZu61HT_6w3YwNdGkY0mx5Z8"   
    @search_query = "https://www.google.com/maps/embed/v1/search?key=#{@api_key}&q=#{@address}"  
  end

  
end #module