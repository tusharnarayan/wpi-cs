/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package hanto.common;


/**
 * The HantoGame interface is the primary interface between the student's code and any
 * external (non-student written) code. Every version of Hanto will have a realization of
 * the HantoGame interface.
 * 
 * @author gpollice
 * @version Jan 12, 2013
 */
public interface HantoGame
{
	/**
	 * This method executes a move in the game. It is called for every move that must be
	 * made.
	 * 
	 * @param pieceType
	 *            the piece type that is being moved
	 * @param from
	 *            the coordinate where the piece begins. If the coordinate is null, then
	 *            the piece begins off the board (that is, it is placed on the board in
	 *            this move).
	 * @param to
	 *            the coordinated where the piece is after the move has been made.
	 * @return the result of the move
	 * @throws HantoException
	 *             if there are any problems in making the move (such as specifying a
	 *             coordinate that does not have the appropriate piece, or the color of
	 *             the piece is not the color of the player who is moving.
	 */
	MoveResult makeMove(HantoPieceType pieceType, HantoCoordinate from,
			HantoCoordinate to) throws HantoException;
	
	/**
	 * @param where the coordinate to query
	 * @return the piece at the specified coordinate or null if there is no 
	 * 	piece at that position
	 */
	HantoPiece getPieceAt(HantoCoordinate where);

	/**
	 * @return a printable representation of the board.
	 */
	String getPrintableBoard();
}
