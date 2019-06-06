class TeaShopper::CLI
## This class presents data and gets input from user

  attr_reader :song_base_url, :song_index_url

  # Controller
  def run
    self.welcome

    # Make initial tea objects
    self.make_teas

    # Start process of selecting a tea category, subcategory, and tea
    self.guide_user
  end

  # Create tea instances
  def make_teas
    # puts "We're pulling today's tea categories from the web. This may take a few moments...\n"
    tea_array = SongScraper.scrape_teas
    Tea.create_from_collection(tea_array)
  end

  # Add additional attributes to tea instances from profile pages
### scrape teas just from category  
  def add_scraped_attributes(tea_array)
    self.spacer
    puts "We're pulling today's teas from the web. This may take a few moments...\n"

    tea_array.each do |tea|
      attributes = SongScraper.scrape_profile_page(tea.url)
      tea.add_tea_attributes(attributes)
    end
  end

  # Guide user through category, subcategory, and tea selection
  def guide_user
    # Main menu: get category from user
    # category = self.display_main_menu
    category = "type"
    subcategory = nil
    selected_tea = nil

    # Display category selections, get subcategory
    subcategory = self.display_category(category)

    # Show subcategory menu of teas
    selected_tea = self.display_subcategory(subcategory, category) if subcategory

    # Display tea profile
    self.display_tea(selected_tea) if selected_tea

    self.goodbye
  end


#   # Display top menu and get input
#   def display_main_menu
#     self.section_title("Main Menu")

#     # Display instructions and get input
#     puts "Choose a method below to explore today's teas:\n(Or type 'X' to exit)"
#     puts "\n"
#     puts "- Type".colorize(:light_blue)
#     # Song too complicated to include initially
#     # puts "- Region".colorize(:light_blue)
#     puts "- Shop\n".colorize(:light_blue)
#     input = gets.strip.downcase

# ### Turn into method
#     # If input is x or exit, say goodbye
#     if input == "x" || input == "exit"
#       self.goodbye
#     # Else check valid input
#     elsif (input != "type") && (input != "region") && (input != "shop")
#       puts "Your input wasn't recognized, so we'll list tea by Type."
#       input = "type"
#     end

#     return input
#   end

