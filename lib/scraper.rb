require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_page(page_url)
    table = Nokogiri::HTML(open(page_url)).css("table.infobox")
    hash = {}
    current_head = ""

    table.css("tr").each do |item|
      header = item.css("th")
      content = item.css("td")

      if content.text == "" && header != []
        current_head = header.text
        hash[:"#{current_head}"] = {}
      elsif content != [] && header != []
        new_header = header.text
        new_content = content.text
        hash[:"#{current_head}"][:"#{new_header}"] = new_content
      end
    end
    hash
  end
end
