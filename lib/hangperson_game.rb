class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = @wrong_guesses = ""
  end
  attr_accessor :word  
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def guess(letter)
    #guessing with multiple letters seems to be undefine
    if letter == nil or letter.empty? or /[^[:alpha:]]/.match? letter # nil, empty or non-alphabetic
      raise ArgumentError.new("Invalid guess")
    elsif self.guesses.downcase.include? letter.downcase or self.wrong_guesses.downcase.include? letter.downcase # the letter has been guessed before whether correct or not
      return false
    elsif self.word.downcase.include? letter.downcase # correct guess
      self.guesses += letter
    else # incorrect guess
      self.wrong_guesses += letter
    end
    return true
  end

  def word_with_guesses
    word.chars.map {|char| (self.guesses.downcase.include? char.downcase) ? char : '-'}.join
  end

  def check_win_or_lose
    if self.word_with_guesses == self.word
      return :win
    elsif self.guesses.size + self.wrong_guesses.size > 6
      return :lose
    else
      return :play
    end
  end
 
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
