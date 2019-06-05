require 'colorize'
require './config/environment/'
class TeaShopper::CLI
## This class presents data and gets input from user

  attr_reader :song_base_url, :song_index_url

  # Path definitions
  @@song_base_url = "https://songtea.com"
  @@song_index_url = @@song_base_url + "/pages/tea-by-type"
  # test_profile_url = base_url + "/collections/oolong-tea/products/dragon-phoenix-tender-heart"


  # Main controller
  def run
    self.welcome
    self.make_teas
    self.add_tea_attributes
    self.main_menu
  end

  def welcome
    puts "Welcome to Tea Shopper!"
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
    input = ""
    # while input != "exit"
    #Display instructions and initial filters 
    puts "To narrow down your tea choices, choose an exploration method below. Or type 'exit' to leave."
    puts "- Type".colorize(:light_blue)
    puts "- Region".colorize(:light_blue)
    puts "- Flavor".colorize(:light_blue)

    # Get input, match to next step
    input = gets.strip.downcase
    case input
    when "type"
      # puts "Teas by type"
      type_menu
    when "region"
      puts "Teas by region"
    when "flavor"
      puts "Teas by flavor"
    when "exit"
      goodbye
    else 
      puts "Your input wasn't recognized, so we'll list tea by type."
    end
  end

  # Send user off with a message
  def goodbye
    puts "Thanks for stopping by. Happy tea drinking!"
  end

  # Display menu for tea type
  def type_menu
    # Display instructions and potential selections
    spacer
    puts "Tea Types\n".colorize(:green)
    puts "Select from the tea types below to explore available teas."
		# puts "- Green".colorize(:light_blue)
		# puts "- White".colorize(:light_blue)
		# puts "- Yellow".colorize(:light_blue)
		# puts "- Oolong".colorize(:light_blue)
		# puts "- Black".colorize(:light_blue)
		# puts "- Pu-er".colorize(:light_blue)
		# puts "- Rooibos".colorize(:light_blue)
    # puts "- Herbal".colorize(:light_blue)
    
    Tea.types.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}

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

  def sub_menu(subcategory, attribute)
    # Assign teas to display
    case attribute
      when "flavor"
        teas = Tea.teas_by_flavor(subcategory)
      when "type"
        teas = Tea.teas_by_type(subcategory)
      when "region"
        teas = Tea.teas_by_region(subcategory)
    end
    
    # Display title and instructions
    self.spacer
    puts "#{subcategory.capitalize}".colorize(:green)
    self.list_instructions

    # Display ordered list of teas
    self.num_list(teas)
    
    # Get input, match to next step
    input = gets.strip.downcase

    #### Match input if name or typed number

    # until input == "exit" 
      case input
      when "one"
        # puts "One"
        tea_detail(input)
      when "two"
        # puts "Two"
        tea_detail(input)
      when "three"
        # puts "Three"
        tea_detail(input)
      when "exit"
        goodbye
      else 
        ### Replace with better loop
        puts "Your input wasn't recognized. Please select a valid tea."
        type_submenu(tea_type)
      end
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

    # Display teas as ordered list
    # .each.with_index(1) { |tea, index| puts "#{index}. #{tea.name}".colorize }


    # Get input, match to next step
    input = gets.strip.downcase
    case input
    when "green"
      tea_detail("green")
    when "white"
      tea_detail("white")
    when "yellow"
      # puts "Yellow"
      tea_detail("yellow")
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

  # Display menu for flavor profiles
  def flavors_menu
    # Display instructions and potential selections
    puts "Teas have many flavors. Select a flavor profile below to explore available teas."
    Tea.flavors.each { |type| puts "- #{type.capitalize}".colorize(:light_blue)}
  end

  # No longer needed
  # Display tea list ordered by ascending price
  # def price_results
  #   puts "teas by price: low to high"
  # end

  # Take in name of tea, find tea object, display all details
  def display_tea(name)
    # Find tea object
    tea = Tea.find_by_name(name)

    self.spacer
    puts "Tea #{tea_name.capitalize}".colorize(:green)
    puts "
    - @stock if not empty
    - @name (w/ @type)
    - @shop_name 
    - @url
    - @price w/ $ (@size)
    - ? @Price per oz
    - @region & @date
    - @flavors
		- @instructions
		- @detailed_instructions
		- @description
    "

  end


  ##### Display Helpers #####
  
  def list_instructions
    puts "The list below is sorted by price, lowest to highest. Type a tea name or number to learn more about its flavors, steeping instructions, description, and where to buy it."
  end
  
  # Reusable display spacer
  def spacer
    puts "\n----------\n\n"
  end

  def num_list(array)
    array.each.with_index(1) { |obj, index| puts "#{index}. #{obj.name}".colorize(:light_blue) }
  end

end