require 'pry'
class Person
  attr_accessor :att_array, :name
  @@all = []


  def initialize (hash) # accepts the hash as an argument and creates variables with the keys and values
    @att_array = []
    @name = hash.keys.first
    hash.values.first.each do |name, value|
      name = name.to_s.downcase.split(" ")
      name.delete_if {|word| word.to_i != 0}
      name = name.join("_").gsub(/[^a-z_]/, '').prepend("@")
      @att_array << instance_variable_set(name, Attribute.new(name, value, self)) # passes the vaiables to the attribute sub-class for further saving and remembers the attributes saved
    end
    @@all << self
  end

  def self.all # returns all persons
    @@all
  end

  def self.mutual # returns an array of mutual attribute variable names between persons
    array = []
    count = 1
    @@all.each do |person|
      brray = []
      person.att_array.each do |att|
        brray << att.fact_array
      end
      if count == 1
        array << brray
        count += 1
      else
        brray.flatten!
        array.flatten!.keep_if {|key| brray.include?(key) || brray.include?(:"#{key}s")}
      end
    end
    array.delete("@general")
    array.uniq
  end

  def show_all # puts the entirity of a persons values to display all scraped information
    @att_array.each do |att|
      puts att.att_name.delete("@").split("_").join(" ").capitalize
      att.fact_array.each do |fact|
        fact_value = att.instance_variable_get(fact).join(" ")
        fact_key = fact.delete("@").split("_").join(" ").capitalize
        puts "  #{fact_key}"
        puts "    #{fact_value}"
      end
    end
  end


  class Attribute # sub-class for saving the lower keys and values of the hash passed to person
    attr_reader :owner, :fact_array, :att_name
    @@att_all = []

    def initialize (att_name, nest_hash, owner)
      @fact_array = []
      @att_name = att_name
      nest_hash.each do |name, value|
        name = name.to_s.downcase.split(" ")
        name.delete_if {|word| word.to_i != 0}
        name = name.join("_").gsub(/[^a-z_]/, '').prepend("@")
        instance_variable_set(name, value) # sets a variable for the lowest level of the data
        @fact_array << name # saves the names for easy use
      end
      @owner = owner
      @@att_all << self
    end

    def self.all # returns all instances of attributes
      @@att_all
    end

    def self.owner (person)
      @@att_all.select {|att| att.owner == person}
    end
  end
end
