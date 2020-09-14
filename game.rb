require_relative "board"
require "remedy"
include Remedy
class Game
    def initialize
        @board = Board.new
        @user_input = Interaction.new
        @current_pos = [0,0]
    end

    def get_input
        gets.chomp.split.map{|char| char.to_i}
    end
    
    def valid_input?(pos)
        pos[0].between?(0, @board.length - 1) && pos[1].between?(0, @board.length - 1)
    end

    def run
        until @board.gameover?
            @board.print_board
            puts "enter a position to reveal. ie. 0 0"
            begin
                pos = self.get_input
                @board[pos].reveal if valid_input?(pos)
            rescue => exception
                puts "invalid position, try again! ie. 1 0"
            end
        end
        @board.print_board
        puts "Game Over"
        true
    end
end