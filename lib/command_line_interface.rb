require 'pry'

class CommandLineInterface

  def self.run
    puts "Please enter the url(s) that you want processed."
    puts "If entering multiple please seperate them with a comma and a space."
    input = gets.strip
    array = input.split(", ")
    array.each do |url|
      if url.include?("wikipedia.org")
        hash = Scraper.scrape_page(url)
        name = hash.keys.first.to_s
        name = Person.new(hash)
      else
        puts "#{url} was not a valid entry. Please remove or fix this entry."
        run
      end
    end
  end
end
