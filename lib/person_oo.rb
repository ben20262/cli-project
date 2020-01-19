require 'pry'

class Person
  attr_accessor :att_array, :name
  @@all = []


  def initialize (hash)
    @att_array = []
    @name = hash.keys.first
    hash.values.first.each do |name, value|
      name = name.to_s.downcase.split(" ")
      name.delete_if {|word| word.to_i != 0}
      name = name.join("_").gsub(/[^a-z_]/, '').prepend("@")
      @att_array << instance_variable_set(name, Attribute.new(name, value, self))
    end
    @@all << self
  end

  def self.all
    @@all
  end

  def self.mutual
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
    array
  end


  class Attribute
    attr_reader :owner, :fact_array, :att_name
    @@att_all = []

    def initialize (att_name, nest_hash, owner)
      @fact_array = []
      @att_name = att_name
      nest_hash.each do |name, value|
        name = name.to_s.downcase.split(" ")
        name.delete_if {|word| word.to_i != 0}
        name = name.join("_").gsub(/[^a-z_]/, '').prepend("@")
        instance_variable_set(name, value)
        @fact_array << name
      end
      @owner = owner
      @@att_all << self
    end

    def self.all
      @@att_all
    end

    def self.owner (person)
      @@att_all.select {|att| att.owner == person}
    end
  end
end
