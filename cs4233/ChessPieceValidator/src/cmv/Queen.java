/**
 * 
 */
package cmv;

/**
 * @author tnarayan
 * 
 */
public class Queen extends ChessPiece {

	/**
	 * @param type
	 * @param color
	 */
	public Queen(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		if (isValidVerticalMove(fromColumn, fromRow, toColumn, toRow)
				|| isValidHorizontalMove(fromColumn, fromRow, toColumn, toRow)) {
			return true;
		}
		if(isValidDiagonalMove(fromColumn, fromRow, toColumn, toRow)){
			return true;
		}
		return false;
	}

}
