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
    if Person.all.size > 1
      count = 0
      Person.all.each do |person|
        count += 1
        name = person.name
        puts "To view information on #{name} enter #{count}."
      end
      puts "To compare all persons enter 3."
      input = gets.strip.to_i - 1
      if input < 0 || input > count
        puts "This is not a valid selection."
        info
      elsif input == count
        compare
        return
      else
        person = Person.all[input]
        name = person.name
      end
    else
      person = Person.all.first
      name = person.name
    end
    count = 0
    person_att = Person::Attribute.owner(person)
    person_att.each do |att|
      count += 1
      clean_name = att.att_name.to_s.split("_").join(" ").delete("@").capitalize
      puts "To view information on #{name}'s #{clean_name} press #{count}."
    end
    puts "To view all information on #{name} enter #{count}."
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    elsif input == count - 1
      person.show_all
      return
    else
      choice = person_att[input]
    end
    count = 0
    choice.fact_array.each do |fact|
      count += 1
      fact_clean = fact.to_s.split("_").join(" ").delete("@").capitalize
      puts "To view information on #{name}'s #{fact_clean} enter #{count}."
    end
    input = gets.strip.to_i - 1
    if input < 0 || input >= count
      puts "This is not a valid selection."
      info
    else
      fact_key = choice.fact_array[input]
      puts choice.instance_variable_get(fact_key)
    end
  end

  def compare
    mutual = Person.mutual
    if mutual.size == 0
      puts "There are no mutual tags."
    else
      mutual.each_index do |index|
        potential_key = mutual[index].split("_").join(" ").delete("@").capitalize
        puts "To compare information about #{potential_key} please enter #{index + 1}."
      end
      input = gets.strip.to_i - 1
      if mutual.size > input && input >= 0
        mutual_key = mutual[input]
        key_name = mutual_key.split("_").join(" ").delete("@").capitalize
        Person.all.each do |person|
          m_value = ""
          p_name = person.name
          person.att_array.each do |att|
            if att.fact_array.include? (mutual_key)
              m_value = att.instance_variable_get(mutual_key).join(" ")
            end
          end
          puts "#{p_name}'s #{key_name} is #{m_value}"
        end
      else
        "That is not a valid entry"
      end
    end

  end
end
