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
    count = 0
    Person.all.each do |person|
      count += 1
      name = person.name
      puts "To view information on #{name} enter #{count}."
    end
    # puts "To compare all persons enter 3."
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    # elsif input == count - 1
    #   compare
    #   return
    else
      person = Person.all[input]
      name = person.name
    end
    count = 0
    person_att = Person::Attribute.owner(person)
    person_att.each do |att|
      count += 1
      clean_name = att.att_name.to_s.split("_").join(" ").delete("@").capitalize
      puts "To view information on #{name}'s #{clean_name} press #{count}."
    end
    # puts "To view all information on #{name} please enter #{count}."
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    # elsif input == count - 1
    #   person.show_hash
    #   return
    else
      choice = person_att[input]
    end
    count = 1
    fact_collection = []
    choice.fact_array.each do |fact|
      fact.instance_variables.each do |fact_title|
        if fact_title != :@att_owner
          fact_collection << fact_title
          puts "To view information on #{name}'s #{fact_clean} press #{count}"
          count += 1
        end
      end
    end
    input = gets.strip.to_i - 1
    if input < 1 || input >= count
      puts "This is not a valid selection."
      info
    else
      key = keys[input]
      puts person_fact[key]
    end
  end

  def compare
    mutual = Person.mutual
    if mutual.size == 0
      puts "There are no mutual tags."
    else
      puts "Enter the number of the tag you like to compare."
      mutual.each_index {|index| puts "#{index + 1} #{mutual[index]}"}
      input = gets.strip.to_i
      if mutual.size > input
        mutual_key = mutual[input]
        Person.all.each do |person|
          m_value = ""
          p_name = person.hash.keys.first.to_s
          person.hash.values.first.each_value do |value|
            if value.has_key?(mutual_key)
              m_value = value[mutual_key][0]
            end
          end
          puts "#{p_name}'s #{mutual_key} is #{m_value}"
        end
      else
        "That is not a valid entry"
      end
    end

  end
end
