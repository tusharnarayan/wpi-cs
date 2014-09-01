/**
 * 
 */
package cmv;

/**
 * @author tnarayan
 * 
 */
public class Bishop extends ChessPiece {

	/**
	 * @param type
	 * @param color
	 */
	public Bishop(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		if (isValidDiagonalMove(fromColumn, fromRow, toColumn, toRow)) {
			return true;
		}
		return false;
	}

}
