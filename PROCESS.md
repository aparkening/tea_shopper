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


4. Start with run file and interface file
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
  - Create tea display filters for:
    - Type
    - Region
    - Flavors
    - Price
  - Display Tea objects in Type menus
  - Display selected Tea object
    - Screencast
	    - Find screencast tool
	    - Record screencast
  - Refactor to split primary and secondary scrapes
  [Removed] Display Tea objects in Region menus
  [Removed] Display Tea objects in Flavors menus


6. Run program and tweak
  - Refactor to remove duplicated work and separate concerns
  - Improve error handling and responding to edge cases
  - Clean up tea_shopper.gemspec for production
  - Refactor for gem best practices (module names, file locations, etc.)


7. Update Readme to include installation, about, etc., following pattern in https://gist.github.com/PurpleBooth/109311bb0361f32d87a2
  - Update Code_of_Conduct.md


8. Run Bundler release (https://bundler.io/v2.0/guides/creating_gem.html) to move into production mode and push to github.


9. Record demonstration w/ narration in Zoom


10. Write blog post about process


11. Submit checklist


12. Upload gem after 1:1 code review


## Stretch goals:

1. Type 'exit' any time to leave program

2. Scrape more sites:
    - Dobra
      1. 8 index pages: https://www.dobratea.com/
      div#second-menu ul#menu-second-nav-header li (don't get accessories)
      - Get second page if not "showing all" results: https://www.dobratea.com/category/green/page/2/
      2. Detail pages:
      https://www.dobratea.com/product/assam-brahmaputra/

    - Smith - https://www.smithtea.com/collections/all-tea?sort_by=title-ascending

    Perhaps in the future
    - Virtuous
    - Harney
    - Happy Lucky's
    - TeaSource
    - Tea Spot

  - Refactor Tea instantiaton for multiple scrapers

3. Pagination of long lists

3. Allow user to type first word of tea

4. Method to get from detail page back to specific list came from (Type, Country, Flavor)

5. Write rspec tests