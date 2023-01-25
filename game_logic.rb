# frozen_string_literal: false

require 'yaml'
require_relative 'display_text'

# Game Logic
class Game
  include Text
  attr_accessor :dictionary, :strikes, :guess, :new_word, :coded_word, :guesses, :game_saved, :solved_word, :response

  def initialize
    @dictionary = []
    File.open('google-10000-english-no-swears.txt', 'r').select do |word|
      dictionary << word if word.length >= 6 && word.length <= 12
    end
    @strikes = 0
    @game_saved = ''
    @guesses = []
    secret_word
    intro
  end
  # end initialize

  def secret_word
    @new_word = ''
    @coded_word = ''
    new_word << dictionary[rand(0..dictionary.length - 1)].chomp
    @coded_word = new_word.chars.map { |letter| letter.gsub(letter, '_') }
  end
  # end secret_word

  def guess_word
    puts
    puts "The secret_word has #{@coded_word.count} letters"
    match_text
    puts
    puts "Please enter a letter -OR- Type 'save' to save the game"
    @guess = gets.chomp.downcase
    if guess.length == 1
      guesses << guess
    elsif guess.length > 1
      too_many_characters
    end
    if @new_word.include?(guess) # if a match
      @coded_word = @new_word.chars.map do |x|
        guesses.join.include?(x) ? guesses.join.replace(x) : x.replace('_')
      end
      @solved_word = @coded_word.join
    else # if no match
      @strikes += 1 unless guess.length > 1 || guesses.count(guess) > 1
    end
    save_game if guess.include?('save')
  end
  # end guess_word

  def new_game
    coded_word
    guesses
    guess_word until strikes == 8 || solved_word == new_word || game_saved == 'saved'
    if strikes == 8
      lose_game
    elsif solved_word == new_word
      win_game
    end
    play_again if strikes == 8 || solved_word == new_word
  end

  def play_again
    puts 'Play again?'
    @response = gets.chomp.downcase
    case response
    when 'y'
      @strikes = 0
      @guesses = []
      puts secret_word.join
      new_game
    when 'n'
      puts 'Thanks for playing'
    else
      play_again
    end
  end

  def save_game
    puts 'Do you wish to save your game? [Y/N]?'
    save_response = gets.chomp.upcase
    case save_response
    when 'Y'
      Dir.mkdir('game_saves') unless Dir.exist?('game_saves')
      File.open('game_saves/hangman.yml', 'w') { |file| file.write(YAML.dump(self)) }
      game_saved << 'saved'
      puts 'Your game has been saved'
    else
      new_game
    end
  end

  def load_game
    if File.exist?('game_saves/hangman.yml')
      puts 'Do you wish to load from a save? [Y/N]'
      response = gets.chomp.upcase
      case response
      when 'Y'
        file = YAML.safe_load(File.read('game_saves/hangman.yml'), permitted_classes: [Game])
        @dictionary = file.dictionary
        @strikes = file.strikes
        @guesses = file.guesses
        @coded_word = file.coded_word
        @solved_word = file.solved_word
        @new_word = file.new_word
        puts 'Game loaded from save'
        puts "Guessed so far: #{guesses}"
        puts
        puts "Strikes: #{@strikes}"
        puts "The secret word is: #{@solved_word}"
        new_game
        @game_saved = ''
      when 'N'
        File.delete('./game_saves/hangman.yml')
        new_game
      else
        load_game
      end
    else
      new_game
    end
  end
  # end load_game
end
# end class
