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
 * @version Sep 1, 2014
 * 
 * @author gpollice
 * @author tnarayan
 * 
 * Student information - Tushar Narayan; tnarayan@wpi.edu
 */
public abstract class ChessPiece {

	private ChessPlayerColor color;

	/**
	 * Constructor that creates the piece
	 * 
	 * @param type
	 *            the type of piece
	 * @param color
	 *            the piece color
	 */
	protected ChessPiece(ChessPieceType type, ChessPlayerColor color) {
		this.color = color;
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
	public abstract boolean isMoveLegal(char fromColumn, int fromRow, char toColumn, int toRow);

	/**
	 * @param fromColumn
	 *            the starting column
	 * @param toColumn
	 *            the destination column
	 * @return an integer that is the absolute value of the difference
	 *         between the two input parameters (after converting the characters
	 *         to their ASCII equivalent).
	 */
	protected int columnDifference(char fromColumn, char toColumn) {
		int fromColumnNumber = fromColumn - '0';
		int toColumnNumber = toColumn - '0';
		return Math.abs(toColumnNumber - fromColumnNumber);
	}

	/**
	 * @param fromRow
	 *            the starting row
	 * @param toRow
	 *            the destination row
	 * @return an integer that is the absolute value of the difference
	 *         between the two input parameters.
	 */
	protected int rowDifference(int fromRow, int toRow) {
		return Math.abs(toRow - fromRow);
	}

	/**
	 * A horizontal move is valid if the proposed move does not involve a change in
	 * the row values.
	 * 
	 * @param fromColumn
	 *            the starting column
	 * @param fromRow
	 *            the starting row
	 * @param toColumn
	 *            the destination column
	 * @param toRow
	 *            the destination row
	 * @return true if the move from the starting location to
	 *         the destination location is a valid horizontal move.
	 */
	protected boolean isValidHorizontalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		if(rowDifference(fromRow, toRow) != 0){
			return false;
		}
		return true;
	}

	/**
	 * A vertical move is valid if the proposed move does not involve a change in
	 * the column values.
	 * 
	 * @param fromColumn
	 *            the starting column
	 * @param fromRow
	 *            the starting row
	 * @param toColumn
	 *            the destination column
	 * @param toRow
	 *            the destination row
	 * @return true if the move from the starting location to
	 *         the destination location is a valid vertical move.
	 */
	protected boolean isValidVerticalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		if(columnDifference(fromColumn, toColumn) != 0){
			return false;
		}
		return true;
	}

	/**
	 * A single square move is valid if the proposed move has a change in location
	 * that is just a single square.
	 * 
	 * @param fromColumn
	 *            the starting column
	 * @param fromRow
	 *            the starting row
	 * @param toColumn
	 *            the destination column
	 * @param toRow
	 *            the destination row
	 * @return true if the move from the starting location to
	 *         the destination location is a valid single square move.
	 */
	protected boolean isValidSingleSquareMove(char fromColumn, int fromRow, char toColumn, int toRow){
		return ((columnDifference(fromColumn, toColumn) == 1) || (rowDifference(fromRow, toRow) == 1));
	}

	/**
	 * A diagonal move is valid if the proposed move has a change in column values that
	 * is equal to the change in row values.
	 * 
	 * @param fromColumn
	 *            the starting column
	 * @param fromRow
	 *            the starting row
	 * @param toColumn
	 *            the destination column
	 * @param toRow
	 *            the destination row
	 * @return true if the move from the starting location to
	 *         the destination location is a valid diagonal move.
	 */
	protected boolean isValidDiagonalMove(char fromColumn, int fromRow, char toColumn, int toRow){
		return (columnDifference(fromColumn, toColumn) == rowDifference(fromRow, toRow));
	}

	/**
	 * @return the color of this chess piece as a {@link ChessPlayerColor}
	 */
	public ChessPlayerColor getPieceColor(){
		return color;
	}
}
