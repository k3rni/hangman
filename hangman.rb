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
    puts "The word was: #{@correct_word}"
    puts "The End"
    puts "Final score: #{@score}"
  end

  def load_words(filename)
    @words = File.read(filename).split("\n")
  end

  def load_pictures
    fp = File.open('hangman.txt')
    num_stages = fp.readline.to_i
    stage_height = fp.readline.to_i
    @stages = {}
    @num_stages = num_stages
    (0...num_stages).each do |stage|
      rows = []
      (1..stage_height).each do |rnum|
        rows.push fp.readline
      end
      @stages[stage] = rows
    end
  end

  def choose_word
    @correct_word = @words.sample
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
    STDOUT.write @stages[@fails].join('')
  end

  def cols
    (ENV['COLUMNS'] || 80).to_i
  end

  def draw_letters
    text = "Already guessed: #{@letters.to_a.join('')}"
    STDOUT.write "#{goto(1, cols - text.size)}#{text}"
  end

  def draw_guess
    mid = (cols/2).to_i
    STDOUT.write "#{goto(3, mid)}#{@word}"
  end

  def draw_score
    text = "Score: #{@score}"
    STDOUT.write "#{goto(2, cols - text.size)}#{text}"
  end

  def prompt
    STDIN.getch
  end

  def valid?(letter)
    return false if @letters.include?(letter)
    return false unless @correct_word.include?(letter)
    true
  end

  def add(letter)
    @letters.add letter
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
    @correct_word == @word
  end

  def hang
    @fails += 1
  end
end

if $0 == __FILE__
  HangmanGame.new(ARGV[0]).run
end
