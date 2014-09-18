/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.alpha;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import hanto.common.HantoCoordinate;
import hanto.common.HantoException;
import hanto.common.HantoGame;
import hanto.common.HantoPiece;
import hanto.common.HantoPieceType;
import hanto.common.HantoPlayerColor;
import hanto.common.MoveResult;
import hanto.studenttnarayan.common.HantoBoardCell;
import hanto.studenttnarayan.common.HantoBoardCoordinate;
import hanto.studenttnarayan.common.HantoBoardPiece;

/**
 * Alpha Hanto
 * 
 * Only one piece type is used, the Butterfly. The Butterfly has no movement
 * capability, it is only placed on the board.
 * 
 * The order of play is as follows: Blue moves first and places the Butterfly at
 * (0, 0). Red then places the Butterfly adjacent to the Blue Butterfly. The
 * game then ends in a draw.
 * 
 * @author tnarayan
 * @version Sep 13, 2014
 * 
 */
public class AlphaHantoGame implements HantoGame {
	
	/* contains all moves that have been made on the board */
	private final List<HantoBoardCell> hantoBoard;
	
	/* keeps track of whose move it currently is */
	private HantoPlayerColor currentPlayer;

	/**
	 * Constructs an AlphaHantoGame. Blue always moves first.
	 */
	public AlphaHantoGame() {
		hantoBoard = new ArrayList<HantoBoardCell>();
		currentPlayer = HantoPlayerColor.BLUE;
	}

	/**
	 * makeMove() logic for an AlphaHantoGame
	 * 
	 * @return the result of the move as a {@link MoveResult} object
	 * 
	 * @see hanto.common.HantoGame#makeMove(hanto.common.HantoPieceType, hanto.common.HantoCoordinate, hanto.common.HantoCoordinate)
	 */
	@Override
	public MoveResult makeMove(HantoPieceType pieceType, HantoCoordinate from,
			HantoCoordinate to) throws HantoException {
		MoveResult moveResult;
		
		/* only the butterfly can be used */
		if (pieceType != HantoPieceType.BUTTERFLY) {
			throw new HantoException(
					"The Butterfly is the only valid piece for Alpha Hanto.");
		}

		/* the butterfly can only be placed on the board, not moved from one location to another */
		if (from != null) {
			throw new HantoException(
					"The Butterfly can only be placed on the Hanto board - it has no movement capability.");
		}

		/* Blue must place the butterfly at (0, 0) in AlphaHanto */
		if (currentPlayer == HantoPlayerColor.BLUE) {
			if (to.getX() != 0 || to.getY() != 0) {
				throw new HantoException(
						"Blue must place the Butterfly at coordinate (0, 0).");
			}
		}
		
		/* ensure continuity of the board */
		if (!isValidAdjacentMove(to)) {
			throw new HantoException(
					"The piece must be placed adjacent to another piece on the Hanto Board.");
		}

		/* make the move by adding to the hantoBoard */
		hantoBoard.add(new HantoBoardCell(to, pieceType, currentPlayer));

		/* update state variables */
		if (currentPlayer == HantoPlayerColor.BLUE) {
			currentPlayer = HantoPlayerColor.RED;
		} else {
			currentPlayer = HantoPlayerColor.BLUE;
		}

		/* determine result of move */
		if (hantoBoard.size() < 2) {
			moveResult = MoveResult.OK;
		} else {
			moveResult = MoveResult.DRAW;
		}
		
		return moveResult;
	}

	/**
	 * check if the proposed move is adjacent to (0, 0)
	 * 
	 * @param proposedMove the proposed move
	 * @return true if the proposed move is adjacent to (0, 0)
	 */
	private boolean isValidAdjacentMove(HantoCoordinate proposedMove) {
		/* return true if no moves have been made yet */
		if (hantoBoard.size() < 1) {
			return true;
		}

		/* convert to our implementation of the HantoCoordinate interface */
		int x = proposedMove.getX();
		int y = proposedMove.getY();
		HantoBoardCoordinate coordinateTo = new HantoBoardCoordinate(x, y);
		
		/* find coordinates adjacent to (0, 0) */
		HantoBoardCoordinate coordinate0_0 = new HantoBoardCoordinate(0, 0);
		Set<HantoBoardCoordinate> tilesAdjacentTo0_0 = coordinate0_0.getAdjacentCoordinates();
		
		/* check if the input coordinate is in the list of adjacent coordinates */
		return tilesAdjacentTo0_0.contains(coordinateTo);
	}

	/**
	 * Overriding getPieceAt().
	 * Check each element of the hantoBoard List to see if the cell contains
	 * the desired coordinates. If yes, return the HantoPiece at those coordinates.
	 * 
	 * @return the HantoPiece object at the input coordinate if any, else null
	 * 
	 * @see hanto.common.HantoGame#getPieceAt(hanto.common.HantoCoordinate)
	 */
	@Override
	public HantoPiece getPieceAt(HantoCoordinate where) {
		HantoBoardCoordinate coordinateBeingChecked = new HantoBoardCoordinate(
				where.getX(), where.getY());

		for (HantoBoardCell c : hantoBoard) {
			if (c.getCellCoordinate().equals(coordinateBeingChecked)) {
				return new HantoBoardPiece(c.getOccupyingPiece(),
						c.getPieceOwner());
			}
		}
		return null;
	}

	/**
	 * Overriding getPrintableBoard()
	 * 
	 * @return board printed as a string
	 * 
	 * @see hanto.common.HantoGame#getPrintableBoard()
	 */
	@Override
	public String getPrintableBoard() {
		return hantoBoard.toString();
	}

}
