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
 * A class that contains the information needed for the Rook chess piece.
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 * 
 */
public class Rook extends ChessPiece {

	/**
	 * @param color
	 *            the piece color
	 */
	public Rook(ChessPlayerColor color) {
		super(cmv.ChessPieceType.ROOK, color);
	}

	/**
	 * <p>
	 * Implementation of abstract method from superclass.
	 * 
	 * This method determines whether the rook can move from the specified
	 * column and row to the specified destination column and row. This assumes
	 * that the board is a standard 8x8 chess board.
	 * 
	 * Constraints on the different moves are documented in the abstract {@link ChessPiece}
	 * class's isMoveLegal method.
	 * 
	 * The rook's move is legal if it is either:
	 * <ul>
	 * <li>a valid vertical move (no change in columns), or</li>
	 * <li>a valid horizontal move (no change in rows).</li>
	 * </ul>
	 * </p>
	 */
	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn, int toRow) {
		if (isValidVerticalMove(fromColumn, fromRow, toColumn, toRow)) return true;
		if (isValidHorizontalMove(fromColumn, fromRow, toColumn, toRow)) return true;
		
		return false;
	}

}
