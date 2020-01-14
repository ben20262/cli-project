class Person
  attr_accessor :hash
  @@all = []

  def initialize (data)
    @hash = data
    @@all << self
  end

  def show_hash
    @hash.each_pair do |key, value|
      puts key.to_s
      puts " " + value
    end
  end


end
