
class Scraper

  def self.scrape_page(page_url)
    table = Nokogiri::HTML(open("page_url")).css("table.infobox")
    table_headers = table.css("th:only-child")
    table_small_titles = table.css("th:nth-last-child(2)")
    table_content = table.css("td:nth-child(2)")
    hash = {}
    current_head = ""
    current_title = ""

    table.css("tr").each do |thing|
      thing.each do |item|
        if table_headers.include?(item)
          current = item.text
          hash[:current] = {}
        elsif table_small_titles.include?
          current_title = item.text
          hash[:current_head][:current_title] = []
        else
          hash[:current_head][:current_title] << item.text
        end
      end
    end
    hash
  end


end
