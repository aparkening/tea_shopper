require 'colorize'
require_relative 'tea_shopper/'
class TeaShopper::CLI

  def call
    puts "Welcome to Tea Shopper!"
    list_main_filters
  end

  # Display initial tea filters and get input
  def list_main_filters
    input = ""
    # while input != "exit"
    #Display instructions and initial filters 
    puts "There are many teas to choose from. Select an exploration method below or type 'exit'."
    puts "- Type".colorize(:light_blue)
    puts "- Country of Origin".colorize(:light_blue)
    puts "- Flavor".colorize(:light_blue)

    # Get input, match to next step
    input = gets.strip.downcase
    case input
    when "type"
      puts "Teas by type"
    when "country"
      puts "Teas by country of origin"
    when "flavor"
      puts "Teas by flavor"
    when "exit"
      goodbye
    else 
      puts "Your input wasn't recognized, so we'll list tea by type."
    end
  end

  def goodbye
    puts "Thanks for stopping by. Happy tea drinking!"
  end

  def type_filter
    # @tea = TeaShopper::Tea
  end

  def country_filter
  
  end

  def flavor_filter
  
  end

  

  def price_filter

  end

end
