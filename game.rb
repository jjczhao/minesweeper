require_relative "board"
require "remedy"
include Remedy
class Game
    def initialize
        @board = Board.new
        @user_input = Interaction.new
        @current_pos = [0,0]
        @current_mode = "b"
    end

    def print_board
        system("clear")
        print "   #{(0...@board.length).to_a.join(" ")}\n"
        @board.grid.each_with_index do |row, i|
            print "#{i}| "
            row.each_with_index do |tile, j|
                if tile.pos == @current_pos && (not @board.gameover?)
                    print "_ "
                elsif tile.tile_status == "f"
                    print "f "
                else
                    print tile.tile_status == "" ? "* " : "#{tile.tile} "
                end
            end
            puts
        end
        puts "Current Mode: #{@current_mode}"
    end

    def run
        self.print_board
        @user_input.loop do |key|
            case key.raw
            when "\e[D"
                @current_pos[1] = @current_pos[1] - 1 < 0 ? @current_pos[1] : @current_pos[1] - 1 
            when "\e[C"
                @current_pos[1] = @current_pos[1] + 1 >= @board.length ? @current_pos[1] : @current_pos[1] + 1 
            when "\e[A"
                @current_pos[0] =  @current_pos[0] - 1 < 0 ? @current_pos[0] : @current_pos[0] - 1 
            when "\e[B"
                @current_pos[0] = @current_pos[0] + 1 >= @board.length ? @current_pos[0] : @current_pos[0] + 1 
            when "b"
                @current_mode = "b"
            when "f"
                @current_mode = "f"
            when "\r"
                if @current_mode == "b"
                    @board.reveal(@current_pos)
                end

                if @current_mode == "f"
                    @board.flag(@current_pos)
                end
            end
            self.print_board
            break if @board.gameover?
        end
        self.print_board
        puts "Game Over"
        true
    end
end