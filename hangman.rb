require 'io/console'
require 'set'

class HangmanGame
  def initialize(filename)
    @score = 0
    load_words(filename)
    load_pictures
  end

  def run
    running = true
    while running
      choose_word
      reset_hangman
      while alive? && !guessed?
        clear
        draw
        letter = prompt
        if letter == '!'
          running = false
          break
        end
        # TODO: czy to wyczerpuje wszystkie możliwości przetwarzania litery?
        if valid? letter
          add letter
          update letter
        else
          add letter
          hang
        end
        if guessed?
          score
        end
      end
      unless alive?
        break
      end
    end
    clear
    puts "The End"
    puts "Final score: #{@score}"
  end

  def load_words(filename)
    @words = ['wisielec'] # TODO
  end

  def load_pictures
    fp = File.open('hangman.txt')
    # TODO
    # popatrz w hangman.txt
    # pierwszy wiersz to ilość wariantów
    # drugi to ilość wierszy w każdym wariancie
  end

  def choose_word
    # TODO
    # wybierz jedno losowe słowo ze słownika
    # BONUS: wybierz takie które jeszcze nie zostało w tej sesji użyte
  end

  def reset_hangman
    @fails = 0
    @letters = Set.new
    @word = '_' * @correct_word.size
  end

  def alive?
    @fails < @num_stages - 1
  end

  def clear
    STDOUT.write "\e[2J\e[1;1H"
  end
  
  def goto(row, col)
    "\e[#{row};#{col}H"
  end

  def draw
    draw_gallows
    draw_letters
    draw_guess
    draw_score
  end

  def draw_gallows
    # TODO
    # narysuj szubienicę według bieżącego stanu gry
  end

  def cols
    (ENV['COLUMNS'] || 80).to_i
  end

  def draw_letters
    # TODO
    # wypisz użyte już litery po prawej stronie w wierszu 1
  end

  def draw_guess
    mid = (cols/2).to_i
    # TODO
    # wypisz obecny stan zgadywania na środku wiersza 2
  end

  def draw_score
    text = "Score: #{@score}"
    # TODO
    # wypisz punktację po prawej stronie wiersza 2
  end

  def prompt
    # TODO
    # pobierz jeden znak z konsoli
  end

  def valid?(letter)
    # TODO
    # kiedy litera jest błędna?
    true
  end

  def add(letter)
    # TODO
  end

  def update(letter)
    start = -1
    while j = @correct_word.index(letter, start + 1)
      @word[j] = letter
      start = j
    end
  end

  def score
    @score += 1
  end

  def guessed?
    # TODO: kiedy zgadliśmy słowo?
  end

  def hang
    @fails += 1
  end
end

if $0 == __FILE__
  HangmanGame.new(ARGV[0]).run
end
