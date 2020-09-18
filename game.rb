require_relative "board"
require "remedy"
require "yaml"
require "colorize"

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
                if tile.pos == @current_pos && (not @board.gameover?) && tile.tile_status != "r"
                    print "_ ".colorize(:black)
                elsif (tile.tile_status == "r" || tile.tile_status == "f") && tile.pos == @current_pos
                    print "#{tile.tile_status == "r" ? tile.tile : tile.tile_status} ".colorize(:black)
                elsif tile.tile_status == "f"
                    print "f ".colorize(:blue)  
                else
                    print tile.tile_status == "" ? "* ".colorize(:white) : "#{tile.tile} ".colorize(:red)
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
            when "\e"
               handle_menu
            when "\r"
                if @current_mode == "b"
                    @board.reveal(@current_pos)
                end

                if @current_mode == "f"
                    @board.flag(@current_pos)
                end
            end
            if @board.gameover?
                system("clear")
                puts "game over"
                handle_menu
            end
            self.print_board
        end
    end


    private
    
    def handle_menu
        begin
            puts "press S to save, L to load, Q to quit, N to start new game!"
            @user_input.loop do |key_1|
                case key_1.raw
                when "q"
                    exit
                when "s"
                    #save
                    s = @board.to_yaml
                    save_file = File.write("./saves/save_1.sav", s)
                    save_file.close
                    puts "saved"
                    return
                when "l"
                    #load
                    save_file = File.open("./saves/save_1.sav").read
                    save_board = YAML::load(save_file)
                    @board = save_board
                    return
                when "\e"
                    return
                when "n"
                    @board = Board.new
                    return 
                end
            end
        rescue => exception
            puts "There is an error!"
        end
    end

end


if __FILE__ == $PROGRAM_NAME
    game = Game.new
    game.run
end