class TeaShopper::Tea 

  attr_accessor :name, :type, :shop_name, :url, :stock, :size, :price, :price_per_oz, :flavors, :region, :date, :description
  
  @@all = []

  # @@all Teas reader
  def self.all
    return @@all
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
      tea = TeaShopper::Tea.new({
        :name => tea[:name],
        :type => tea[:type],
        :shop_name => tea[:shop_name],
        :url => tea[:url],
        :stock => tea[:stock]  
      })
      # Future: reinstate :region => tea[:region],
    end
  end

  # Add profile page hash attributes to Tea objects
  def add_tea_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
    return self
  end

  # Find tea object by name
  def self.find_by_name(name, array)
    array.find{|obj| obj.name.downcase == name.downcase}
  end

  # Return true if sample description doesn't exist for tea in input type
  def self.no_description?(type)
    self.teas_by_type(type).select{|obj| obj.description}.sample.nil?
  end

  # Return array of tea types
  def self.types
    self.all.collect { |tea| tea.type }.uniq.sort
  end

  # Return array of teas for type
  def self.teas_by_type(type)
    teas = self.all.collect { |obj| obj if obj.type == type }.compact
    # teas.sort_by { |tea| tea.price_per_oz}  # for sorting by price, rather than alphabetical
    teas.sort_by { |tea| tea.name}
  end
end