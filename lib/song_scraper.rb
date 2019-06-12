class TeaShopper::SongScraper

  # Path definitions
  BASE_URL = "https://songtea.com"
  INDEX_URL = BASE_URL + "/pages/tea-by-type"
  # TEST_PROFILE_URL = BASE_URL + "/collections/oolong-tea/products/dragon-phoenix-tender-heart"

#####
  # 1. Scrape teas from Song Teas by Type page: https://songtea.com/pages/tea-by-type
  # Example return values:
  # {
  #   :name=>"Aged Baozhong, 1960s", 
  #   :type=>"aged", 
  #   :shop_name=>"Song Tea & Ceramics", 
  #   :url=>"/collections/aged-tea/products/aged-baozhong-1960s", 
  #   :stock=>""
  # }
  def self.scrape_teas
    teas = []

    # Store html, get tea profile container
    doc = Nokogiri::HTML(open(INDEX_URL))
    tea_types = doc.css("div.product-section")

    # Get shop name from meta tag
    shop_name = ""
    doc.css('meta').each { |meta| shop_name = meta.attr("content") if meta.attr("property") == "og:site_name" }

    # Iterate through tea types, then iterate through teas to create tea hash
    tea_types.each do |type|       
      type.css(".grid__item a.grid-link").each do |tea|
        
      # Replace "red" tea type with "black/red", to remove user confusion
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
        :url => BASE_URL + tea.attr("href"),
        :stock => stock
      }
      end
    end

    # Return array
    return teas
  end

#####
  # 2. Scrape individual tea pages, such as https://songtea.com/collections/oolong-tea/products/dragon-phoenix-tender-heart
  # Example return values:
  # self.scrape_profile_page(profile_url)
  # {
  #   :size=>30.0, 
  #   :price=>19.0, 
  #   :price_per_oz=>20.10618, 
  #   :flavors=>"Notes of orchid, spruce, and ghee.", 
  #   :date=>"2019", 
  #   :region=>"Taiwan", 
  ### Removed for now
  #   :detailed_instructions=>"This tea accommodates a range of brew styles...", 
  #   :instructions=>"Brew: 6 grams・150 ml・203° F・2 min", 
  ####
  #   :description=>"2019 marks our first year offering this oolong from Taiwan’s Dragon Phoenix Gorge. The cooler temperatures and mist-shrouded gardens of this region product tea with clarity, aromatics, and texture.\nDragon Phoenix Tender Heart is produced by a small farm operated by the Zhang family..."
  # }
  def self.scrape_profile_page(profile_url)
    profile = {}

    # Store html document
    doc = Nokogiri::HTML(open(profile_url))
    container = doc.css("div#ProductSection div.product-single")
    
    # Get first selection from size and price select list
    size_price = container.css("form#AddToCartForm option").first.text.strip.split(" - ")

    # Get size, remove g, convert to float
    size = size_price.first[/\d+/].to_f
    profile[:size] = size

    # Get price, grab digits and decimal, convert to float
    price = size_price.last[/\d+./].to_f
    profile[:price] = price

    # Calculate price per oz from initial price and size
    # 30g size * 0.035274 conversion * price
    price_per_oz = size * 0.035274 * price
    profile[:price_per_oz] = price_per_oz.round(2)

    # Gather all description paragraphs and separate into flavors, date, region. (And instructions and detailed instructions for future.)
    desc_array = container.css("div.product-description p").collect { |p| p.text }

    # Flavors
    profile[:flavors] = desc_array.shift
     
    # Remove second paragraph and separate into region and date
    region_year = desc_array.shift.split("・")
    profile[:date] = region_year[1]

    # Region. Grab text after "from" until the end
    profile[:region] = region_year.first[/(?<=from ).*/]
 
    # Future: when separating steep instructions, activate:
      # Steep instructions
      # Get detailed instructions first
      # profile[:detailed_instructions] = desc_array.pop
      # Get summary instructions next
      # profile[:instructions] = desc_array.pop
    
    # Full description
    profile[:description] = desc_array.join("\n\n")

    return profile
  end
end