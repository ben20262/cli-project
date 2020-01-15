require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_page(page_url)
    table = Nokogiri::HTML(open(page_url)).css("table.infobox")
    # table_headers = table.css("th:only-child").text
    # table_small_titles = table.css("th:nth-last-child(2)").text
    # table_content = table.css("td:nth-child(2)").text
    hash = {}
    current_head = ""

    table.css("tr").each do |item|
      header = item.css("th")
      content = item.css("td")
      binding.pry

      if content != [] && header == []
      elsif content == [] && header != []
        current_head = header.text
        hash[:current_head] = {}
      elsif content != [] && header != []
        header = header.text
        content = content.text
        hash[:current_head][:header] = content
      end
    end
    hash
  end

  class PersonError < StandardError
    @count = 0

    def message
      @count +=1
      puts "#{@count} items unable to be parsed!"
    end
  end
end
