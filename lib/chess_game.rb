require 'chess_pieces'

module Game

	

	class GamePlay

		def initialize

		end

	end

	class GameBoard

		include ChessPieces

		attr_accessor :@board_hash

		def initialize
			construct_board
		end

		def construct_board #builds a hash that will contain all of the current positions of each piece
			letters = ("a".."h").to_a
			numbers = (1..8).to_a
			@board_hash = {}
			letters.each do | letter |
				numbers.each do | number |
					@board_hash[("#{letter}#{number}".to_sym)] = " "
				end
			end
			fill_board
			return @board_hash
		end

		def fill_board #fills the board with initial placement of all pieces
			@board_hash.each do | key, value |
				if key.to_s.match(/[2,7]/)
					pawn = Pawn.new(key)
					@board_hash[key] = pawn.marker
				elsif [:a1, :h1, :a8, :h8].include? key
					rook = Rook.new(key)
					@board_hash[key] = rook.marker
				elsif [:b1, :g1, :b8, :g8].include? key
					knight = Knight.new(key)
					@board_hash[key] = knight.marker
				elsif [:c1, :f1, :c8, :f8].include? key
					bishop = Bishop.new(key)
					@board_hash[key] = bishop.marker
				elsif [:d1, :d8,].include? key
					queen = Queen.new(key)
					@board_hash[key] = queen.marker
				elsif [:e1, :e8,].include? key
					king = King.new(key)
					@board_hash[key] = king.marker	
				end 
			end
		end

	end

end