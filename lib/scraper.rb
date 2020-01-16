require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper
  attr_accessor :hash

  def self.scrape_page(page_url)
    table = Nokogiri::HTML(open(page_url)).css("table.infobox") #here
    hash = {}
    current_head = ""

    table.css("tr").each do |item|
      header = item.css("th")
      content = item.css("td")
      if content.text == "" && header != []
        current_head = header.text.strip
        hash[:"#{current_head}"] = {}
      elsif content != [] && header != []
        new_header = header.text.strip
        new_content = content.text.strip
        if hash[:"#{current_head}"].has_key?(:"#{new_header}")
          hash[:"#{current_head}"][:"#{new_header}"] << new_content
        else
          hash[:"#{current_head}"][:"#{new_header}"] = [new_content]
        end
      end
    end
    @hash = hash
    self.cleaner
    @hash
  end

  def self.cleaner
    name = @hash.keys.first
    @hash.delete(name)
    @hash = {name => @hash}
    att_value = @hash[name]
    info = att_value[:""] if att_value.has_key? (:"")
    if att_value.has_key?(:"General Information") && info != nil
      att_value[:"General Information"] << info
      att_value.delete(:"")
    elsif info != nil
      att_value[:"General Information"] = info
      att_value.delete(:"")
    end
    att_value.each_value do |nest_value|
      nest_info = nest_value[:""].join(" ") if nest_value.has_key? (:"")
      if nest_value.has_key?(:"General") && nest_info != nil
        nest_value[:"General"] << nest_info
        nest_value[:"General"].flatten
        nest_value.delete(:"")
      elsif nest_info != nil
        nest_value[:"General"] = [nest_info]
        nest_value.delete(:"")
      end
    end
  end

end
