class TeaShopper::Tea 

  attr_accessor :name, :type, :country, :flavors, :shop_name, :shop_url, :price, :in_stock, :instructions, :infusions, :description, :ingredients

  @@all = []

  # List of all teas
  def self.all
    @@all
  end

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  # Create tea instance from each hash of input array
  def self.create_from_collection(tea_array)
    tea_array.each do |tea|
      tea = Tea.new({
        :name => tea[:name],
        :type => tea[:type],
        :country => tea[:country]  
      })
    end
  end

end



