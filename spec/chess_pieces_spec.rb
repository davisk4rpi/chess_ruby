require 'chess_pieces'
require 'chess_game'

describe ChessPieces do

	describe "::Pawn" do 
		board = Game::GameBoard.new
		board = board.board_hash

		describe ".marker_color" do 
			describe "position ':c2" do
				it "returns '\u2659'" do
					pawn = ChessPieces::Pawn.new(:c2)
					expect(pawn.marker_color).to eql("\u2659")
				end
			end
		end

		describe ".single_square" do
			it 'returns true or false' do 
				expect(board[:a2].single_square?(:a3, board)).to be true
				board[:b3] = ChessPieces::Pawn.new(:b3)
				expect(board[:b2].single_square?(:b3, board)).to be false
				expect(board[:a2].single_square?(:a4, board)).to be false
				expect(board[:a2].single_square?(:b3, board)).to be false
			end
		end

		describe ".double_square" do
			it 'returns true or false' do 
				expect(board[:a2].double_square?(:a4, board)).to be true
				board[:b3] = ChessPieces::Pawn.new(:b3)
				expect(board[:b2].double_square?(:b4, board)).to be false
				expect(board[:b2].double_square?(:b3, board)).to be false
				expect(board[:b2].double_square?(:c4, board)).to be false
				board[:b4] = ChessPieces::Pawn.new(:b4)
				expect(board[:b2].double_square?(:b4, board)).to be false
			end
		end

		describe ".en_passant" do
			it 'returns true or false' do
				expect(board[:a2].en_passant?(:a4, board)).to be false
				pawn_attacker = ChessPieces::Pawn.new(:b2)
				pawn_attacker.position = :b5
				board[:b5] = pawn_attacker
				pawn = ChessPieces::Pawn.new(:c5)
				expect(board[:b5].en_passant?(:c6, board)).to be false
				board[:last_moved] = [pawn, 'double_square']
				expect(board[:b5].en_passant?(:c6, board)).to be true
				expect(board[:b2].en_passant?(:b3, board)).to be false
				expect(board[:b2].en_passant?(:c3, board)).to be false
				expect(board[:b2].en_passant?(:b4, board)).to be false
			end
		end

		describe ".attack" do
			it 'returns true or false' do 
				board[:b3] = nil
				expect(board[:a2].attack?(:b3, board)).to be false
				board[:b3] = ChessPieces::Pawn.new(:b3)
				expect(board[:a2].attack?(:b3, board)).to be true
				expect(board[:b2].attack?(:b3, board)).to be false
				expect(board[:b2].attack?(:c4, board)).to be false
				expect(board[:b2].attack?(:b4, board)).to be false
			end
		end
	end

	describe "::Rook" do 
		board = Game::GameBoard.new
		board = board.board_hash
		board[:b3] = ChessPieces::Rook.new(:b3)

		describe ".horizontal" do			
			it 'returns true or false' do 
				expect(board[:b3].horizontal?(:e3, board)).to be true
				board[:d3] = ChessPieces::Rook.new(:d3)
				expect(board[:b3].horizontal?(:e3, board)).to be false
				expect(board[:b3].horizontal?(:d3, board)).to be true
				expect(board[:b3].horizontal?(:b5, board)).to be false
				expect(board[:d3].horizontal?(:c3, board)).to be true
			end
		end

		describe ".vertical" do			
			it 'returns true or false' do 
				#going up the board
				expect(board[:b3].vertical?(:b6, board)).to be true
				board[:b5] = ChessPieces::Rook.new(:b5)
				expect(board[:b3].vertical?(:b6, board)).to be false
				expect(board[:b3].vertical?(:b5, board)).to be true
				expect(board[:b3].vertical?(:e3, board)).to be false
				#going down the board
				expect(board[:b5].vertical?(:b3, board)).to be true
				expect(board[:b5].vertical?(:b1, board)).to be false
			end
		end
	end

	describe "::Knight" do 
		board = Game::GameBoard.new
		board = board.board_hash

		describe ".jump" do 
			it 'returns true or false' do 
				expect(board[:b1].jump?(:c3)).to be true
				expect(board[:b8].jump?(:c6)).to be true
				board[:b5] = ChessPieces::Knight.new(:b5)
				expect(board[:b5].jump?(:d4)).to be true
				expect(board[:b5].jump?(:e3)).to be false
				expect(board[:b5].jump?(:h4)).to be false
				expect(board[:b1].jump?(:a7)).to be false
			end
		end
	end

	describe "::Bishop" do 
		board = Game::GameBoard.new
		board = board.board_hash

		describe ".diagonal" do 
			it 'returns true or false' do 
				p board[:d2]
				expect(board[:c1].diagonal?(:f4, board)).to be false
				board[:d2] = nil
				expect(board[:c1].diagonal?(:f4, board)).to be true
				board[:b2] = nil
				expect(board[:c1].diagonal?(:a3, board)).to be true
				board[:b5] = ChessPieces::Bishop.new(:b5)
				expect(board[:b5].diagonal?(:d3, board)).to be true
				expect(board[:b5].diagonal?(:e3, board)).to be false
				expect(board[:b5].diagonal?(:b4, board)).to be false
			end
		end
	end

	describe "::King" do 
		board = Game::GameBoard.new
		board = board.board_hash

		describe ".single_square" do 
			it 'returns true or false' do 
				expect(board[:e1].single_square?(:d2, board)).to be true
				expect(board[:e8].single_square?(:e7, board)).to be true
				board[:a4] = ChessPieces::King.new(:a4)
				expect(board[:a4].single_square?(:h4, board)).to be false
				expect(board[:a4].single_square?(:b3, board)).to be true
				expect(board[:a4].single_square?(:b4, board)).to be true
				expect(board[:a4].single_square?(:a7, board)).to be false
			end
		end

		describe ".castle" do 
			it 'returns true or false' do 
				#board[:e1].find_short(board)
				expect(board[:e1].castle?("short", board)).to be true
				#board[:e1].find_long(board)
				expect(board[:e1].castle?("long", board)).to be true
				board[:h1] = nil
				#board[:e1].find_short(board)
				expect(board[:e1].castle?("short", board)).to be false
				board[:a1] = ChessPieces::Bishop.new(:h1)
				#board[:e1].find_long(board)
				expect(board[:e1].castle?("long", board)).to be false
			end
		end
	end

end
