require 'chess_pieces'

module Game

	

	class GamePlay

		attr_accessor :board

		def initialize
			@board = GameBoard.new.board_hash
			introduction
		end

		def introduction
			<<~HEREDOC
			Welcome to Command Line Chess!

			I hope you know the rules already because I don't have time to explain them.
			Player 1 moves the bottom pieces and Player 2 moves from the top.

			To move a piece enter the the desired move in this format: current position, final position (a2, a4)
			To castle, type in 'long castle' or 'short castle' instead of the coordinates

			Please select on of the following options

			1 New Game
			2 Saved Game
			3 Exit

			HEREDOC
			response = gets.chomp
			until ['1','2','3'].include response
				"Pick from the options above"
				response = gets.chomp
			end
			new_game if response == '1'
			saved_game if response == '2'
			exit if response == '3'
		end

		def new_game
			system "clear" or system "cls"
			puts "Player 1 goes first,"
			new_turn
		end

	end

	class GameBoard

		include ChessPieces

		attr_accessor :board_hash

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