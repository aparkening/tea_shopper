require 'open-uri'

require "bundler/setup"
Bundler.require(:default, :development)

require_relative '../lib/tea_shopper/version'
require_relative '../lib/song_scraper'
require_relative '../lib/tea'
require_relative '../lib/cli'
