class TeaShopper::CLI
## This class presents data and gets input from user

  attr_reader :song_base_url, :song_index_url

  # Controller
  def run
    # binding.pry
    self.welcome

    # Make initial tea objects
    self.make_teas

    # Start process of selecting a tea category, subcategory, and tea
    self.guide_user
  end

  # Create tea instances
  def make_teas
    # puts "We're pulling today's tea categories from the web. This may take a few moments...\n"

    # tea_array = [{:name=>"White Dragonwell", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/white-dragonwell", :stock=>""}, {:name=>"Huang Mudan", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/huang-mudan", :stock=>""}, {:name=>"Jiukeng Dragonwell", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/jiukeng-dragonwell", :stock=>""}, {:name=>"Fragrant Leaf", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/fragrant-leaf", :stock=>""}, {:name=>"Snow Jasmine", :type=>"green", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/green-tea/products/snow-jasmine", :stock=>""}, {:name=>"Arbor Yinzhen aka Silver Needle", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/arbor-yinzhen", :stock=>""}, {:name=>"Arbor Baimudan", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/arbor-baimudan", :stock=>""}, {:name=>"Purple Rose", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/purple-rose", :stock=>""}, {:name=>"Gold Peony", :type=>"white", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/white-tea/products/gold-peony", :stock=>""}, {:name=>"Dragon Phoenix Tender Heart", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/dragon-phoenix-tender-heart", :stock=>""}, {:name=>"Four Seasons Gold", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/four-seasons-gold", :stock=>""}, {:name=>"Lishan Winter Sprout", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/lishan-winter-sprout", :stock=>""}, {:name=>"Shan Lin Xi Winter Sprout", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/slx-winter-sprout", :stock=>""}, {:name=>"Old Grove Jasmine Fragrance", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/old-grove-jasmine-fragrance", :stock=>""}, {:name=>"Old Grove Honey Orchid", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/old-grove-honey-orchid", :stock=>""}, {:name=>"Red Water Tieguanyin", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/redwater-tieguanyin", :stock=>""}, {:name=>"Buddha's Hand", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/buddha-hand", :stock=>""}, {:name=>"Nantou Dark", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/nantou-dark", :stock=>""}, {:name=>"Meizhan Yancha", :type=>"oolong", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/oolong-tea/products/meizhan-yancha", :stock=>""}, {:name=>"Gold Bud Meizhan", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/gold-bud-meizhan", :stock=>""}, {:name=>"Four Seasons Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/four-seasons-red", :stock=>""}, {:name=>"Cypress Smoked Wild Leaf", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/cypress-smoked-wild-leaf", :stock=>""}, {:name=>"Early Pick Pomelo Assam", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/early-pick-pomelo-assam", :stock=>"sold out"}, {:name=>"Old Tree Yunnan Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/otyr", :stock=>""}, {:name=>"Eighteen", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/eighteen", :stock=>""}, {:name=>"Song Red", :type=>"black/red", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/red-tea/products/song-red", :stock=>"sold out"}, {:name=>"1994 Formosa Yancha", :type=>"aged", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/aged-tea/products/aged-formosa-yancha-94", :stock=>""}, {:name=>"Aged Baozhong, 1960s", :type=>"aged", :shop_name=>"Song Tea & Ceramics", :url=>"/collections/aged-tea/products/aged-baozhong-1960s", :stock=>""}]

    tea_array = SongScraper.scrape_teas
    Tea.create_from_collection(tea_array)
  end

  # Add additional attributes to tea instances from profile pages
### scrape teas just from category  
  def add_tea_attributes
    self.spacer
    puts "We're pulling today's available teas from the web. This may take a few moments...\n"

    Tea.all.each do |tea|
      attributes = SongScraper.scrape_profile_page(tea.url)
      tea.add_tea_attributes(attributes)
    end
  end

  # Guide user through category, subcategory, and tea selection
  def guide_user
    # Main menu: get category from user
    category = self.display_main_menu

    # Display category selections, get subcategory
    subcategory = self.display_category(category)

    # Add profile attributes to tea objects
    self.add_tea_attributes  

    # Show subcategory menu of teas
    selected_tea = self.display_subcategory(subcategory, category)

    # Display tea profile
    self.display_tea(selected_tea)
  end


  # Display top menu and get input
  def display_main_menu
    self.section_title("Main Menu")

    # Display instructions and get input
    puts "Choose a method below to explore today's teas:\n(Or type 'X' to exit)"
    puts "\n"
    puts "- Type".colorize(:light_blue)
    # Song too complicated to include initially
    # puts "- Region".colorize(:light_blue)
    puts "- Shop\n".colorize(:light_blue)
    input = gets.strip.downcase


