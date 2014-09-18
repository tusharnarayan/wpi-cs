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

import static cmv.ChessPlayerColor.*;

/**
 * A class that contains the information needed for the Pawn chess piece.
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 * 
 */
public class Pawn extends ChessPiece {

	/* home rows for pawns of the two colors */
	private final int homeRowBlackPawn = 7;
	private final int homeRowWhitePawn = 2;

	/**
	 * @param color
	 *            the piece color
	 */
	public Pawn(ChessPlayerColor color) {
		super(cmv.ChessPieceType.PAWN, color);
	}

	/**
	 * <p>
	 * Implementation of abstract method from superclass.
	 * 
	 * This method determines whether the pawn can move from the specified
	 * column and row to the specified destination column and row. This assumes
	 * that the board is a standard 8x8 chess board.
	 * 
	 * Constraints on the different moves are documented in the abstract {@link ChessPiece}
	 * class's isMoveLegal method.
	 * 
	 * The pawn's move is legal under the following conditions:
	 * <ul>
	 * <li>it can only move vertically on the board (column cannot change)</li>
	 * <li>if it is a white pawn it can move one square towards row 8</li>
	 * <li>if it is a white pawn and on the home row for white pawns, it can move two squares towards row 8</li>
	 * <li>if it is a black pawn it can move one square towards row 1</li>
	 * <li>if it is a black pawn and on the home row for black pawns, it can move two squares towards row 1</li>
	 * </ul>
	 * </p>
	 */
	@Override
	public boolean isMoveLegal(char fromColumn, int fromRow, char toColumn, int toRow) {
		if (columnDifference(fromColumn, toColumn) != 0) return false;

		if (this.getPieceColor() == WHITE) {
			/* toRow is greater than fromRow because of how the board is laid out */
			if (((toRow - fromRow) == 1)) {
				return true;
			}
			else if ((fromRow == homeRowWhitePawn) && ((toRow - fromRow) == 2)) {
				return true;
			}
			else {
				return false;
			}

		}
		else {
			/* fromRow is greater than toRow because of how the board is laid out */
			if (((fromRow - toRow) == 1)) {
				return true;
			}
			else if ((fromRow == homeRowBlackPawn) && ((fromRow - toRow) == 2)) {
				return true;
			}
			else {
				return false;
			}
		}
	}

}
