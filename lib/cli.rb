class TeaShopper::CLI
# Present data and get input from user

  attr_accessor :category, :selected_tea

##### Controller #####
  def run
    self.welcome

    # Make initial tea objects
    self.make_teas

    # Start process of selecting a tea category and tea
    self.find_teas
  end


##### Build Tea Objects #####
  # Create initial Tea objects
  def make_teas
    puts "We're pulling today's tea categories from the web. This may take a few moments...\n"
    tea_array = TeaShopper::SongScraper.new.scrape_teas
    TeaShopper::Tea.create_from_collection(tea_array)
  end

  # Add additional attributes to Tea objects from scraped profile pages
  def add_scraped_attributes(tea_array)
    self.separator
    
    # Include note for potentially long scrape time
    puts "We're pulling today's teas from the web. This may take a few moments...\n"

    # Only add attributes to teas we need to display. Scrape from category array, not full Tea.all array.
    tea_array.each do |tea|
      attributes = TeaShopper::SongScraper.new.scrape_profile_page(tea.url)
      tea.add_tea_attributes(attributes)
    end
  end


##### Find Teas #####
  # Set and show category, tea list, and tea selection
  def find_teas

    # Display categories, get selection
    self.display_categories

    # Show list of teas, get tea selection
    self.display_list if @category

    # Display tea profile
    self.display_tea(@selected_tea) if @selected_tea
  end

  # Display menu for tea type, set @category
  def display_categories

    # Display title and instructions
    self.section_title("Main Menu")    
    self.main_instructions

    # Display today's tea types, get input
    TeaShopper::Tea.types.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
    puts "\n"
    input = gets.strip.downcase
    
    # If input is exit, return with nil @category
    if self.exit?(input) 
      @category = nil
      return self.goodbye
    # Shortcut: if input is "black", set category to "black/red"
    elsif input.include?("black")
      @category = "black/red"
    # Error check: if input isn't a current tea type, set to "black/red"
    elsif TeaShopper::Tea.types.none?{|obj| obj == input}
      puts "\nHmmm, we don't recognize that type of tea, so we'll show our favorite: Black/red teas..."
      @category = "black/red"
    else
      @category = input
    end
  end

  # Display ordered list of teas (alphabetically sorted), set @selected_tea
  def display_list
    # Assign teas to display
    teas = TeaShopper::Tea.teas_by_type(@category)

    # If user didn't already view this tea type, scrape profile attributes
    self.add_scraped_attributes(teas) if TeaShopper::Tea.no_description?(@category)
    
    # Display title and instructions
    title = @category.capitalize + " Tea"
    self.section_title(title)    
    self.list_instructions

    # Repeat list and selection process until valid input received
    until !@selected_tea.nil?

      # Display ordered list of teas and get input
      self.num_list(teas)
      puts "\n"
      input = gets.strip.downcase

      # If input is a number, check for range and find tea by index
      if self.convert_to_index(input).between?(0,teas.length-1)
        @selected_tea = teas[self.convert_to_index(input)]
      # Else return tea if name exists
      elsif TeaShopper::Tea.find_by_name(input, teas)
        @selected_tea = TeaShopper::Tea.find_by_name(input, teas)
      # If exit, set @selected_tea nil, send goodbye
      elsif self.exit?(input) 
        @selected_tea = nil
        return self.goodbye
      else
        self.separator
        puts "We don't recognize that tea, so we'll show the list again...\n\n"
        self.list_instructions
      end
    end
  end

  # Take in name of tea, find tea object, display all details
  def display_tea(tea)
    # tea = @selected_tea

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
    puts "Price:" + "    $#{tea.price} for #{tea.size} grams (#{tea.price_per_oz} per oz.)".colorize(:light_blue) if tea.price != "Sold Out"

    # Region, harvest, flavors
    puts "Region:" + "   #{tea.region}".colorize(:light_blue)
    puts "Harvest:" + "  #{tea.date}".colorize(:light_blue)
    puts "Flavors:" + "  #{tea.flavors}\n".colorize(:light_blue)

    # # Description
    # puts tea.description 
    # puts "\n"
    description_displayed = nil

    # Display next steps, get input
    until @selected_tea.nil?
      puts "What now? Choose:"
      puts "- D to view this tea's (potentially long) description".colorize(:light_blue) if description_displayed.nil?
      self.b_m_x_menu
      
      input = gets.strip.downcase
    
      # If D, display description
      if input == "d" && description_displayed.nil?
        desc_title = tea.name + " Description:".colorize(:green)
        self.section_title(desc_title)
        puts tea.description 
        # puts "\n" + tea.instructions.colorize(:light_blue)
        # puts tea.detailed_instructions
        puts "\n"
        description_displayed = "yes"
      else 
        # Reset @selected_tea to nil
        @selected_tea = nil
      end
    end

    # Open in browser, go to menu, or say goodbye
    case input
      when "b"
        self.open_browser(tea.url)
        puts "\nThe tea should now be up in your browser. We'll go back to the main menu to select more teas..."
        return self.find_teas
      when "m"
        return self.find_teas
      else
        puts "\nWe don't recognize that selection, so we'll exit..." if !exit?(input)
        return self.goodbye
    end
  end


##### Logic Helpers #####

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
    self.separator
    puts "\nThanks for stopping by. Happy tea drinking!\n\n"
  end

  # Main menu instructions
  def main_instructions
    puts "Choose a category below to find your next great tea:\n(Or type 'X' to exit)"
    puts "\n"
  end

  # Submenu instructions
  def list_instructions
    puts "Choose a number or tea name from the list below get the details.\n(Or type 'X' to exit)"
    puts "\n"
  end
  
  # Display B, M, X menu items
  def b_m_x_menu
    puts "- B to visit this tea's URL".colorize(:light_blue)
    puts "- M to start again at the main menu".colorize(:light_blue)
    puts "- X to exit".colorize(:light_blue)
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

  # Display numbered list from array input. Replace price per oz with sold out as needed.
  def num_list(array)
    printer = ""
    array.each.with_index(1) do |obj, index| 
      printer = "#{index}. #{obj.name} (".colorize(:light_blue)
      obj.price_per_oz == "Sold Out"? printer << "Sold Out".colorize(:red) : printer << "$#{obj.price_per_oz} per oz.".colorize(:light_blue)
      printer << ", #{obj.shop_name})".colorize(:light_blue)
      puts printer
    end
  end

  # Open URL in browser
  def open_browser(url)
		system("open '#{url}'")
	end
end