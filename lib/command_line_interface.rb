require 'pry'

class CommandLineInterface

  def run
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
    info
  end

  def info
    puts "What would you like to do?"
    count = 1
    people = Person.all
    people.each do |person|
      name = person.hash.keys[0].to_s
      puts "To view information on #{name} enter #{count}."
      count += 1
    end
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    else
      person = people[input]
      person_hash = person.hash
      name = person_hash.keys.first
    end
    count = 1
    person_hash[name].each_key do |key|
      puts "To view information on #{name}'s #{key} press #{count}."
      count += 1
    end
    puts "To view all information on #{name} please enter #{count}."
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    elsif input == count - 1
      person.show_hash
      return
    else
      key = person_hash[name].keys[input]
      person_fact = person_hash[name][key]
    end
    count = 1
    binding.pry
    keys = person_fact.keys
    keys.each do |key|
      puts "To view information on #{name}'s #{key} press #{count}"
      count += 1
    end
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    else
      key = keys[input]
      puts person_fact[key]
    end
  end

end
