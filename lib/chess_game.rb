require_relative 'chess_pieces'
require 'json'

module Game

	

	class GamePlay

		include ChessPieces

		attr_accessor :board, :active_player, :defending_player

		def initialize
			@board = GameBoard.new.board_hash
			assign_players_pieces
			@active_player_name = "Player 1"
			@active_player = @player1_pieces
			@defending_player = @player2_pieces
			introduction
		end

		def assign_players_pieces
			@player1_pieces = []
			@player2_pieces = []
			@board.each do | key, piece |
				unless (piece.nil? || key == :last_moved)
					if piece.color == 'white'
						@player1_pieces << piece
					elsif piece.color == 'black'
						@player2_pieces << piece
					end
				end
			end
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
			2 Load Saved Game
			3 Exit

			HEREDOC
			response = gets.chomp
			until ['1','2','3'].include? response
				puts "Pick from the options above"
				response = gets.chomp
			end
			new_game if response == '1'
			load_saved_game if response == '2'
			exit if response == '3'
		end

		def new_game
			clear_screen
			puts "Player 1 goes first,"
			new_turn
		end

		def new_turn
			puts "Enter your move with the following format: Starting Coordinate Ending Coordinates... ex: 'a2 a4'\n" +
			"To castle, type in 'long castle' or 'short castle' instead of the coordinates\n" + 
			"To save, type in 'save'\n" +
			"#{@active_player_name}, your turn."
			board_view
			response = gets.chomp
			name_save_game if response.downcase == 'save'
			clear_screen

			unless valid_move?(response)
				puts 'Pick a valid_move with the correct format'
				return new_turn
			end

			#castling
			if response[-6, 6] == 'castle'
				puts "Castle!"
			elsif check_yourself?(response, @active_player, @defending_player)
				clear_screen
				puts "You can't make a move that leaves your King in check!"
				return new_turn
			end

			coordinates = response.split(' ')
			move_piece(coordinates)

			#Pawn Promotion cycle
			if promotion?(coordinates[1])
				puts "promoted"
				promote_pawn(coordinates[1]) 
			end

			#check
			if check_opponent? == "checkmate"
				checkmate
			elsif check_opponent? 
				puts "Check!"
			end
			active_player_change
			new_turn
		end

		def name_save_game
			puts "What name would you like to use to save the game?"
			name = gets.chomp
			game_json = serialize_game_board(name)
			save_game(game_json)
			exit_game
		end

		def serialize_game_board(name)
			assign_players_pieces
			@player1_pieces_json = {}
			@player2_pieces_json = {}
			pieces_to_json(@player1_pieces, @player1_pieces_json)
			pieces_to_json(@player2_pieces, @player2_pieces_json)
			json_hash = {:name => name,
									:active_player => @active_player_name,
									:player_1 => @player1_pieces_json,
									:player_2 => @player2_pieces_json}
			saved_game = json_hash.to_json
		end

		def pieces_to_json (player_pieces, json_hash)
			player_pieces.each do | piece |
				json_hash[piece.class] = {:position => piece.position.to_s,
															 	 :marker => piece.marker, 
																 :color => piece.color, 
																 :initial => piece.initial.to_s}
			end
		end

		def save_game(json_hash)
			save_file = File.open("saved_games/saved_games.json", "a")
			save_file.puts json_hash
			save_file.close
		end

		def move_piece(coordinates)
			if coordinates[1] == 'castle'
				castle_move_pieces(coordinates)
			else
				if @board[coordinates[0].to_sym].is_a?(ChessPieces::Pawn) && @board[coordinates[0].to_sym].en_passant?(coordinates[1], @board)
					p "En Passant... ooh lala"
					victim_position = (coordinates[1][0] + coordinates[0][1]).to_sym
					@board[victim_position] = nil
				end
				@board[:last_moved] = [@board[coordinates[0].to_sym], " " ]
				@board[:last_moved] = [@board[coordinates[0].to_sym], "double_square" ] if (coordinates[0][1].to_i - coordinates[1][1].to_i).abs == 2
				@board[coordinates[1].to_sym] = @board[coordinates[0].to_sym]
				@board[coordinates[1].to_sym].position = coordinates[1].to_sym
				@board[coordinates[0].to_sym] = nil
			end
		end

		def castle_move_pieces(coordinates)
			#old position
			king_start_position = @active_player_name == "Player 1" ? :e1 : :e8
			rook_start_letter = coordinates[0] == "short" ? 'h' : 'a'
			number = @active_player_name == "Player 1" ? '1' : '8'
			rook_start_position = (rook_start_letter + number).to_sym
			#new position
			king_new_letter = coordinates[0] == "short" ? 'g' : 'c'
			rook_new_letter = coordinates[0] == "short" ? 'f' : 'd'
			king_new_position = (king_new_letter + number).to_sym
			rook_new_position = (rook_new_letter + number).to_sym
			#update board
			@board[king_new_position] = @board[king_start_position]
			@board[king_new_position].position = king_new_position
			@board[king_start_position] = nil
			@board[rook_new_position] = @board[rook_start_position]
			@board[rook_new_position].position = rook_new_position
			@board[rook_start_position] = nil
			@board[:last_moved] = [@board[king_new_position], " " ]
		end

		def promotion?(space)
			return true if ((['1', '8'].include? space[1]) && (@board[space.to_sym].is_a?(ChessPieces::Pawn)))
		end

		def promote_pawn(space)
			board_view
			adjustment = space[1] == '8' ? '1' : '8'
			color_picker = (space[0] + adjustment).to_sym
			puts "Please choose from the following options and hit enter once you have typed it in.\n" +
					 "Rook, Knight, Bishop, Queen"
			choice = gets.chomp.downcase
			
			case choice
			when "rook" then @board[space.to_sym] = Rook.new(color_picker)
			when "knight" then @board[space.to_sym] = Knight.new(color_picker)
			when "bishop" then @board[space.to_sym] = Bishop.new(color_picker)
			when "queen" then @board[space.to_sym] = Queen.new(color_picker)
			else 
				puts "Use the right format"
				promote_pawn(space)
			end
			@board[space.to_sym].position = space.to_sym
			clear_screen
		end

		def active_player_change
			if @active_player_name == "Player 1"
				@active_player = @player2_pieces
				@defending_player = @player1_pieces
				@active_player_name = "Player 2"
			elsif @active_player_name == "Player 2"
				@active_player = @player1_pieces 
				@defending_player = @player2_pieces
				@active_player_name = "Player 1"
			end
		end

		def board_view
			#design for easy understanding/view over minimalist algorithm
			x = {}
			@board.each do | key, gamepiece |
				unless key == :last_moved
					x[key] = gamepiece.marker unless gamepiece.nil?
					x[key] = " " if gamepiece.nil?
				end
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
			if proper_format?(response)
				#castling is always on board and not an attack
				if response == "long castle" || response == "short castle"
				elsif !on_board?(response)
					puts "Stay on the board!"
					return false
				elsif !own_piece?(response)
					puts "You can't move pieces you don't have and you can't attack your own pieces!"
					return false
				end
			else
				puts "Check your formatting!"
				return false
			end

			if !possible_maneuver?(response)
				puts "That piece cant move like that!"
				return false
			end
			return true
		end

		def proper_format?(response)
			return true if response == "long castle" || response == "short castle"
			return false unless ("a".."z").to_a.include? response[0] #first letter
			return false unless ("0".."9").to_a.include? response[1] #first number
			return false unless response[2] == ' '
			return false unless ("a".."z").to_a.include? response[3] #second letter
			return false unless ("0".."9").to_a.include? response[4] #second number
			return true
		end

		def on_board?(response)
			return false unless ("a".."h").to_a.include? response[0] #first letter
			return false unless ("1".."8").to_a.include? response[1] #first number
			return false unless ("a".."h").to_a.include? response[3] #second letter
			return false unless ("1".."8").to_a.include? response[4] #second number
			return true
		end

		def own_piece?(response, player = @active_player)
			response = response.split(' ')
			start = response[0]
			finish = response[1]
			if player.include? @board[start.to_sym]
				return false if player.include? @board[finish.to_sym]
				return true
			else
				return false
			end
		end

		def possible_maneuver?(response)
			#checks the piece's possible_maneuver? method in chess_pieces.rb
			response = response.split(' ')
			if response[1] == "castle"
				return true if castle_valid?(response[0])
				return false
			end
			return true if @board[response[0].to_sym].possible_maneuver?(response[1], @board)
			return false
		end

		def castle_valid?(response)
			king = @active_player.select { | piece | piece.is_a?(ChessPieces::King) }
			if king[0].castle?(response, @board)
				return true if path_clear?(response)
			end
			p "Castle not valid, make sure that the path is clear and \nyour king wont be ambushed along the way"
			return false
		end

		def path_clear?(response)
			if @active_player_name == "Player 1"
				if response == 'long'
					return false unless ['b1', 'c1', 'd1'].all?{ | space | @board[space.to_sym].nil? }
					return all_possible_moves(@defending_player).none?{ | opp_move | ['b1', 'c1', 'd1', 'e1'].include? opp_move[-2, 2] }
				elsif response == 'short'
					return false unless ['f1', 'g1'].all?{ | space | @board[space.to_sym].nil? }
					return all_possible_moves(@defending_player).none?{ | opp_move | ['e1', 'f1', 'g1'].include? opp_move[-2, 2] }
				end
			elsif @active_player_name == "Player 2"
				if response == 'long'
					return false unless ['b8', 'c8', 'd8'].all?{ | space | @board[space.to_sym].nil? }
					return all_possible_moves(@defending_player).none?{ | opp_move | ['b8', 'c8', 'd8', 'e8'].include? opp_move[-2, 2] }
				elsif response == 'short'
					return false unless ['f8', 'g8'].all?{ | space | @board[space.to_sym].nil? }
					return all_possible_moves(@defending_player).none?{ | opp_move | ['e8', 'f8', 'g8'].include? opp_move[-2, 2] }
				end
			end
			return false
		end

		def check_yourself?(move, yourself, opponent)
			move = move.split(' ')
			temp = @board[move[1].to_sym]
			@board[move[1].to_sym] = @board[move[0].to_sym]
			@board[move[0].to_sym] = nil
			@board[move[1].to_sym].position = move[1].to_sym
			king = yourself.select { | piece | piece.is_a?(ChessPieces::King) }
			if all_possible_moves(opponent).any?{ | opp_move | opp_move[-2, 2] == king[0].position.to_s }
				x = true
			else
				x = false
			end
			@board[move[0].to_sym] = @board[move[1].to_sym]
			@board[move[1].to_sym] = temp
			@board[move[0].to_sym].position = move[0].to_sym
			return x 
		end

		def check_opponent?
			assign_players_pieces
			2.times {active_player_change}
			king = @defending_player.select { | piece | piece.is_a?(ChessPieces::King) }
			spaces = all_possible_moves(@active_player).collect { | move | move[-2, 2] }
			if spaces.any?{ | space | space == king[0].position.to_s }
				return true unless all_possible_moves(@defending_player).all? { | move | check_yourself?(move, @defending_player, @active_player) }
				return "checkmate"
			else
				return false
			end
		end

		def all_possible_moves(player)
			spaces = @board.keys
			spaces.collect! { | space | space.to_s}
			possible_moves = []
			player.each do | piece |
				spaces.each do | space |
					move = piece.position.to_s + ' ' + space
					possible_moves << move if (on_board?(move) && own_piece?(move, player) && possible_maneuver?(move))
				end
			end
			return possible_moves
		end

		def clear_screen
			system "clear" or system "cls"
		end

		def exit_game
			puts "Enter 1 to start over, anything else exits the game"
			exit unless gets.chomp == 1
			GamePlay.new
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
			@board_hash[:last_moved] = nil
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

Game::GamePlay.new