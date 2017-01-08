require 'chess_pieces'

module Game

	

	class GamePlay

		attr_accessor :board

		def initialize
			@board = GameBoard.new.board_hash
			#introduction
		end

		def introduction
			puts <<~HEREDOC
			Welcome to Command Line Chess!

			I hope you know the rules already because I don't have time to explain them.
			Player 1 moves the bottom pieces and Player 2 moves from the top.

			To move a piece enter the the desired move in this format: current position final position (a2 a4)
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
			clear_screen
			puts "Player 1 goes first,"
			new_turn
		end

		def new_turn
			puts "Enter your move with the following format: Starting Coordinate Ending Coordinates... ex: 'a2 a4'\n"
			"To castle, type in 'long castle' or 'short castle' instead of the coordinates"
			board_view
			response = gets.chomp
			unless valid_move?(response)
				puts 'Pick a valid_move with the correct format'
				return new_turn
			end
			coordinates = response.split(' ')
			move_piece(coordinates)
			clear_screen
			if check?
				puts "Check!"
			elsif check? == "checkmate"
				checkmate
			end
			new_turn
		end

		def board_view
			#design for easy understanding/view over minimalist algorithm
			x = {}
			@board.each do | key, gamepiece |
				x[key] = gamepiece.marker unless gamepiece.nil?
				x[key] = " " if gamepiece.nil?
			end

			row9 = "\n     a    b    c    d    e    f    g    h\n" +
						 "	                                       \n"
			row8 = "  |     ooooo     ooooo     ooooo     ooooo|\n" +
						 "8 |  #{x[:a8]}  oo#{x[:b8]}oo  #{x[:c8]}  oo#{x[:d8]}oo  #{x[:e8]}  oo#{x[:f8]}oo  #{x[:g8]}  oo#{x[:h8]}oo| 8\n" +
						 "  |     ooooo     ooooo     ooooo     ooooo|\n" 
			row7 = "  |ooooo     ooooo     ooooo     ooooo     |\n" +
						 "7 |oo#{x[:a7]}oo  #{x[:b7]}  oo#{x[:c7]}oo  #{x[:d7]}  oo#{x[:e7]}oo  #{x[:f7]}  oo#{x[:g7]}oo  #{x[:h7]}  | 7\n" +
						 "  |ooooo     ooooo     ooooo     ooooo     |\n" 
			row6 = "  |     ooooo     ooooo     ooooo     ooooo|\n" +
						 "6 |  #{x[:a6]}  oo#{x[:b6]}oo  #{x[:c6]}  oo#{x[:d6]}oo  #{x[:e6]}  oo#{x[:f6]}oo  #{x[:g6]}  oo#{x[:h6]}oo| 6\n" +
						 "  |     ooooo     ooooo     ooooo     ooooo|\n" 
			row5 = "  |ooooo     ooooo     ooooo     ooooo     |\n" +
						 "5 |oo#{x[:a5]}oo  #{x[:b5]}  oo#{x[:c5]}oo  #{x[:d5]}  oo#{x[:e5]}oo  #{x[:f5]}  oo#{x[:g5]}oo  #{x[:h5]}  | 5\n" +
						 "  |ooooo     ooooo     ooooo     ooooo     |\n" 
			row4 = "  |     ooooo     ooooo     ooooo     ooooo|\n" +
						 "4 |  #{x[:a4]}  oo#{x[:b4]}oo  #{x[:c4]}  oo#{x[:d4]}oo  #{x[:e4]}  oo#{x[:f4]}oo  #{x[:g4]}  oo#{x[:h4]}oo| 4\n" +
						 "  |     ooooo     ooooo     ooooo     ooooo|\n" 
			row3 = "  |ooooo     ooooo     ooooo     ooooo     |\n" +
						 "3 |oo#{x[:a3]}oo  #{x[:b3]}  oo#{x[:c3]}oo  #{x[:d3]}  oo#{x[:e3]}oo  #{x[:f3]}  oo#{x[:g3]}oo  #{x[:h3]}  | 3\n" +
						 "  |ooooo     ooooo     ooooo     ooooo     |\n" 
			row2 = "  |     ooooo     ooooo     ooooo     ooooo|\n" +
						 "2 |  #{x[:a2]}  oo#{x[:b2]}oo  #{x[:c2]}  oo#{x[:d2]}oo  #{x[:e2]}  oo#{x[:f2]}oo  #{x[:g2]}  oo#{x[:h2]}oo| 2\n" +
						 "  |     ooooo     ooooo     ooooo     ooooo|\n" 
			row1 = "  |ooooo     ooooo     ooooo     ooooo     |\n" +
						 "1 |oo#{x[:a1]}oo  #{x[:b1]}  oo#{x[:c1]}oo  #{x[:d1]}  oo#{x[:e1]}oo  #{x[:f1]}  oo#{x[:g1]}oo  #{x[:h1]}  | 1\n" +
						 "  |ooooo     ooooo     ooooo     ooooo     |\n"
			row0 = "\n" +
						 "     a    b    c    d    e    f    g    h\n"
		full_string = row9 + row8 + row7 + row6 + row5 + row4 + row3 + row2 + row1 + row0
		full_string.gsub!("o", "\u2591")
		puts full_string
		end

		def valid_move?(response)
			clear_screen
			unless proper_format?(response)
				puts "Check your formatting!"
				return false
			elsif !on_board?(response)
				puts "Stay on the board!"
				return false
			elsif !own_piece?(response)
				puts "You can't attack your own pieces!"
				return false
			elsif !possible_maneuver?(response)
				puts "That piece cant move like that!"
				return false
			else
				return true
			end
		end

		def proper_format?(response)

		end

		def clear_screen
			system "clear" or system "cls"
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
					@board_hash[("#{letter}#{number}".to_sym)] = nil
				end
			end
			fill_board
			return @board_hash
		end

		def fill_board #fills the board with initial placement of all pieces
			@board_hash.each do | key, value |
				@board_hash[key] = Pawn.new(key) if key.to_s.match(/[2,7]/)
				@board_hash[key] = Rook.new(key) if [:a1, :h1, :a8, :h8].include? key
				@board_hash[key] = Knight.new(key) if [:b1, :g1, :b8, :g8].include? key
				@board_hash[key] = Bishop.new(key) if [:c1, :f1, :c8, :f8].include? key
				@board_hash[key] = Queen.new(key) if [:d1, :d8,].include? key
				@board_hash[key] = King.new(key) if [:e1, :e8,].include? key
			end
		end

	end

end