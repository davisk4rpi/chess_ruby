module ChessPieces
	
	class Pawn

		def initialize(position)
			@position = position
		end

		def single_square

		end

		def double_square

		end

		def en_passant

		end

		def promote

		end

		def attack

		end

	end

	class Rook

		def initialize(position)
			@position = position
		end

		def vertical(spaces)

		end

		def horizontal(spaces)

		end

	end

	class Knight

		def initialize(position)
			@position = position
		end

		def jump(arr)

		end

	end

	class Bishop

		def initialize(position)
			@position = position
		end

		def diagonal(spaces, direction)

		end

	end

	class Queen

		def initialize(position)
			@position = position
		end

	end

	class King

		def initialize(position)
			@position = position
		end

	end

end