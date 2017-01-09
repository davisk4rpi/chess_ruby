module ChessPieces
	
	class Pawn

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@initial = position
			@marker = marker_color
		end

		def possible_maneuver?(coordinate, board)
			return true if (single_square?(coordinate, board) || 
											double_square?(coordinate, board) ||
											en_passant?(coordinate, board) ||
											promote?(coordinate, board) ||
											attack?(coordinate, board)) 
			return false
		end

		def marker_color
			return "\u2659" if @position.to_s.include? "2" #white
			return "\u265F" if @position.to_s.include? "7" #black
		end

		def single_square?(coordinate, board)
			if board[coordinate] = nil
				return true if (@position[0] == coordinate[0]) && (@position[1].to_i + 1  == coordinate[1].to_i)
			end
			return false
		end

		def double_square?(coordinate, board)
			if board[coordinate] = nil
				if @position == @initial
					return true if (@position[0] == coordinate[0]) && (@position[1].to_i + 2  == coordinate[1].to_i)
				end
			end
			return false
		end

		def en_passant?(coordinate, board)

		end

		def promote?(coordinate, board)

		end

		def attack?(coordinate, board)

		end

	end

	class Rook

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@initial = position
			@marker = marker_color(position)
		end

		def marker_color(position)
			return "\u2656" if position.to_s.include? "1" #white
			return "\u265C" if position.to_s.include? "8" #black
		end

		def vertical(spaces)

		end

		def horizontal(spaces)

		end

	end

	class Knight

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def marker_color(position)
			return "\u2658" if position.to_s.include? "1" #white
			return "\u265E" if position.to_s.include? "8" #black
		end

		def jump(arr)

		end

	end

	class Bishop

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def marker_color(position)
			return "\u2657" if position.to_s.include? "1" #white
			return "\u265D" if position.to_s.include? "8" #black
		end

		def diagonal(spaces, direction)

		end

	end

	class Queen

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def marker_color(position)
			return "\u2655" if position.to_s.include? "1" #white
			return "\u265B" if position.to_s.include? "8" #black
		end

		def vertical(spaces)

		end

		def horizontal(spaces)

		end

		def diagonal(spaces, direction)

		end

	end

	class King

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@initial = position
			@marker = marker_color(position)
		end

		def marker_color(position)
			return "\u2654" if position.to_s.include? "1" #white
			return "\u265A" if position.to_s.include? "8" #black
		end

		def one_space(direction)

		end

	end

end