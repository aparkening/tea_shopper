
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tea_shopper/version"

Gem::Specification.new do |spec|
  spec.name          = "tea_shopper"
  spec.version       = TeaShopper::VERSION
  spec.authors       = ["aparkening"]
  spec.email         = ["aaron.parkening@gmail.com"]

  spec.summary       = "Tea Shopper helps you shop for your next great tea."
  spec.description   = " Tea Shopper is a command line interface that scrapes tea data from the web and allows users to compare teas by name, price per ounce, and tea shop. When the user chooses a tea, it displays specific details, such as purchase URL, flavors, region, and description. [Check out a short demonstration video.](https://www.loom.com/share/5d3cc369d7c243d4af5e665206b39a75)
  "
  spec.homepage      = "https://github.com/aparkening/tea_shopper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "https://github.com/aparkening/tea_shopper"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "https://github.com/aparkening/tea_shopper"
  #   spec.metadata["changelog_uri"] = "https://github.com/aparkening/tea_shopper/blob/master/lib/tea_shopper/version.rb"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = "exe"
  spec.bindir         = "bin"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables = ["tea_shopper"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "colorize"
  spec.add_dependency "nokogiri", "~> 1.6"
end
