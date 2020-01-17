class Person
  attr_accessor :hash
  @@all = []

  def initialize (data)
    @hash = data
    @@all << self
  end

  def show_hash
    name = @hash.keys.first
    puts name.to_s
    @hash[name].each_pair do |key, value|
      puts key.to_s.capitalize
      value.each_pair do |keb, balue|
        puts "  " + keb.to_s.capitalize
        balue.each do |word|
          puts "    " + word
        end
      end
    end
  end

  def self.all
    @@all
  end

  def self.mutual
    array = []
    count = 1
    @@all.each do |person|
      name = person.hash.keys.first
      brray = []
      person.hash.values.first.each_value do |value|
        brray << value.keys
      end
      if count == 1
        array << brray
        count += 1
        puts count
      else
        brray.flatten!
        array.flatten!.keep_if {|key| brray.include?(key) || brray.include?(:"#{key}(s)")}
      end
    end
    array
  end

  def single
    @hash
  end
end
