require_relative "tile"


class Board

    attr_reader :grid

    def initialize
        @grid = Array.new(9){ Array.new(9){ "b" if rand(100) <= 20 } }
        populate_board
    end

    def [](position)
        @grid[position[0]][position[1]]
    end

    def length
        @grid.length
    end

    def reveal(pos)
        if self[pos].tile_status == "f"
            puts "The position has been flagged, try another one!"
        else
            self[pos].reveal
        end 
    end

    def flag(pos)
        self[pos].flag
    end

    def win?
        @grid.each do |row|
            return false if not row.all? {|tile| tile.tile != "b" && tile.tile_status == "r"}
        end
        true
    end

    def lose?
        @grid.each do |row|
            return true if row.any?{|tile| tile.tile == "b" && tile.tile_status == "r"}
        end
        false
    end

    def gameover?
        self.win? || self.lose?
    end



    private
    def init_tiles
        @grid.each do |row|
            row.each do |tile|
                tile.find_neighbors
                tile.neighbors_bomb_count
            end
        end
    end 

    def populate_board
        @grid = @grid.each_with_index.map do |row, index|
            row.each_with_index.map do |tile, col|
                if tile == "b"
                    Tile.new([index, col], "b", self)
                else
                    Tile.new([index, col], " ", self)
                end 
            end
        end
        init_tiles
    end
end