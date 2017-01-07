require 'chess_pieces'

describe ChessPieces do

	describe "::Pawn" do 
		describe ".marker_color" do 
			describe "position 'c2" do
				it "returns '\u2659'" do
					pawn = ChessPieces::Pawn.new('c2')
					expect(pawn.marker_color).to eql("\u2659")
				end
			end
		end
	end

end
