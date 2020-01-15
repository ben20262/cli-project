class Person
  attr_accessor :hash
  @@all = []

  def initialize (data)
    @hash = data
    @@all << self
  end

  def show_hash
    @hash.each_pair do |key, value|
      puts key.to_s.capitalize
      value.each_pair do |keb, balue|
        puts " " + keb.to_s.capitalize
        balue.each do |word|
          puts "  " + word
        end
      end
    end
  end

  def self.all
    @@all
  end

end
