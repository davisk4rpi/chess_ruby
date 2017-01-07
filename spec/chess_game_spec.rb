require 'chess_game'

describe Game do
	board = Game::GameBoard.new
	
	describe '::GameBoard' do
		describe '.construct_board' do 
			describe 'when ::GameBoard.initialize' do 
				it 'constructs a hash containing the initial state of the game board' do 
					expect(board.construct_board[:e1]).to eql("\u2654") #white king
					expect(board.construct_board[:b7]).to eql("\u265F") #black pawn
					expect(board.construct_board[:e2]).to eql("\u2659") #white pawn
					expect(board.construct_board[:a5]).to eql(" ") #empty space
				end
			end
		end
	end

end