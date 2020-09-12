require_relative "tile"


class Board
    def initialize
        @grid = Array.new(9){ Array.new(9){ "b" if rand(100) <= 20 } }
        populate_board
    end

    def [](position)
        @grid[position[0]][position[1]]
    end

    def length
        @grid.length if @grid
    end

    def reveal(pos)
        self[pos].reveal
    end

    private
    def init_tiles
        @grid.each do |row|
            row.each do |tile|
                tile.neighbors
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