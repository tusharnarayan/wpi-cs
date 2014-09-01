/**
 * 
 */
package cmv;

import static cmv.ChessPlayerColor.*;

/**
 * @author tnarayan
 *
 */
public class Pawn extends ChessPiece {
	
	private ChessPlayerColor color;

	/**
	 * @param type
	 * @param color
	 */
	public Pawn(ChessPlayerColor color) {
		super(cmv.ChessPieceType.PAWN, color);
		this.color = color;
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		int homeRow;
		//TODO clean!
		if(columnDifference(fromColumn, toColumn) != 0) return false;
		
		if(color == WHITE){
			homeRow = 2;
			if(toRow > homeRow){
				if((fromRow == homeRow) && ((toRow - fromRow) == 2)){
					return true;
				}
				else{
					if(((toRow - fromRow) == 1)){
						return true;
					}
					else return false;
				}
			}
			else return false;
		}
		else{
			homeRow = 7;
			if(toRow < homeRow){
				if((fromRow == homeRow) && ((fromRow - toRow) == 2)){
					return true;
				}
				else{
					if(((fromRow - toRow) == 1)){
						return true;
					}
					else return false;
				}
			}
			else return false;
		}
	}

}