### Improve for region and shop
  # Display menu for tea type
  def display_category(category)
    # Display instructions and potential selections
    # title = "Tea " + category.capitalize
    # self.section_title(title)
    puts "Choose a category below find your next great tea:\n(Or type 'X' to exit)"
    puts "\n"

    # Display list of tea categories
    # case category
    #   when "shop"
    #     Tea.shops.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
    #     puts "\n"
    #   when "region"
    #     Tea.regions.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
    #     puts "\n"
    #   else
        Tea.types.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
        puts "\n"
    # end

    # Get input, match to next step
    input = gets.strip.downcase
    
    # Ensure valid input
    if self.exit?(input) 
      # return self.goodbye
      input = nil
    elsif input.include?("black")
      input = "black/red"
    elsif Tea.types.none?{|obj| obj == input}
      puts "\nHmmm, we don't recognize that type of tea, so we'll show you our favorite: Black/red teas!"
      input = "black/red"
    end

    return input 
  end

  # Display submenu with numbered list of teas, return tea object
  def display_subcategory(subcategory, category)

    # Assign teas to display
    # case category
    #   when "shop"
    #     teas = Tea.teas_by_shop(subcategory)
    #   when "region"
    #     teas = Tea.teas_by_region(subcategory)
    #   else
        teas = Tea.teas_by_type(subcategory)
    # end

    # Scrape profile attributes to subset of tea objects
    self.add_scraped_attributes(teas)

    # Display title and instructions
    title = subcategory.capitalize + " Tea"
    self.section_title(title)    
    self.list_instructions

    # Repeat list and selection process until valid input received
    input = ""
    until self.valid_tea?(input, teas) || input == nil

      # Display ordered list of teas
      self.num_list(teas)
      puts "\n"

      # Get input, match to next step
      input = gets.strip.downcase

      # If input is a number, check for range and find tea by index
      if self.convert_to_index(input).between?(0,teas.length)
        return teas[self.convert_to_index(input)]
      # Else check if input is a tea name
      elsif teas.find{|obj| obj.name.downcase == input}
        return teas.find{|obj| obj.name.downcase == input}
      # If exit, send goodbye
      elsif self.exit?(input) 
        # return self.goodbye
        return nil
      else
        self.spacer
        puts "We don't recognize that tea, so we'll show the list again.\n\n"
        self.list_instructions
      end
    end
  end

  # Return true if input matches a tea by number or name
  def valid_tea?(input, array)
    self.convert_to_index(input).between?(0, array.length) || array.any?{|obj| obj.name.downcase == input}
  end

  # Convert input into array index
  def convert_to_index(input)
    return input.to_i - 1
  end

  # Display types for tea shop
  # def shop_menu
  #   # Display instructions and potential selections
  #   # puts "Teas have many flavors. Select a flavor profile below to explore available teas."
  #   Tea.shop_name.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}
  # end

  # Take in name of tea, find tea object, display all details
  def display_tea(tea)

    # Name
    title = "#{tea.name} (#{tea.type} tea)"
    
    # self.section_title(title)
    self.spacer 
    puts title.colorize(:green)
    puts tea.url.colorize(:light_blue)
    puts "\n"
    
    # Out of stock warning
    puts "Oh no! It's #{tea.stock}!\n".colorize(:red) if tea.stock != ""

    # Shop name and price
    puts "Shop:" + "     #{tea.shop_name}".colorize(:light_blue)
    puts "Price:" + "    $#{tea.price} for #{tea.size} grams (#{tea.price_per_oz} per oz.)".colorize(:light_blue)

    # Region, harvest, flavors
    puts "Region:" + "   #{tea.region}".colorize(:light_blue)
    puts "Harvest:" + "  #{tea.date}".colorize(:light_blue)
    puts "Flavors:" + "  #{tea.flavors}\n".colorize(:light_blue)

    # Show next steps
    puts "Want more? Choose:"
    puts "- D to view this tea's (potentially long) description".colorize(:light_blue)
    puts "- M to start again at the main menu".colorize(:light_blue)
    puts "- X to exit".colorize(:light_blue)
    puts "\n"

    input = gets.strip.downcase
    # case input
    if input == "d"
      desc_title = tea.name + " Description:".colorize(:green)
      self.section_title(desc_title)
      puts tea.description 
      puts "\n" + tea.instructions
      puts tea.detailed_instructions
      puts "\n"
      puts "\nAnd now? Choose:"
      puts "- M to start again at the main menu".colorize(:light_blue)
      puts "- X to exit".colorize(:light_blue)
      puts "\n"

      next_input = gets.strip.downcase
      self.guide_user if next_input == "m"
        # else
        #   self.goodbye
    elsif input == "m"
        self.guide_user
    # else
    #   self.goodbye
    end
  end


  ##### Display Helpers #####
  
  # Welcome message
  def welcome
    self.section_title("Welcome to Tea Shopper!")
  end

  # Goodbye message
  def goodbye
    puts "\nThanks for stopping by. Happy tea drinking!\n\n"
  end

  # If input is exit, say goodbye
  def exit?(input)
    input.downcase == "x" || input.downcase == "exit"
  end

  # Submenu instructions
  def list_instructions
    # puts "Choose a tea number from the list below to get more details and buying info."
    puts "Choose a number or tea name from the list below get the details.\n(Or type 'X' to exit)"
    puts "\n"
  end
  
  # Reusable display spacer
  def spacer
    puts "\n----------\n\n"
  end

  # Title for section, including spacer
  def section_title(title)
    self.spacer 
    puts title.colorize(:green) + "\n\n"
  end

  # Display numbered list of tea names
  def num_list(array)
    array.each.with_index(1) { |obj, index| puts "#{index}. #{obj.name} ($#{obj.price_per_oz} per oz., #{obj.shop_name})".colorize(:light_blue) }
  end

end