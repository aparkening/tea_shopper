class Tea 

  attr_accessor :name, :type, :shop_name, :url, :stock, :size, :price, :price_per_oz, :flavors, :region, :date, :detailed_instructions, :instructions, :description
  
  @@all = []

  # @@all Teas reader
  def self.all
    @@all
  end

  # Reset the @@all array
  def self.reset_all
    self.all.clear
  end

  # Initialize multiple attributes with send
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  # Create tea instances from hashes inside tea_array
  def self.create_from_collection(tea_array)
    tea_array.each do |tea|
      tea = Tea.new({
        :name => tea[:name],
        :type => tea[:type],
        :region => tea[:region],
        :shop_name => tea[:shop_name],
        :url => tea[:url],
        :stock => tea[:stock]  
      })
    end
  end

  # Add profile page hash attributes
  def add_tea_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
    self
  end

  # Find tea object by name
  def self.find_by_name(name, array)
    self.all.find{|obj| obj.name == name}
  end

  # Return true if sample description doesn't exist for tea in input type
  def self.no_description?(type)
    self.teas_by_type(type).select{|obj| obj.description}.sample.nil?
  end

  # Return array of tea types
  def self.types
    self.all.collect { |tea| tea.type }.uniq.sort
  end

  # Return array of tea regions
  def self.regions
    self.all.collect { |tea| tea.region }.uniq.sort
  end

  # Return array of tea shops
  def self.shops
    self.all.collect { |tea| tea.shop_name }.uniq.sort
  end

  # Return array of teas for type
  def self.teas_by_type(type)
    teas = self.all.collect { |obj| obj if obj.type == type }.compact
    # teas.sort_by { |tea| tea.price_per_oz}
    teas.sort_by { |tea| tea.name}
  end

  # Return array of teas for region
  def self.teas_by_region(region)
    # If default selection of china or taiwan, run twice: once for china, and once for taiwan. Then join together.
    if region == "China or Taiwan"
      teas = self.all.collect{ |obj| obj if obj.region.downcase.include?("china")}.compact
      teas << self.all.collect{ |obj| obj if obj.region.downcase.include?("taiwan")}.compact
    else
      teas = self.all.collect{ |obj| obj if obj.region.downcase == region}.compact
    end
      # teas.sort_by { |tea| tea.price_per_oz}
    teas.sort_by { |tea| tea.name}
  end

  # Return array of teas for shops
  def self.teas_by_shop(shop)
    teas = self.all.collect{ |obj| obj if obj.shop_name == shop}.compact
    # teas.sort_by { |tea| tea.price_per_oz}
    teas.sort_by { |tea| tea.name}
  end

  # Return array sorted by price_per_oz
  # def price_sort(array)
  #   array.sort_by { |tea| tea.price_per_oz}
  # end

end