
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tea_shopper/version"

Gem::Specification.new do |spec|
  spec.name          = "tea_shopper"
  spec.version       = TeaShopper::VERSION
  spec.authors       = ["aparkening"]
  spec.email         = ["aaron.parkening@gmail.com"]

  spec.summary       = "Tea Shopper helps you shop for your next great tea."
  spec.description   = "Tea Shopper is a command line interface that scrapes tea data from the web and allows users to compare teas by name, price per ounce, and tea shop. When the user chooses a tea, it displays specific details, such as purchase URL, flavors, region, and description. Check out a short demonstration video at https://www.loom.com/share/5d3cc369d7c243d4af5e665206b39a75."
  spec.homepage      = "https://github.com/aparkening/tea_shopper"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir          = "bin"
  spec.executables     = ["tea_shopper"]
  spec.require_paths   = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
