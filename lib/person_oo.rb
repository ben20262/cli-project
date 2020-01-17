require 'pry'

class Person
  attr_accessor :att_array
  @@all = []

  def initialize (hash)
    @att_array = []
    hash.each do |name, value|
      name = name.to_s.downcase.split(" ").join("_")
      @att_array << instance_variable_set(name.to_s.prepend("@"), Attribute.new(value, self))
    end
    @@all << self
  end

  def self.all
    @@all
  end

  class Attribute
    attr_reader :owner, :fact_array
    @@att_all = []

    def initialize (nest_hash, owner)
      @fact_array = []
      nest_hash.each do |name, value|
        name = name.to_s.downcase.split(" ").join("_")
        @fact_array << instance_variable_set(name.to_s.prepend("@"), Fact.new(value, self))
      end
      @owner = owner
      @@att_all << self
    end

    def self.all
      @@att_all
    end

    class Fact
      attr_reader :att_owner
      @@fact_all = []

      def initialize (ol_nestie, att_owner)
        ol_nestie.each do |name, value|
          name = name.to_s.downcase.split(" ").join("_")
          instance_variable_set(name.to_s.prepend("@"), value)
        end
        @att_owner = att_owner
        @@fact_all << self
      end

      def self.all
        @@fact_all
      end
    end
  end
end
