require_relative './hangman'
require 'socket'

class SocketHangman < HangmanGame
  def initialize(filename, io)
    @io = io
    super(filename)
  end

  def output
    @io
  end

  def prompt
    @io.readline.strip
  end
end

class NetHangman
  def initialize(wordsfile, port)
    puts port
    @socket = TCPServer.new port
    @wordsfile = wordsfile
  end

  def run
    puts "Waiting for connection, press Ctrl-C to stop"
    loop do
      conn = @socket.accept
      puts "Got connection #{conn}"
      SocketHangman.new(@wordsfile, conn).run
      conn.close
    end
  end
end

if $0 == __FILE__
  NetHangman.new(ARGV[0], ARGV[1].to_i).run
end
