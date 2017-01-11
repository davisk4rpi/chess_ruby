module ChessPieces
	
	class Queen

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def possible_maneuver?(coordinate, board)
			return true if (vertical?(coordinate, board) || 
										 horizontal?(coordinate, board) ||
										 diagonal?(coordinate, board))
			return false
		end

		def marker_color(position)
			return "\u2655" if position.to_s.include? "1" #white
			return "\u265B" if position.to_s.include? "8" #black
		end

		def diagonal?(coordinate, board)
			letters = ("a".."h").to_a
			numbers = ("1".."8").to_a
			i1 = letters.index(@position[0])
			i2 = letters.index(coordinate[0])
			i = i2 - i1
			i > 0 ? (i_step = 1) : (i_step = -1)
			j1 = numbers.index(@position[1])
			j2 = numbers.index(coordinate[1])
			j = j2 - j1
			j > 0 ? (j_step = 1) : (j_step = -1)
			multiplier = 1
			return false unless i.abs == j.abs
			step = 1
			(i.abs - 1).times do 
				key =(letters[i1 + i_step * multiplier] + numbers[j1 + j_step * multiplier]).to_sym
				return false unless (board[key] == nil)
				multiplier += 1
			end
			return true
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
			if coordinate[1] == @position[1]
				array = (position[0]...coordinate[0]).to_a if position[0] < coordinate[0]
				array2 = (coordinate[0]..position[0]).to_a.reverse
				array = array2[0...-1] if position[0] > coordinate[0]
				array.each do | space |
					key = (space + coordinate[1]).to_sym
					unless board[key] == self
						return false unless board[key].nil?
					end
				end
			else
				return false
			end
			return true
		end

	end

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

	class Rook < Queen

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
	end

	class Knight

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def possible_maneuver?(coordinate, board)
			return true if jump?(coordinate)
			return false
		end

		def marker_color(position)
			return "\u2658" if position.to_s.include? "1" #white
			return "\u265E" if position.to_s.include? "8" #black
		end

		def jump?(coordinate)
			letters = ("a".."h").to_a
			numbers = ("1".."8").to_a
			i = letters.index(@position[0])
			j = numbers.index(@position[1])
			possible_moves = []
			possible_moves << (letters[i-1] + numbers[j-2]) unless (i == 0 || j <= 1)
			possible_moves << (letters[i-1] + numbers[j+2]) unless (i == 0 || j >= 6)
			possible_moves << (letters[i+1] + numbers[j-2]) unless (i == 7 || j <= 1)
			possible_moves << (letters[i+1] + numbers[j+2]) unless (i == 7 || j >= 6)
			possible_moves << (letters[i-2] + numbers[j-1]) unless (i <= 1 || j == 0)
			possible_moves << (letters[i-2] + numbers[j+1]) unless (i <= 1 || j == 7)
			possible_moves << (letters[i+2] + numbers[j-1]) unless (i >= 6 || j == 0)
			possible_moves << (letters[i+2] + numbers[j+1]) unless (i >= 6 || j == 7)
			return true if possible_moves.include? coordinate.to_s
			return false
		end

	end

	class Bishop < Queen

		attr_accessor :position
		attr_reader :marker

		def initialize(position)
			@position = position
			@marker = marker_color(position)
		end

		def possible_maneuver?(coordinate, board)
			return true if diagonal?(coordinate, board)
			return false
		end

		def marker_color(position)
			return "\u2657" if position.to_s.include? "1" #white
			return "\u265D" if position.to_s.include? "8" #black
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

		def possible_maneuver?(coordinate, board)
			return true if single_square?(coordinate, board)
			return false
		end

		def marker_color(position)
			return "\u2654" if position.to_s.include? "1" #white
			return "\u265A" if position.to_s.include? "8" #black
		end

		def single_square?(coordinate, board)
			letters = ("a".."h").to_a
			numbers = ("1".."8").to_a
			i = letters.index(@position[0])
			j = numbers.index(@position[1])
			possible_moves = []
			possible_moves << (letters[i-1] + numbers[j]) unless (i == 0)
			possible_moves << (letters[i-1] + numbers[j+1]) unless (i == 0 || j >= 7)
			possible_moves << (letters[i-1] + numbers[j-1]) unless (i == 0 || j <= 0)
			possible_moves << (letters[i] + numbers[j+1]) unless (j == 7)
			possible_moves << (letters[i] + numbers[j-1]) unless (j == 0)
			possible_moves << (letters[i+1] + numbers[j]) unless (i == 7)
			possible_moves << (letters[i+1] + numbers[j+1]) unless (i == 7 || j == 7)
			possible_moves << (letters[i+1] + numbers[j-1]) unless (i == 7 || j == 0)
			if possible_moves.include? coordinate.to_s
				return true
			end
			return false
		end

	end

end