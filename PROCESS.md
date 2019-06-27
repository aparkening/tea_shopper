# My Gem Development Process

## 1. Plan gem, imagine interface

### First Menu
Welcome to Tea Shopper! There are many teas to choose from. Choose a way to explore from the list below:
* Type
* Country of origin
* Flavor


#### Select "Type"    
Type
We have eight main tea categories to choose from. Select from the list below to explore available teas.
* Green
* White
* Yellow
* Oolong
* Black
* Pu-er
* Rooibos
* Herbal 

##### Then select "Green"
	[General description (scraped from Virtuous Tea?)]
	[Ordering and selection text in single module/method]

	"The teas below are ordered alphabetically. 			
	Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it."
			
		
#### Select "Country"
Country of origin
Select from the tea-producing countries below to explore available teas.
* China
* Japan
* Taiwan
* [other scraped countries]
		
##### Then select "China"
	[General description?]
	[Ordering and selection text in single module/method]

	"The teas below are ordered alphabetically. 			
	Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it."
		
				
#### Select "Flavor"
Select from the flavor profiles below to explore available teas.
* Fruity
* Vegetal
* [other screaped categories]
		
##### Then select "Fruity"
	[General description?]
	[Ordering and selection text in single module/method]

	"The teas below are ordered alphabetically. 			
	Type a specific tea name to learn more about its flavors, steeping instructions, description, and where to buy it."
		

#### Specific tea view (of Tea object)
- Title (w/ tea type)
- Tea shop (w/ url)
- Price per oz (w/ stock)
- Flavors
- Steep instructions
- Number of infusions (if exist)
- Full description
- Ingredients (if exist)


## 2. Outline project structure
```
- Bin:
└── Run
└── Console 
- Config:
└── Environment
- Lib:
└── CLI interaction file
└── Scraper classes
└── Tea class
- Rspec:
└── Spec files (if exist)
- Rakefile
- Gemfile
```

Build initial structure via Bundler: https://bundler.io/v2.0/guides/creating_gem.html
`$ bundle gem tea_shopper`


## 3. Push project to Github, since Bundler creates Github repo.


## 4. Start with run file and interface file
Run: `bin/tea_shopper`
View permissions of file: `ls -lah`
Add execute permissions: `chmod +x tea_shopper` 

Start interface instance/CLI controller: `TeaShopper::CLI.new.run`
	  
Interface:`lib/cli.rb`
 1. `puts "hello world"` to verify working correctly
 2. Stub run method to welcome user and list core methods that will run
 3. Stub menu method to give user initial menu and take input


## 5. Stub remaining interface
1. Hardcode to show display details
2. Replace each section with dynamic code.

  - Create submenus
	- Create Tea class
	- Scrape first site: Song Tea & Ceramics
  - Create tea display filters for:
    - Type
    [Removed] Region
    [Removed] Flavors
    [Removed] Price
  - Display Tea object categories in Type menu
  - Display selected Tea object
    - Screencast code along
	    - Find screencast tool
	    - Record screencast
  - Refactor to split primary and secondary scrapes
  [Removed] Display Tea objects in Region menus
  [Removed] Display Tea objects in Flavors menus


## 6. Run program and tweak
  - Improve error handling and responding to edge cases
  - Refactor to remove duplicated work and separate concerns
  - Clean up tea_shopper.gemspec for production
  - Refactor for gem best practices (module names, file locations, etc.)


## 7. Update Readme and Code of Conduct
Model Readme on pattern in https://gist.github.com/PurpleBooth/109311bb0361f32d87a2.


## 8. Run Bundler release 
Move files into production mode and push to github (https://bundler.io/v2.0/guides/creating_gem.html).


## 9. Record demonstration w/ narration
https://www.loom.com/share/5d3cc369d7c243d4af5e665206b39a75


## 10. Write blog post about process


## 11. Submit Flatiron checklist


## 12. Upload gem after 1:1 code review
https://rubygems.org/gems/tea_shopper


## Stretch goals:

1. [done!] Type 'exit' any time to leave program

2. [done!] Allow user to type tea name or number from list

3. Scrape more sites:
   - Refactor Tea instantiaton for multiple scrapers
   
   #### Dobra
   1. 8 index pages: https://www.dobratea.com/
   - div#second-menu ul#menu-second-nav-header li (don't get accessories)
   - Get second page if not "showing all" results: https://www.dobratea.com/category/green/page/2/
   2. Detail pages: https://www.dobratea.com/product/assam-brahmaputra/

   #### Smith - https://www.smithtea.com/collections/all-tea?sort_by=title-ascending

   #### Perhaps in the future
   - Virtuous
   - Harney
   - Happy Lucky's
   - TeaSource
   - Tea Spot

4. Pagination of long lists

5. Write rspec tests
