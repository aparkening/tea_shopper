require 'nokogiri'
require 'open-uri'
require 'pry'
class SongScraper

################################################################################  
# 1. Scrape Song Teas by Type page for all teas: https://songtea.com/pages/tea-by-type
 # no longer https://songtea.com/pages/tea-by-character
# 2. Scrape individual tea pages, like https://songtea.com/collections/oolong-tea/products/dragon-phoenix-tender-heart
# 
################################################################################

  # Define urls
  base_url = "https://songtea.com"
  index_url = base_url + "/pages/tea-by-type"
  test_profile_url = base_url + "/collections/oolong-tea/products/dragon-phoenix-tender-heart"

  # Return array of tea attributes: name, type, and url
  def self.scrape_index(index_url)
    teas = []

    # Store html, get tea profile container
    doc = Nokogiri::HTML(open(index_url))
    tea_types = doc.css("div.product-section")

    # Get shop name
    shop_name = ""
    doc.css('meta').each { |meta| 
      shop_name = meta.attr("content") if meta.attr("property") == "og:site_name" }

    # Iterate through tea types, create tea hashes
    tea_types.each do |type|       
      type.css(".grid__item a.grid-link").each do |tea|
        # Replace "red" type with "black/red"
        tea_type = type.attr("id").split("/").last.split("-").first 
        tea_type = "black/red" if tea_type == "red"
          
        teas <<
      {
        :name => tea.css("p.grid-link__title").text,
        :type => tea_type,
        :shop_name => shop_name,
        :shop_url => tea.attr("href")
      }
      end
    end
    return teas
  end

  # puts self.scrape_index(index_url)

  # Return hash describing individual tea
  def self.scrape_profile_page(profile_url)
    profile = {}

    # Store html document
    doc = Nokogiri::HTML(open(profile_url))
    container = doc.css("div#ProductSection div.product-single")
  

    # Already have title, type, shop name, and shop url
    # Need:
    # Price
      # ("div.product-single__price span.product-single__price")
    # Price per oz (convert from grams)
    # In stock
    # profile[:flavors]
    # Year (if available)
   	# Steep instructions
		# Number of infusions (if exist)
		# Full description
		# Ingredients (if exist)

    # Store main vitals
    # vitals_container = doc.css("div.profile .vitals-container").first

    # # Set social urls if they exist
    # twitter = ""
    # linkedin = ""
    # github = ""
    # blog = ""
    # links = vitals_container.css(".social-icon-container a").each do |link| 
    #   if link.attr("href").include?("twitter.com") 
    #     profile[:twitter] = link.attr("href")
    #   elsif link.attr("href").include?("linkedin.com") 
    #     profile[:linkedin] = link.attr("href")
    #   elsif  link.attr("href").include?("github.com") 
    #     profile[:github] = link.attr("href")
    #   elsif  link.attr("href").include?("facebook.com") 
    #     facebook = link.attr("href")
    #   else 
    #     profile[:blog] = link.attr("href")
    #   end
    # end

    # # # Grab twitter url if it exists, via css attribute
    # # twitter = vitals_container.css(".social-icon-container a[href*='twitter.com']").attr("href").value if vitals_container.css(".social-icon-container a[href*='twitter.com']").first 

    # # Get profile quote and bio if they exist
    # profile[:profile_quote] = vitals_container.css(".vitals-text-container .profile-quote").text if profile[:profile_quote] = vitals_container.css(".vitals-text-container .profile-quote").first
    
    # profile[:bio] = doc.css("div.profile .details-container p").first.text if profile[:bio] = doc.css("div.profile .details-container p").first

    return profile
  end

  # puts self.scrape_profile_page(test_profile_url)
end

# Where to move index url?
