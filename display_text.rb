require 'yaml'



module Text

  def intro
    puts
    puts '*****Welcome to Hangman*****'
    puts 
    puts '**********  RULES **********'
    puts '--- Can you guess the secret word?'
    puts '--- You will have 8 attempts to guess all the right letters'
    puts '--- If you guess the word, you win the game'
    puts '--- Once you have received 8 strikes, you lose the game'
    puts '--- All words are displayed in lowercase'
    puts '--- Your guess is NOT case sensitive'
    puts
    puts '--- You can save the game at any time by typing "save"'
    puts '--- GOOD LUCK!'
    puts
  end

  def too_many_characters
      puts "Only 1 letter per guess. Try again"
  end

  def match_text
    puts
    puts "Guessed so far: #{guesses}"
    puts
    puts "Strikes: #{strikes}"
    puts "The secret word is: #{coded_word.join}"
  end

  def lose_game
    puts
    puts "😵️ ☠️ 😵️ YOU DIED 😵️ ☠️ 😵️"
    puts "The secret_word was: #{new_word}" if strikes == 8
    puts
  end

  def win_game
    puts
    puts "😃️😃️😃️ YOU ESCAPED THE HANGMAN!!! 😃️😃️😃️"
    puts
  end
end
