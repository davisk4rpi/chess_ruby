module ChessPieces
	
	class Pawn

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@initial = position
			@marker = marker_color
			pick_direction
		end

		def pick_direction
			if @initial[1] == '2'
				@direction = 1
			elsif @initial[1] == '7'
				@direction = -1
			end			
		end

		def possible_maneuver?(coordinate, board)
			return true if (single_square?(coordinate, board) || 
											double_square?(coordinate, board) ||
											en_passant?(coordinate, board) ||
											#promote?(coordinate, board) ||
											attack?(coordinate, board)) 
			return false
		end

		def marker_color
			return "\u2659" if @position.to_s.include? "2" #white
			return "\u265F" if @position.to_s.include? "7" #black
		end

		def single_square?(coordinate, board)
			if board[coordinate.to_sym].nil?
				return true if ((@position[0] == coordinate[0]) && 
											 (@position[1].to_i + (1 * @direction)  == coordinate[1].to_i))
			end
			return false
		end

		def double_square?(coordinate, board)
			path = coordinate[0] + ((coordinate[1].to_i + @position[1].to_i)/2).to_s
			if (board[coordinate.to_sym].nil? && board[path.to_sym].nil?)
				if @position == @initial
					return true if ((@position[0] == coordinate[0]) && 
												 (@position[1].to_i + (2 * @direction)  == coordinate[1].to_i))
				end
			end
			return false
		end

		def en_passant?(coordinate, board)
			return false if board[:last_moved].nil?
			if (board[coordinate.to_sym].nil? && 
				 board[:last_moved][0].is_a?(Pawn) &&
				 board[:last_moved][1] == 'double_square' &&
				 coordinate[0] == board[:last_moved][0].position[0] &&
				 (coordinate[1].succ == board[:last_moved][0].position[1] || coordinate[1] == board[:last_moved][0].position[1].succ))
				return true if (((@position[0] == coordinate[0].succ) || (@position[0].succ == coordinate[0])) && 
											 (@position[1].to_i + (1 * @direction)  == coordinate[1].to_i))
			end
			return false
		end

		def promote?(coordinate, board)

		end

		def attack?(coordinate, board)
			unless board[coordinate.to_sym].nil?
				return true if (((@position[0] == coordinate[0].succ) || (@position[0].succ == coordinate[0])) && 
											 (@position[1].to_i + (1 * @direction)  == coordinate[1].to_i))
			end
			return false
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

		def possible_maneuver?(coordinate, board)
			return true if (vertical?(coordinate, board) || 
											horizontal?(coordinate, board))
			return false
		end

		def marker_color(position)
			return "\u2656" if position.to_s.include? "1" #white
			return "\u265C" if position.to_s.include? "8" #black
		end

		def vertical?(coordinate, board)
			if coordinate[0] == @position[0]
				array = (position[1]...coordinate[1]).to_a if position[1] < coordinate[1]
				array2 = (coordinate[1]..position[1]).to_a.reverse
				array = array2[0...-1] if position[1] > coordinate[1]
				array.each do | space |
					key = (coordinate[0] + space).to_sym
					unless board[key] == self
						return false unless board[key].nil?
					end
				end
			else
				return false
			end
			return true
		end

		def horizontal?(coordinate, board)

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