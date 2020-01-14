
class Scraper

  def self.scrape_page(page_url)
    doc_sections = Nokogiri::HTML(open(page_url)).css("h2 ~ p").text
    sec_array = doc_sections.split("[edit]")
    sec_array[0].slice("Contents")
    hash = {}
    sec_array.each do |section|

    end
  end


end
