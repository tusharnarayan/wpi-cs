/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package cmv;

/**
 * A class that contains the information needed for a chess piece.
 * 
 * @version Aug 15, 2014 TODO fix version
 * 
 * @author tnarayan Tushar Narayan; tnarayan@wpi.edu
 */
public abstract class ChessPiece {
	/**
	 * Constructor that creates the piece
	 * 
	 * @param type
	 *            the type of piece
	 * @param color
	 *            the piece color
	 */
	public ChessPiece(ChessPieceType type, ChessPlayerColor color) {
		// TODO Implement the constructor
	}

	/**
	 * <p>
	 * This method determines whether the piece can move from the specified
	 * column and row to the specified destination column and row. This assumes
	 * that the board is a standard 8x8 chess board. Standard <a
	 * href="http://www.quadibloc.com/chess/images/descr.gif">algebraic
	 * notation</a> is used to represent rows and columns. As per the discussion
	 * board, the notation used is actually <a href=
	 * "http://upload.wikimedia.org/wikipedia/commons/b/b6/SCD_algebraic_notation.svg"
	 * > this link</a>.
	 * </p>
	 * <p>
	 * For purposes of this assignment, you may assume that the following
	 * conditions hold:
	 * <ul>
	 * <li>
	 * All rows and columns are valid. That is, the column will be a character
	 * in the range 'a'-'h' and rows will be integers in the range 1-8.</li>
	 * <li>
	 * Any pawn's starting location will be in a valid position. For example,
	 * you will never be presented with a White pawn starting on the first row
	 * of the board.</li>
	 * <li>The board is assumed to be empty.</li>
	 * <li>
	 * Since the board is empty, pawns may not move diagonally. They do,
	 * however, need to move in the correct direction.</li>
	 * <li>
	 * You can assume that a piece will not try to move onto the square it
	 * starts on.</li>
	 * </ul>
	 * </p>
	 * <p>
	 * If you do not know how the various chess pieces move, you can find out by
	 * looking <a href="http://www.chess.com/learn-how-to-play-chess#howtomove">
	 * here</a>.
	 * </p>
	 * 
	 * @param fromColumn
	 *            the starting column
	 * @param fromRow
	 *            the starting row
	 * @param toColumn
	 *            the destination column
	 * @param toRow
	 *            the destination row
	 * @return true if the piece may legally move from the starting location to
	 *         the destination location.
	 */
	abstract public boolean isMoveLegal(char fromColumn, int fromRow,
			char toColumn, int toRow);

	/*
	 * { // Implement this method return false; }
	 */

	// TODO comments
	// TODO make private
	public int columnDifference(char fromColumn, char toColumn) {
		int fromColumnNumber = fromColumn - '0';
		int toColumnNumber = toColumn - '0';
		return Math.abs(toColumnNumber - fromColumnNumber);
	}

	// TODO comments
	// TODO make private
	public int rowDifference(int fromRow, int toRow) {
		return Math.abs(toRow - fromRow);
	}
	
	protected boolean isValidHorizontalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		if(rowDifference(fromRow, toRow) != 0){
			return false;
		}
		return true;
	}
	
	protected boolean isValidVerticalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		if(columnDifference(fromColumn, toColumn) != 0){
			return false;
		}
		return true;
	}
	
	protected boolean isSingleSquareMove(char fromColumn, int fromRow, char toColumn, int toRow){
		return ((columnDifference(fromColumn, toColumn) == 1) || (rowDifference(fromRow, toRow) == 1));
	}
	
	protected boolean isValidDiagonalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		return (columnDifference(fromColumn, toColumn) == rowDifference(fromRow, toRow));
	}

}
