#!/usr/bin/env ruby

# To run this script:
# 1. run 'bundle install' on the command line to install the required gems
# 2. run the script with 'ruby bookpacker.rb'

# Load the two files that contain the code.
require_relative 'scraper'
require_relative 'shippment'

# Initialize Scraper to scrape all .html files in the folder 'data'.
amazon_books = Scraper.new('data/*.html')
# Run scraper
amazon_books.scrape

# Initialize new shippment
packages = Shippment.new
# create shippment with collected data from Scraper.
packages.create_shippment(amazon_books.collection)

# print shippment as JSON
puts packages.shippment
