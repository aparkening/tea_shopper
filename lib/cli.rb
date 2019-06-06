require 'colorize'
require './config/environment/'
class TeaShopper::CLI
## This class presents data and gets input from user

  attr_reader :song_base_url, :song_index_url

  # Path definitions
  @@song_base_url = "https://songtea.com"
  @@song_index_url = @@song_base_url + "/pages/tea-by-type"
  # test_profile_url = base_url + "/collections/oolong-tea/products/dragon-phoenix-tender-heart"


  # Controller
  def run
    self.welcome
    self.main_menu
    self.make_teas
    self.add_tea_attributes
  end

  # Create tea instances
  def make_teas

    # tea_array = [{:name=>"White Dragonwell", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/white-dragonwell", :stock=>""}, {:name=>"Huang Mudan", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/huang-mudan", :stock=>""}, {:name=>"Jiukeng Dragonwell", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/jiukeng-dragonwell", :stock=>""}, {:name=>"Fragrant Leaf", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/fragrant-leaf", :stock=>""}, {:name=>"Snow Jasmine", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/snow-jasmine", :stock=>""}, {:name=>"Arbor Yinzhen aka Silver Needle", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/arbor-yinzhen", :stock=>""}, {:name=>"Arbor Baimudan", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/arbor-baimudan", :stock=>""}, {:name=>"Purple Rose", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/purple-rose", :stock=>""}, {:name=>"Gold Peony", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/gold-peony", :stock=>""}, {:name=>"Dragon Phoenix Tender Heart", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/dragon-phoenix-tender-heart", :stock=>""}, {:name=>"Four Seasons Gold", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/four-seasons-gold", :stock=>""}, {:name=>"Lishan Winter Sprout", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/lishan-winter-sprout", :stock=>""}, {:name=>"Shan Lin Xi Winter Sprout", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/slx-winter-sprout", :stock=>""}, {:name=>"Old Grove Jasmine Fragrance", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/old-grove-jasmine-fragrance", :stock=>""}, {:name=>"Old Grove Honey Orchid", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/old-grove-honey-orchid", :stock=>""}, {:name=>"Red Water Tieguanyin", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/redwater-tieguanyin", :stock=>""}, {:name=>"Buddha's Hand", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/buddha-hand", :stock=>""}, {:name=>"Nantou Dark", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/nantou-dark", :stock=>""}, {:name=>"Meizhan Yancha", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/meizhan-yancha", :stock=>""}, {:name=>"Gold Bud Meizhan", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/gold-bud-meizhan", :stock=>""}, {:name=>"Four Seasons Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/four-seasons-red", :stock=>""}, {:name=>"Cypress Smoked Wild Leaf", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/cypress-smoked-wild-leaf", :stock=>""}, {:name=>"Early Pick Pomelo Assam", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/early-pick-pomelo-assam", :stock=>"sold out"}, {:name=>"Old Tree Yunnan Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/otyr", :stock=>""}, {:name=>"Eighteen", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/eighteen", :stock=>""}, {:name=>"Song Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/song-red", :stock=>"sold out"}, {:name=>"1994 Formosa Yancha", :type=>"aged", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/aged-tea/products/aged-formosa-yancha-94", :stock=>""}, {:name=>"Aged Baozhong, 1960s", :type=>"aged", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/aged-tea/products/aged-baozhong-1960s", :stock=>""}]

    tea_array = SongScraper.scrape_index(@@song_index_url)
    Tea.create_from_collection(tea_array)
  end

  # Add additional attributes to tea instances from profile pages
  def add_tea_attributes
    Tea.all.each do |tea|
      attributes = SongScraper.scrape_profile_page(@@song_base_url + tea.url)
      tea.add_tea_attributes(attributes)
    end
  end

  # Display top menu and get input
  def main_menu
    section_title("Main Menu")

    # Display instructions and initial filters 
    puts "Choose a method below to explore today's teas:\n(Or type 'X' to exit)"
    puts "\n"
    puts "- Type".colorize(:light_blue)
    puts "- Region".colorize(:light_blue)
    puts "- Shop\n".colorize(:light_blue)

    # Get input, match to next step
    input = ""
    input = gets.strip.downcase
    case input
    when "type"
      type_menu

    ### Replace with dynamic code
    when "region"
      puts "Teas by region"
    when "shop"
      puts "Teas by shop"
    ####

    when "x","exit"
      goodbye
    else 
      puts "Your input wasn't recognized, so we'll list tea by Type."
    end
  end

  # Display menu for tea type
  def type_menu
    # Display instructions and potential selections
    section_title("Tea Types")
    # puts "Tea Types\n".colorize(:green)
    puts "Select a type below to explore available teas:"
    puts "\n"
		# puts "- Green".colorize(:light_blue)
		# puts "- White".colorize(:light_blue)
		# puts "- Yellow".colorize(:light_blue)
		# puts "- Oolong".colorize(:light_blue)
		# puts "- Black".colorize(:light_blue)
		# puts "- Pu-er".colorize(:light_blue)
		# puts "- Rooibos".colorize(:light_blue)
    # puts "- Herbal".colorize(:light_blue)
    
    Tea.types.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}
    puts "\n"

    # Get input, match to next step
    input = gets.strip.downcase
    
    ##### Improve input matching for Black/red, as well as unlisted tea types

    self.sub_menu(input, "type")

    # case input
    # when "green"
    #   puts "Green"
    #   type_submenu(input)
    # when "white"
    #   puts "White"
    # when "yellow"
    #   puts "Yellow"
    # when "oolong"
    #   puts "Oolong"
    # when "black"
    #   puts "black"
    # when "pu-er"
    #   puts "Pu-er"
    # when "rooibos"
    #   puts "Rooibos"
    # when "herbal"
    #   puts "Herbal" 
    # when "exit"
    #   goodbye
    # else 
    #   puts "Your input wasn't recognized, so we'll show black tea."
    # end

  end

  # Display submenu with numbered list of teas
  def sub_menu(subcategory, attribute)
   
    # Assign teas to display
    case attribute
      when "shop"
        teas = Tea.teas_by_shop(subcategory)
      when "type"
        teas = Tea.teas_by_type(subcategory)
      when "region"
        teas = Tea.teas_by_region(subcategory)
    end
    
    # Display title and instructions
    title = subcategory.capitalize + " Tea"
    section_title(title)    
    self.list_instructions

    # Display ordered list of teas
    self.num_list(teas)
    puts "\n"
    
    # Get input, match to next step
    input = gets.strip

    # Display tea profile
    self.display_tea(input)

    #### Match input if name or typed number

    # until input == "exit" 
      # case input
      # when "one"
      #   # puts "One"
      #   tea_detail(input)
      # when "two"
      #   # puts "Two"
      #   tea_detail(input)
      # when "three"
      #   # puts "Three"
      #   tea_detail(input)
      # when "exit"
      #   goodbye
      # else 
      #   ### Replace with better loop
      #   puts "Your input wasn't recognized. Please select a valid tea."
      #   type_submenu(tea_type)
      # end
    # end        
    # goodbye

  end

  # Display menu for region of origin
  def region_menu
    # Display instructions and potential selections
    puts "The regions below all produce great teas. Select a region to explore available teas."

    # puts "- China".colorize(:light_blue)
    # puts "- Taiwan".colorize(:light_blue)
    # puts "- Japan".colorize(:light_blue)
    # puts "Others..."

    Tea.regions.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}

    # Get input, match to next step
    input = gets.strip.downcase
    case input
    when "green"
      sub_menu("green", "region")
    when "white"
      sub_menu("white", "region")
    when "yellow"
      # puts "Yellow"
      sub_menu("green", "region")
    when "oolong"
      puts "Oolong"
    when "black"
      puts "black"
    when "pu-er"
      puts "Pu-er"
    when "rooibos"
      puts "Rooibos"
    when "herbal"
      puts "Herbal" 
    when "exit"
      goodbye
    else 
      puts "Your input wasn't recognized, so we'll show black tea."
    end
  end

  # Display types for tea shop
  def shop_menu
    # Display instructions and potential selections
    # puts "Teas have many flavors. Select a flavor profile below to explore available teas."
    Tea.shop_name.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}
  end

  # Take in name of tea, find tea object, display all details
  def display_tea(name)
    # Find tea object
    tea = Tea.find_by_name(name)

    # Name
    title = "#{tea.name} (#{tea.type} tea)"
    url = @@song_base_url + tea.url
    # self.section_title(title)
    self.spacer 
    puts title.colorize(:green)
    puts url.colorize(:light_blue)
    puts "\n"
    
    # Out of stock warning
    puts "\nOh no! It's #{tea.stock}!\n".colorize(:red) if tea.stock != ""

    # Shop name and price
    puts "Shop:" + "     #{tea.shop_name}".colorize(:light_blue)
    puts "Price:" + "    $#{tea.price} for #{tea.size} grams (#{tea.price_per_oz} per oz.)".colorize(:light_blue)

    # Region, harvest, flavors
    puts "Region:" + "   #{tea.region}".colorize(:light_blue)
    puts "Harvest:" + "  #{tea.date}".colorize(:light_blue)
    puts "Flavors:" + "  #{tea.flavors}\n".colorize(:light_blue)

    # Show next steps
    # Press:
    # - D for tea description
    # - M for main menu
    # - X to exit 

    puts "What now? Press:"
    puts "- D to view this tea's (potentially long) description"
    puts "- M to start again at the main menu"
    puts "- X to exit"
    puts "\n"
    
    input = gets.strip.downcase
    case input
      when "d"
        # Instructions and description
        # self.section_title(title)
        desc_title = tea.name + " Description:".colorize(:green)
        section_title(desc_title)
        puts tea.description 
        puts "\n" + tea.instructions.colorize(:light_blue)
        puts tea.detailed_instructions
        puts "\n"

        puts "\nAnd now? Press:"
        puts "- M to start again at the main menu"
        puts "- X to exit"
        puts "\n"

        next_input = gets.strip.downcase
        case next_input
          when "m"
            self.main_menu
          else
            self.goodbye
          end
      when "m"
        self.main_menu
      else
        self.goodbye
    end
  end


  ##### Display Helpers #####
  
  # Welcome message
  def welcome
    section_title("Welcome to Tea Shopper!")
    puts "We're pulling the latest tea data from the web. This may take a few moments...\n"
  end

  # Goodbye message
  def goodbye
    puts "\nThanks for stopping by. Happy tea drinking!"
  end

  # Submenu instructions
  def list_instructions
    puts "Choose a tea from the alphabetical list below to get more details and buying info."
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