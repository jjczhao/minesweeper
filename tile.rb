class Tile
    attr_accessor :tile
    def initialize(pos, tile, board)
        @pos = pos
        @tile = tile
        @board = board
        @neighbors = nil
    end

    def neighbors
        possible_neighbors = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
        @neighbors = []
        possible_neighbors.each do |possible_neighbor|
            row_pos = @pos[0] + possible_neighbor[0]
            col_pos = @pos[1] + possible_neighbor[1]
            @neighbors << @board[[row_pos, col_pos]] if row_pos.between?(0, @board.length - 1) && col_pos.between?(0, @board.length - 1)
        end
    end

    def neighbors_bomb_count
        count = 0
        if @neighbors
            @neighbors.each do |tile|
                count += 1 if tile.tile == "b"
            end
        end
        self.tile = count if self.tile != "b" 
    end

    def reveal
        @tile
    end

    def inspect
        [@pos, @tile].inspect
    end


end