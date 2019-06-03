class TeaShopper::Tea 

  attr_accessor :name, :type, :country, :flavors, :shop_name, :shop_url, :price, :in_stock, :instructions, :infusions, :description, :ingredients

  @@all = []

  # List of all teas
  def self.all
    @@all
  end

  def initialize

  end


end