# Turn into instance method
    # If input is x or exit, say goodbye
    if input == "x" || input == "exit"
      self.goodbye
    # Else check valid input
    elsif (input != "type") && (input != "region") && (input != "shop")
      puts "Your input wasn't recognized, so we'll list tea by Type."
      input = "type"
    end

    return input
  end

  # Display next category
  # def choose_category(category)
  #   # Activate next step
  #   case category
  #     when "type"
  #       display_type
  #     when "region"
  #       puts "Teas by region"
  #     when "shop"
  #       puts "Teas by shop"
  #     when "x","exit"
  #       goodbye
  #   end
  # end

### Improve for region and shop
  # Display menu for tea type
  def display_category(category)
    # Display instructions and potential selections
    title = "Tea " + category.capitalize
    self.section_title(title)
    # puts "Tea Types\n".colorize(:green)
    puts "Choose a subcategory below to explore available teas:"
    puts "\n"

    # Display list of tea categories
    case category
      when "shop"
        Tea.shops.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
        puts "\n"
      when "region"
        Tea.regions.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
        puts "\n"
      else
        Tea.types.each { |obj| puts "- #{obj.capitalize}".colorize(:light_blue)}
        puts "\n"
    end

    # Get input, match to next step
    input = gets.strip.downcase
    
##### Improve input matching for Black/red, as well as unlisted tea types
    return input 

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
  def display_subcategory(subcategory, category)
   
    # Assign teas to display
    case category
      when "shop"
        teas = Tea.teas_by_shop(subcategory)
      when "region"
        teas = Tea.teas_by_region(subcategory)
      else
        teas = Tea.teas_by_type(subcategory)
    end
    
    # Display title and instructions
    title = subcategory.capitalize + " Tea"
    self.section_title(title)    
    self.list_instructions

    # Display ordered list of teas
    self.num_list(teas)
    puts "\n"

    # Get input, match to next step
    input = gets.strip

#### Restrict input  
    # binding.pry


    # If input is a number, check for range and find tea object or give error and repeat instructions
    # index.between?(0,8) && !position_taken?(index)

    # If input is a name, find tea object or give error and repeat instructions

    # 

    # Find tea object
    tea = Tea.find_by_name(input)

    return tea

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
  def display_tea(tea)

    # Name
    title = "#{tea.name} (#{tea.type} tea)"
    
    # self.section_title(title)
    self.spacer 
    puts title.colorize(:green)
    puts tea.url.colorize(:light_blue)
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

    puts "What now? Choose:"
    puts "- D to view this tea's (potentially long) description".colorize(:light_blue)
    puts "- M to start again at the main menu".colorize(:light_blue)
    puts "- X to exit".colorize(:light_blue)
    puts "\n"
    
    input = gets.strip.downcase
    case input
      when "d"
        # Instructions and description
        # self.section_title(title)
        desc_title = tea.name + " Description:".colorize(:green)
        self.section_title(desc_title)
        puts tea.description 
        puts "\n" + tea.instructions.colorize(:light_blue)
        puts tea.detailed_instructions
        puts "\n"

        puts "\nAnd now? Choose:"
        puts "- M to start again at the main menu".colorize(:light_blue)
        puts "- X to exit".colorize(:light_blue)
        puts "\n"

        next_input = gets.strip.downcase
        case next_input
          when "m"
            self.guide_user
          else
            self.goodbye
          end
      when "m"
        self.guide_user
      else
        self.goodbye
    end
  end


  ##### Display Helpers #####
  
  # Welcome message
  def welcome
    self.section_title("Welcome to Tea Shopper!")
  end

  # Goodbye message
  def goodbye
    puts "\nThanks for stopping by. Happy tea drinking!"
  end

  # Submenu instructions
  def list_instructions
    # puts "Choose a tea number from the list below to get more details and buying info."
    puts "Choose a tea name from the list below to get more details and buying info."
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