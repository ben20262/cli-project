
class Scraper

  def self.scrape_page(page_url)
    doc_sections = Nokogiri::HTML(open(page_url)).css("h2").text
  end


end
