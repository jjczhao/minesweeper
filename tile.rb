class Tile
    attr_accessor :tile, :tile_status
    def initialize(pos, tile, board)
        @pos = pos
        @tile = tile
        @board = board
        @neighbors = nil
        @tile_status = ""
    end

    def neighbors
        possible_neighbors = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
        neighbor_tiles = []
        possible_neighbors.each do |possible_neighbor|
            row_pos = @pos[0] + possible_neighbor[0]
            col_pos = @pos[1] + possible_neighbor[1]
            neighbor_tiles << @board[[row_pos, col_pos]] if row_pos.between?(0, @board.length - 1) && col_pos.between?(0, @board.length - 1)
        end
        @neighbors = neighbor_tiles
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
        if self.tile != 0
            self.tile_status = "r"
            return 
        end
        self.neighbors.each do |neighbor|
            neighbor.reveal
        end
    end

    def inspect
        [@pos, @tile, @tile_status].inspect
    end


end