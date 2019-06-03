require 'colorize'
require './config/environment/'
class TeaShopper::CLI

## This class presents data to user and gets input from user

  def initialize
    # Scrapers
    # @tea_factory Tea factory

  end

  # Reusable display spacer
  def spacer
    puts "------"
  end


  # Main run method
  def run
    puts "Welcome to Tea Shopper!"
    list_main_menu
  end

  # Display top menu and get input
  def list_main_menu
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
    puts "Tea Types".colorize(:green)
    puts "We have eight main tea categories to choose from. Select from the list below to explore available teas."
		puts "- Green".colorize(:light_blue)
		puts "- White".colorize(:light_blue)
		puts "- Yellow".colorize(:light_blue)
		puts "- Oolong".colorize(:light_blue)
		puts "- Black".colorize(:light_blue)
		puts "- Pu-er".colorize(:light_blue)
		puts "- Rooibos".colorize(:light_blue)
    puts "- Herbal".colorize(:light_blue)
    
    # Get input, match to next step
    input = gets.strip.downcase
    type_submenu(input)
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

  def type_submenu(tea_type)
    # Display instructions and potential selections
    spacer
    puts "#{tea_type.capitalize} Tea".colorize(:green)
		puts "The list below is sorted from cheapest to most expensive. Type a tea name to learn more about its flavors, steeping instructions, description, and where to buy it."
		puts "- Tea one".colorize(:light_blue)
		puts "- Tea two".colorize(:light_blue)
		puts "- Tea three".colorize(:light_blue)
    
    # Get input, match to next step
    input = gets.strip.downcase
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
    puts "- China".colorize(:light_blue)
    puts "- Taiwan".colorize(:light_blue)
    puts "- Japan".colorize(:light_blue)
    puts "Others..."

    # Get input, match to next step
    input = gets.strip.downcase
    case input
    when "green"
      tea_detail("green")
      # puts "Green"
    when "white"
      # puts "White"
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
  def flavor_filter
  
  end

  # Display tea list ordered by ascending price
  def price_results
    puts "teas by price: low to high"
  end

  # Take in name of tea, find tea object, display all details
  def tea_detail(tea_name)
    # Find tea object
    spacer
    puts "Tea #{tea_name.capitalize}".colorize(:green)
    puts "
		- Title (w/ tea type)
		- Tea shop (w/ url)
		- Price per oz (w/ in stock)
		- Flavors
		- Steep instructions
		- Number of infusions (if exist)
		- Full description
		- Ingredients (if exist)
    "
  end


end
