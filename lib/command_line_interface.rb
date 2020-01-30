class CommandLineInterface

  def run # directs the program
    puts "Please enter the url(s) that you want processed."
    puts "If entering multiple please seperate them with a comma and a space."
    puts  "Enter exit at any time to exit the application."
    input = gets.strip
    array = input.split(", ")
    if input == ""
      puts "Please enter a url"
      run
    elsif input == "exit"
      return
    end
    array.each do |url|
      if url.include?("wikipedia.org")
        hash = Scraper.scrape_page(url) # scrapes the information and collects it into a hash
        name = Person.new(hash) # passes the hash to the Person class to create a new instance and document the data
      else
        puts "#{url} was not a valid entry. Please remove or fix this entry." # puts if the input is not a wikipedia url and repeats run
        run
      end
    end
    info
  end

  def info # accesses the information of the Person instances either alone or in tandem
    puts "What would you like to do?"
    if Person.all.size > 1 # skips if there is only one instance
      count = 1
      Person.all.each do |person| # for selecting which person or all persons you would like information on
        name = person.name
        puts "To view information on #{name} enter #{count}."
        count += 1
      end
      puts "To compare all persons enter #{count}."
      input = gets.strip
      index = input.to_i
      if input == "exit"
        return
      elsif index < 1 || index > count
        puts "This is not a valid selection."
        info
      elsif index == count
        var = compare
        if var == false
          return
        else
          info
        end
      else
        person = Person.all[index - 1]
        name = person.name
      end
    else
      person = Person.all.first
      name = person.name
    end
    count = 1
    return if person == nil
    person_att = person.att_array
    person_att.each do |att|
      clean_name = att.att_name.to_s.split("_").join(" ").delete("@").capitalize # cleans variable names and utilizes them as information
      puts "To view information on #{name}'s #{clean_name} press #{count}."
      count += 1
    end
    puts "To view all information on #{name} enter #{count}."
    input = gets.strip
    index = input.to_i
    if input == "exit"
      return
    elsif index < 1 || index > count
      puts "This is not a valid selection."
      info
    elsif index == count
      person.show_all
      info
    else
      choice = person_att[index - 1]
    end
    count = 0
    choice.fact_array.each do |fact|
      count += 1
      fact_clean = fact.to_s.split("_").join(" ").delete("@").capitalize
      puts "To view information on #{name}'s #{fact_clean} enter #{count}."
    end
    input = gets.strip
    index = input.to_i
    if input == "exit"
      return
    elsif index < 1 || index > count
      puts "This is not a valid selection."
      info
    else
      fact_key = choice.fact_array[index - 1]
      puts choice.instance_variable_get(fact_key)
    end
    info
  end

  def compare # uses the mutual class method of person to find mutual tags and offers the option of viewing them in tandem across person instances
    mutual = Person.mutual
    if mutual.size == 0
      puts "There are no mutual tags."
    else
      mutual.each_index do |ind|
        potential_key = mutual[ind].split("_").join(" ").delete("@").capitalize
        puts "To compare information about #{potential_key} please enter #{ind + 1}." # puts mutual tags and numbers them for easy input
      end
      input = gets.strip
      index = input.to_i
      if input == "exit"
        return false
      elsif mutual.size >= index && index > 0
        mutual_key = mutual[index - 1]
        key_name = mutual_key.split("_").join(" ").delete("@").capitalize
        Person.all.each do |person|
          m_value = ""
          p_name = person.name
          person.att_array.each do |att|
            if att.fact_array.include? (mutual_key)
              m_value = att.instance_variable_get(mutual_key).join(" ")
            end
          end
          puts "#{p_name}'s #{key_name} is #{m_value}" # puts value of mutual tag for each person instance
        end
      else
        "That is not a valid entry"
      end
    end

  end
end
