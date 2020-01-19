require 'open-uri'
require 'nokogiri'


class Scraper
  attr_accessor :hash

  def self.scrape_page(page_url) # accpets the url and returns a hash of the organized information
    table = Nokogiri::HTML(open(page_url)).css("table.infobox") # accesses the url and takes just the information of the table
    hash = {}
    current_head = ""  # tracks the current header

    table.css("tr").each do |item|
      header = item.css("th")
      content = item.css("td")
      if content.text == "" && header != [] # if there is a th element but no td in a tr it is a header
        current_head = header.text.strip # the header is saved for future use and a hash is created as its value
        hash[:"#{current_head}"] = {}
      elsif content != [] && header != [] # if there is both a th and a td they are sub-header and content to be saved
        new_header = header.text.strip
        new_content = content.text.strip
        if hash[:"#{current_head}"].has_key?(:"#{new_header}") # ensures that the sub-header is already a key and saves it if otherwise
          hash[:"#{current_head}"][:"#{new_header}"] << new_content
        else
          hash[:"#{current_head}"][:"#{new_header}"] = [new_content]
        end
      end
    end
    @hash = hash
    self.cleaner #cleans the hash
    @hash
  end

  def self.cleaner
    name = @hash.keys.first
    @hash.delete(name)
    @hash = {name => @hash} # takes the name of the person and sets it as the overarching key for easy indentification
    att_value = @hash[name]
    info = att_value[:""] if att_value.has_key? (:"")
    if att_value.has_key?(:"General Information") && info != nil # changes the empty keys to general information and consolidates them
      att_value[:"General Information"] << info
      att_value.delete(:"")
    elsif info != nil
      att_value[:"General Information"] = info
      att_value.delete(:"")
    end
    att_value.delete_if {|key, value| value == {}} # deletes valueless keys
    att_value.each_value do |nest_value|
      nest_info = nest_value[:""].join(" ") if nest_value.has_key? (:"") # changes empty nested keys to general and consolidates them
      if nest_value.has_key?(:"General") && nest_info != nil
        nest_value[:"General"] << nest_info
        nest_value[:"General"].flatten
        nest_value.delete(:"")
      elsif nest_info != nil
        nest_value[:"General"] = [nest_info]
        nest_value.delete(:"")
      end
      nest_value.values.flatten.each do |item| # strips carriage returns
        item.gsub!(/\n/, " ")
      end
    end
    att_value.each_key do |key| # deletes duplicated data caused by sub tables data structure
      att_value.each_value do |value|
        value.delete(key)
      end
    end
  end

end
