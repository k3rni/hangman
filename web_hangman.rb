require_relative './hangman'
require 'stringio'
require 'thread'
require 'byebug'
require 'webrick'
require 'cgi'

class QueueHangman < HangmanGame
  def initialize(wordsfile, queue)
    super(wordsfile)
    @queue = queue
  end

  def prompt
    # TODO: skąd bierzemy teraz literki?
  end

  def goto(row, col)
    "\n"
  end
  
  def clear

  end

  def output
    @io
  end

  def draw
    @io = StringIO.new
    super
  end

end

Thread.abort_on_exception = true
class GameServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    text = game.draw
    tail = "" # czego potrzebujemy?
    response.body = "<pre>#{text}</pre>" + tail
    response.status = 200
  end

  def do_POST(request, response)
    params = CGI::parse request.body
    # TODO: co robimy z params?
    # do czego jest queue?

    sleep 0.1 # daj czas wątkowi żeby się zbudził i pomielił

    if dead?
      # minimalne nadużycie semantyki metody output
      text = game.output.string
      tail = "" # TODO: czego tu potrzebujemy?
    else
      text = game.output.string
      tail = "" # TODO: czego tu potrzebujemy?
    end
    response.body = "<pre>#{text}</pre>" + tail
    response.status = 200
    restart if dead?
  end

  def form
    # TODO: formularz
  end

  def game
    @server.game_thread[:game]
  end

  def queue
    @server.game_thread[:queue]
  end

  def dead?
    !@server.game_thread.alive?
  end

  def restart
    # TODO
  end
end

class GameServer < WEBrick::HTTPServer
  def initialize(*args)
    super(*args)
    start_game
  end

  def start_game
    @game_thread = Thread.new do
      Thread.current[:queue] = queue = Queue.new
      Thread.current[:game] = game = QueueHangman.new('words.txt', queue)
      game.run
    end
    @game_thread.run
  end

  def game_thread
    @game_thread
  end
end


server = GameServer.new(Port: 4567)
server.mount '/', GameServlet
trap('INT') do
  server.shutdown
end

server.start

