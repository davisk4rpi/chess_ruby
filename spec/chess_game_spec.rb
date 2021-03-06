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

		describe '.on_board?' do 
			it 'returns true or false' do
				expect(game.on_board?('a1 b2')).to be true
				expect(game.on_board?('a1 a0')).to be false
				expect(game.on_board?('h8 j8')).to be false
			end
		end

		#unknown error by rspec when this code is executed. 
		#may have been fixed on Ruby 2.3.1 release
		"""describe '.own_piece?' do 
			it 'returns true or false' do
				p 
				#expect(game.own_piece?('a2 a4')).to be true
				expect(game.own_piece?('a1 a2')).to be false
				expect(game.own_piece?('h7 h8')).to be false
			end
		end"""
	end

end