/**
 * 
 */
package cmv;

/**
 * @author tnarayan
 * 
 */
public class Rook extends ChessPiece {

	/**
	 * @param type
	 * @param color
	 */
	public Rook(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		if (isValidVerticalMove(fromColumn, fromRow, toColumn, toRow)
				|| isValidHorizontalMove(fromColumn, fromRow, toColumn, toRow)) {
			return true;
		}
		return false;
	}

}
