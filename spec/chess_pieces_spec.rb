require 'chess_pieces'
require 'chess_game'

describe ChessPieces do

	board = Game::GameBoard.new
	board = board.board_hash

	describe "::Pawn" do 
		describe ".marker_color" do 
			describe "position ':c2" do
				it "returns '\u2659'" do
					pawn = ChessPieces::Pawn.new(:c2)
					expect(pawn.marker_color).to eql("\u2659")
				end
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
				expect(board[:a2].double_square?(:b3, board)).to be false
				board[:b3] = ChessPieces::Pawn.new(:b3)
				expect(board[:a2].double_square?(:b3, board)).to be true
				expect(board[:b2].double_square?(:b3, board)).to be false
				expect(board[:b2].double_square?(:c4, board)).to be false
				expect(board[:b2].double_square?(:b4, board)).to be false
			end
		end

end
