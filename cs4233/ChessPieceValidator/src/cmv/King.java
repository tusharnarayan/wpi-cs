/**
 * 
 */
package cmv;

/**
 * @author tnarayan
 * 
 */
public class King extends ChessPiece {

	/**
	 * @param type
	 * @param color
	 */
	public King(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		if (isSingleSquareMove(fromColumn, fromRow, toColumn, toRow)) {
			return true;
		} else {
			return false;
		}
	}

}
