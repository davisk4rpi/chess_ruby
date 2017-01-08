require 'chess_game'

describe Game do
	board = Game::GameBoard.new
	game = Game::GamePlay.new
	
	describe '::GameBoard' do
		describe '.construct_board' do 
			describe 'when ::GameBoard.initialize' do 
				it 'constructs a hash containing the initial state of the game board' do 
					expect(board.construct_board[:e1].marker).to eql("\u2654") #white king
					expect(board.construct_board[:b7].marker).to eql("\u265F") #black pawn
					expect(board.construct_board[:e2].marker).to eql("\u2659") #white pawn
					expect(board.construct_board[:a5]).to eql(nil) #empty space
				end
			end
		end
	end

	describe '::GamePlay' do
		describe '.initialize' do
			describe 'board is hash' do
				it 'is type hash' do 
					expect(game.board.is_a?(Hash)).to be true
				end
				it 'has value "\u265D"' do
					expect(game.board.empty?).to be false
				end
			end
		end
		describe '.board_view' do
			it 'prints the board' do
				game.board_view
				game.board[:c5] = game.board[:c7]
				game.board[:c7] = nil
				game.board[:f3] = game.board[:g1]
				game.board[:g1] = nil
				game.board_view
			end
		end

		describe '.proper_format?' do 
			it 'returns true or false' do
				expect(game.proper_format?('long castle')).to be true
				expect(game.proper_format?('a1 b2')).to be true
				expect(game.proper_format?('long stle')).to be false
				expect(game.proper_format?('1a 2b')).to be false
				expect(game.proper_format?('a1,b2')).to be false
			end
		end
	end

end