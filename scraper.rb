require 'nokogiri'
require 'json'

class Scraper
  # Provide access to the scraped data
  attr_reader :collection

  # Initialize each object with a String for
  # the folder/files containing the files to be scraped.
  def initialize(folder)
    @collection = Array.new
    @folder = folder
  end

  # Iterates over each file in a folder, scrapes information from each file.
  # Logs a response after it has scrapped each file.
  # Logs number of files scraped.
  def scrape
    counter = 0
    Dir.glob(@folder) do |file|
      book = Hash.new
      doc = Nokogiri::HTML(open(file))
      book["title"] = title(doc)
      book["author"] = author(doc)
      book["isbn-10"] = isbn10(doc)
      book["isbn-13"] = isbn13(doc)
      book["weight"] = weight(doc)
      book["format"] = format(doc)
      book["language"] = language(doc)
      book["price"] = price(doc)

      puts "Scraped #{file}..."
      counter += 1
      @collection << book
    end
    puts "Scraped #{counter} books."
  end

  private

  def title(doc)
    doc.xpath("//span[contains(@id,'btAsinTitle')]/text()").text.strip
  end

  def author(doc)
    doc.css("//.buying/span/a").text
  end

  def isbn10(doc)
    doc.at('li:contains("ISBN-10")/text()').text.strip
  end

  def isbn13(doc)
    doc.at('li:contains("ISBN-13")/text()').text.strip
  end

  def weight(doc)
    doc.at('li:contains("Shipping Weight")/text()').text[0..-2].split(" ")[0].to_f
  end

  def format(doc)
    doc.xpath("//span[contains(@id,'btAsinTitle')]/span/text()").text.strip[/\[\w*?\]/][1..-2]
  end

  def language(doc)
    doc.at('li:contains("Language")/text()').text.strip
  end

  def price(doc)
    doc.css("//.bb_price").text.strip
  end
end
