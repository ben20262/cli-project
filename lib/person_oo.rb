require 'pry'
#hi me!

class Person
  @@all = []
  def initialize (hash)
    hash.each do |name, value|
      name = name.to_s.downcase.split(" ").join("_")
      instance_variable_set(name.to_s.prepend("@"), Attribute.new(value))
    end
    @@all << self
  end

  def person_key
    instance_variables
  end

  class Attribute
    @@att_all = []
    def initialize (nest_hash)
      nest_hash.each do |name, value|
        name = name.to_s.downcase.split(" ").join("_")
        instance_variable_set(name.to_s.prepend("@"), Fact.new(value))
      end
      @@att_all << self
    end

    def att_key
      instance_variables
    end

    class Fact
      @@fact_all = []
      def initialize (ol_nestie)
        ol_nestie.each do |name, value|
          name = name.to_s.downcase.split(" ").join("_")
          instance_variable_set(name.to_s.prepend("@"), value)
        end
        binding.pry
        @@fact_all << self
      end

      def fact_key
        instance_variables
      end
    end
  end
end
