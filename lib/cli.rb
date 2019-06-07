class TeaShopper::CLI
## This class presents data and gets input from user

  # attr_reader :song_base_url, :song_index_url
  attr_accessor :category, :subcategory, :selected_tea

  # Set instance variables
  def initialize
    @category = nil
    @subcategory = nil
    @selected_tea = nil
    self.run
  end

  ##### Controller #####
  def run
    self.welcome

    # Make initial tea objects
    self.make_teas

    # Start process of selecting a tea category, subcategory, and tea
    self.find_teas
  end

  ##### Build Tea Objects #####
  # Create initial Tea objects
  def make_teas
    # puts "We're pulling today's tea categories from the web. This may take a few moments...\n"
    tea_array = SongScraper.scrape_teas
    Tea.create_from_collection(tea_array)
  end

  # Add additional attributes to Tea objects from scraped profile pages
  def add_scraped_attributes(tea_array)
    self.separator
    
    # Include note for potentially long scrape time
    puts "We're pulling today's teas from the web. This may take a few moments...\n"

    # Only add to teas we need to display. Scrape from category array, not full Tea.all array.
    tea_array.each do |tea|
      attributes = SongScraper.scrape_profile_page(tea.url)
      tea.add_tea_attributes(attributes)
    end
  end

  ##### Find Teas #####
  # Set category, subcategory, and tea selection
  def find_teas

    # Display category selections, get subcategory
    # subcategory = self.display_category
    self.display_category

    # Show subcategory teas, get tea selection
    # selected_tea = self.display_subcategory(subcategory, category) if @subcategory
    self.display_subcategory if @subcategory

    # Display tea profile
    self.display_tea if @selected_tea

    self.goodbye
  end

  # Display menu for tea type, set @subcategory
  def display_category

    # Display instructions
    puts "Choose a category below find your next great tea:\n(Or type 'X' to exit)"
    puts "\n"

    # Display today's tea types, get input
    Tea.types.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
    puts "\n"
    input = gets.strip.downcase
    
    # Input validation
    # If input is exit, return with nil @subcategory
    if self.exit?(input) 
      @subcategory = nil
    # If input is simply "black", set subcategory to "black/red"
    elsif input.include?("black")
      @subcategory = "black/red"
    # If input isn't a current tea type, set to "black/red"
    elsif Tea.types.none?{|obj| obj == input}
      puts "\nHmmm, we don't recognize that type of tea, so we'll show you our favorite: Black/red teas..."
      @subcategory = "black/red"
    else
      @subcategory = input
    end

  #### Debug
  puts "End of display_category" 

  end

  # Display ordered list of teas (alphabetically sorted), set @selected_tea
  def display_subcategory
    # Assign teas to display
    teas = Tea.teas_by_type(@subcategory)
    
    # Scrape profile attributes for subset of tea objects
    self.add_scraped_attributes(teas)

    # Display title and instructions
    title = @subcategory.capitalize + " Tea"
    self.section_title(title)    
    self.list_instructions

    # Repeat list and selection process until valid input received
    input = ""
    until @selected_tea != nil || input == "x"
      # self.valid_tea?(input, teas) || input == nil

      # Display ordered list of teas
      self.num_list(teas)
      puts "\n"

      # Get input, match to next step
      input = gets.strip.downcase

      # If input is a number, check for range and find tea by index
      if self.convert_to_index(input).between?(0,teas.length)
        @selected_tea = teas[self.convert_to_index(input)]
      # Else return tea if name exists
      elsif teas.find{|obj| obj.name.downcase == input}
        @selected_tea = teas.find{|obj| obj.name.downcase == input}
      # If exit, keep at nil, send goodbye
      elsif self.exit?(input) 
        input = "x"
      else
        self.separator
        puts "We don't recognize that tea, so we'll show the list again...\n\n"
        self.list_instructions
      end
    end

#### Debug
puts "End of display_subcategory"

  end

  # Take in name of tea, find tea object, display all details
  def display_tea
    tea = @selected_tea

    # Name
    title = "#{tea.name} (#{tea.type} tea)"
    
    # self.section_title(title)
    self.separator 
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
    next_input = nil

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
    end

    # If M is selected, return to the main menu    
    self.find_teas if input == "m" || next_input == "m"

#### Debug
    puts "End of display_tea"

  end


  ##### Logic Helpers #####

  # Return true if input matches a tea by number or name
  def valid_tea?(input, array)
    self.convert_to_index(input).between?(0, array.length) || array.any?{|obj| obj.name.downcase == input}
  end

  # Convert input into array index
  def convert_to_index(input)
    return input.to_i - 1
  end

  # Check if input is exit
  def exit?(input)
    input.downcase == "x" || input.downcase == "exit"
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

  # Submenu instructions
  def list_instructions
    puts "Choose a number or tea name from the list below get the details.\n(Or type 'X' to exit)"
    puts "\n"
  end
  
  # Section separator
  def separator
    puts "\n----------\n\n"
  end

  # Title for section, including separator
  def section_title(title)
    self.separator 
    puts title.colorize(:green) + "\n\n"
  end

  # Display numbered list from array input
  def num_list(array)
    array.each.with_index(1) { |obj, index| puts "#{index}. #{obj.name} ($#{obj.price_per_oz} per oz., #{obj.shop_name})".colorize(:light_blue) }
  end

end