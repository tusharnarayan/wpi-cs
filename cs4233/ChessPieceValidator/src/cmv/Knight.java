/**
 * 
 */
package cmv;

/**
 * @author tnarayan
 *
 */
public class Knight extends ChessPiece {

	/**
	 * @param type
	 * @param color
	 */
	public Knight(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn,
			int toRow) {
		int columnDifferenceValue = columnDifference(fromColumn, toColumn);
		int rowDifferenceValue = rowDifference(fromRow, toRow);
		
		if(columnDifferenceValue == 2 && rowDifferenceValue == 1) return true;
		if(columnDifferenceValue == 1 && rowDifferenceValue == 2) return true;
		return false;
		
	}

}
