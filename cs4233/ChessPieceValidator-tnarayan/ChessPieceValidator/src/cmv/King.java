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
 * A class that contains the information needed for the King chess piece.
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 * 
 */
public class King extends ChessPiece {

	/**
	 * @param color
	 *            the piece color
	 */
	public King(ChessPlayerColor color) {
		super(cmv.ChessPieceType.KING, color);
	}

	/**
	 * <p>
	 * Implementation of abstract method from superclass.
	 * 
	 * This method determines whether the king can move from the specified
	 * column and row to the specified destination column and row. This assumes
	 * that the board is a standard 8x8 chess board.
	 * 
	 * Constraints on the different moves are documented in the abstract {@link ChessPiece}
	 * class's isMoveLegal method.
	 * 
	 * The king's move is legal if it is a move to an immediately adjacent 
	 * square on the board.
	 * </p>
	 */
	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn, int toRow) {
		return isValidSingleSquareMove(fromColumn, fromRow, toColumn, toRow);
	}

}
