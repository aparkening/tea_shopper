# My Gem Development Process

1. Plan gem, imagine interface

- Welcome to Tea Shopper! There are many teas to choose from. Choose a way to explore from the list below:
		- Type
		- Country of origin
		- Flavor
		
-> "Type" chosen    
		Type
		We have eight main tea categories to choose from. Select from the list below to explore available teas.
		- Green
		- White
		- Yellow
		- Oolong
		- Black
		- Pu-er
		- Rooibos
		- Herbal 

    -> "Green" chosen
			[General description (scraped from Virtuous Tea?)]
      [Ordering and selection text in single module/method]

			The teas below are ordered cheapest to most expensive. 			
			Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it.
			
		
	-> "Country" chosen
  	Country of origin
		Select from the tea-producing countries below to explore available teas.
		- China
		- Japan
		- Taiwan
		- [other scraped countries]
		
			-> "China" chosen
			[General description?]
      [Ordering and selection text in single module/method]

			The teas below are ordered by type and then cheapest to most expensive. 			
			Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it.
		
				
	-> "Flavor" selected
    Select from the flavor profiles below to explore available teas.
		- Fruity
		- Vegetal
		- [other screaped categories]
		
			-> "Fruity" selected
			[General description?]
      [Ordering and selection text in single module/method]

			The teas below are ordered by type and then cheapest to most expensive. 			
			Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it.
		
	-> Specific tea view
		[Tea object]
		- Title (w/ tea type)
		- Tea shop (w/ url)
		- Price per oz (w/ in stock)
		- Flavors
		- Steep instructions
		- Number of infusions (if exist)
		- Full description
		- Ingredients (if exist)


2. Outline project structure
  Bin:
    Run
    Console 
  Lib:
    User presentation/input getter file
    Environment
    Scraper files
    Tea class
  Rspec:
    Spec files (if exist)
  Rakefile
  Gemfile
  
  Initial structure via Bundler: https://bundler.io/v2.0/guides/creating_gem.html
    `$ bundle gem tea_shopper`


3. Create github repository


4. Start with fun file and interface file
  Run: 
    bin/tea_shopper
      - view permissions of file
      `ls -lah`
      - add execute permissions
      `chmod +x tea-shopper` 

    Start interface instance/CLI controller: `TeaShopper::CLI.new.run`
	  
  Interface:
    lib/cli.rb
    a) `puts "hello world"` to verify working correctly
	  b) Create run method to welcome user and list core methods that will run
    c) Create menu method to give user initial menu and take input


5. Stub remaining interface
  a) Hardcode to show display details
  b) Replace each section with dynamic code.

  - Create submenus
	- Create Tea class
	- Scrape first site: Song
    - Screencast
	    - Find screencast tool
	    - Record screencast

  - Scrape remaining sites:
    - Harney
    - Smith
    - Dobra
    - Virtuous
    - Happy Lucky's?
    - TeaSource?
    - Tea Spot?

  - Create filters for:
    - Type
    - Country
    - Flavor
    - Price


6. Run program and tweak


7. Update Readme to include installation, about, etc., following pattern in https://gist.github.com/PurpleBooth/109311bb0361f32d87a2


8. Record demonstration w/ narration in Zoom


9. Write blog post about process


## Stretch goals:

10. Type 'exit' any time to leave program


11. Allow user to type first word of tea


12. Modify project and submit rubygems.org


13. Method to get from detail page back to specific list came from (Type, Country, Flavor)


14. Write rspec tests