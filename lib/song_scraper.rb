require 'nokogiri'
require 'open-uri'
require 'pry'
class SongScraper

###################################################################  
# 1. Scrape teas from Song Teas by Type page: https://songtea.com/pages/tea-by-type
 # no longer need https://songtea.com/pages/tea-by-character

# Example return values:
# self.scrape_index(index_url)
# Array of hashes:
# {
#   :name=>"Aged Baozhong, 1960s", 
#   :type=>"aged", 
#   :shop_name=>"Song Tea & Ceramics", 
#   :shop_url=>"/collections/aged-tea/products/aged-baozhong-1960s", 
#   :stock=>""
# }


# 2. Scrape all individual tea pages, such as https://songtea.com/collections/oolong-tea/products/dragon-phoenix-tender-heart

# Example return values:
# self.scrape_profile_page(profile_url)
# {
#   :size=>30.0, 
#   :price=>19.0, 
#   :price_per_oz=>20.10618, 
#   :flavors=>"Notes of orchid, spruce, and ghee.", 
#   :date=>"2019", 
#   :region=>"Taiwan", 
#   :detailed_instructions=>"This tea accommodates a range of brew styles...", 
#   :instructions=>"Brew: 6 grams・150 ml・203° F・2 min", 
#   :description=>"2019 marks our first year offering this oolong from Taiwan’s Dragon Phoenix Gorge. The cooler temperatures and mist-shrouded gardens of this region product tea with clarity, aromatics, and texture.\nDragon Phoenix Tender Heart is produced by a small farm operated by the Zhang family..."
# }

################################################################### 

  # Define URLs
  base_url = "https://songtea.com"
  index_url = base_url + "/pages/tea-by-type"
  test_profile_url = base_url + "/collections/oolong-tea/products/dragon-phoenix-tender-heart"

  # Scrape tea overview page. Return array of tea attributes.
  def self.scrape_index(index_url)
    teas = []

    # Store html, get tea profile container
    doc = Nokogiri::HTML(open(index_url))
    tea_types = doc.css("div.product-section")

    # Get shop name from meta tag
    ## ?? Change this to use include?() ?
    shop_name = ""
    doc.css('meta').each { |meta| 
      shop_name = meta.attr("content") if meta.attr("property") == "og:site_name" }


    # Iterate through tea types, then iterate through teas to create tea hash
    tea_types.each do |type|       
      type.css(".grid__item a.grid-link").each do |tea|
        # Replace "red" type with "black/red"
        tea_type = type.attr("id").split("/").last.split("-").first 
        tea_type = "black/red" if tea_type == "red"
        
        # If tea is out of stock, store in hash
        tea.css("span.badge").text.include?("Sold Out")?stock = "sold out" : stock = ""

        # Add tea hash to array
        teas <<
      {
        :name => tea.css("p.grid-link__title").text,
        :type => tea_type,
        :shop_name => shop_name,
        :shop_url => tea.attr("href"),
        :stock => stock
      }
      end
    end

    # Return array
    return teas
  end
  # Test
  # puts self.scrape_index(index_url)

  # Scrape individual tea profile page. Return hash of individual tea attributes.
  def self.scrape_profile_page(profile_url)
    profile = {}

    # Store html document
    doc = Nokogiri::HTML(open(profile_url))
    container = doc.css("div#ProductSection div.product-single")
  
    # binding.pry
    
    # Get attributes: price, weight, flavors, region, date, description

    # Old method.
    # Price; strip space and remove $
    # price = container.css("div.product-single__prices span#ProductPrice").text.strip.delete("$")
    
    # Get first size and price from select list
    size_price = container.css("form#AddToCartForm option").first.text.strip.split(" - ")

    # Get size, remove g, convert to float
    size = size_price.first[/\d+/].to_f
    profile[:size] = size

    # Get price, grab digits and decimal, convert to float
    price = size_price.last[/\d+./].strip.to_f
    profile[:price] = price

    # Convert initial price to per oz price
    # 30g size * 0.035274 conversion * price
    price_per_oz = size * 0.035274 * price
    profile[:price_per_oz] = price_per_oz

    ## Description paragraphs
    # Gather description paragraphs
    desc_array = container.css("div.product-description p").collect { |p| p.text }

    ##Separate and remove paragraphs for flavors, date, region, instructions, and detailed_instructions.

    # Flavors
    profile[:flavors] = desc_array.shift
     
    # Remove second paragraph and break down into region and date
    region_year = desc_array.shift.split("・")
    profile[:date] = region_year[1]
    profile[:region] = region_year.first[/(?<=from ).*/]
 
    # Steep instructions
    # Get detailed instructions first
    profile[:detailed_instructions] = desc_array.pop
    # Get summary instructions next
    profile[:instructions] = desc_array.pop

    # Join summary and detail instructions with a period.
    # profile[:instructions] = [instructions, detailed_instructions].reject(&:empty?).join('. ')
    
    # Full description
    profile[:description] = desc_array.join("\n")

    return profile
  end
  # Test
  # puts self.scrape_profile_page(test_profile_url)
end