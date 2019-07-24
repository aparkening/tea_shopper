require 'pry'
RSpec.describe TeaShopper do
  before do
    tea_array = TeaShopper::SongScraper.new.scrape_teas
    TeaShopper::Tea.create_from_collection(tea_array)
  end 

  it "has a version number" do
    expect(TeaShopper::VERSION).not_to be nil
  end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  it "has teas" do 
    expect(TeaShopper::Tea.all).not_to eq("")
  end 

end
