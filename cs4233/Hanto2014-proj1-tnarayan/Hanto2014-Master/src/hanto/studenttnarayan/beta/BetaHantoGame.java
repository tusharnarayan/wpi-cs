/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.beta;

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
 * Beta Hanto
 * 
 * The Butterfly and the Sparrow are used. Both can only be placed on the board.
 * Each player has 1 butterfly and 5 sparrows.
 * The game ends when either a butterfly is encircled (a win)
 * or all pieces have been played (a draw).
 * A special game ending is when a move encircles both butterflies at the same time,
 * we treat this as a draw.
 * 
 * @author tnarayan
 * @version Sep 13, 2014
 * 
 */
public class BetaHantoGame implements HantoGame {

	/* contains all moves that have been made on the board */
	private List<HantoBoardCell> hantoBoard;
	
	/* keeps track of whose move it currently is */
	private HantoPlayerColor currentPlayer;
	
	/* keeps track of what pieces blue has left available to play */
	private final List<HantoPieceType> bluePieces = new ArrayList<HantoPieceType>();
	
	/* keeps track of what pieces red has left available to play */
	private final List<HantoPieceType> redPieces = new ArrayList<HantoPieceType>();
	
	/* keeps track of how many turns blue has completed */
	private int blueTurnsCompleted = 0;
	
	/* keeps track of how many turns red has completed */
	private int redTurnsCompleted = 0;

	/* global constant for number of sparrows each player is allotted */
	private static final int NUM_SPARROWS = 5;

	/**
	 * Constructs a BetaHantoGame, and assigns appropriate number of pieces
	 * to each player as per the rules of BetaHanto
	 * 
	 * @param movesFirst HantoPlayerColor indicating which 
	 * 						player moves first in the game
	 */
	public BetaHantoGame(HantoPlayerColor movesFirst) {
		hantoBoard = new ArrayList<HantoBoardCell>();
		currentPlayer = movesFirst;
		assignGamePieces();
	}

	/**
	 * assigns 1 butterfly and NUM_SPARROWS sparrows to each player
	 */
	private void assignGamePieces() {
		bluePieces.add(HantoPieceType.BUTTERFLY);
		redPieces.add(HantoPieceType.BUTTERFLY);

		for (int i = 0; i < NUM_SPARROWS; i++) {
			bluePieces.add(HantoPieceType.SPARROW);
			redPieces.add(HantoPieceType.SPARROW);
		}
	}

	/**
	 * makeMove() logic for an BetaHantoGame
	 * 
	 * @return the result of the move as a {@link MoveResult} object
	 * 
	 * @see hanto.common.HantoGame#makeMove(hanto.common.HantoPieceType, hanto.common.HantoCoordinate, hanto.common.HantoCoordinate)
	 */
	@Override
	public MoveResult makeMove(HantoPieceType pieceType, HantoCoordinate from,
			HantoCoordinate to) throws HantoException {
		MoveResult moveResult = MoveResult.DRAW;

		/* only the butterfly or the sparrow can be used */
		if (pieceType != HantoPieceType.BUTTERFLY
				&& pieceType != HantoPieceType.SPARROW) {
			throw new HantoException(
					"The Butterfly and the Sparrow are the only valid pieces for Beta Hanto.");
		}

		/* the butterfly or sparrow can only be placed on the board, not moved from one location to another */
		if (from != null) {
			throw new HantoException(
					"The Butterfly and the Sparrow can only be placed on the Hanto board - they have no movement capabilities.");
		}

		/* First move must place a piece at (0, 0) in BetaHanto */
		if (blueTurnsCompleted == 0 && redTurnsCompleted == 0) {
			if (to.getX() != 0 || to.getY() != 0) {
				throw new HantoException(
						"The first move of the game must be placed at coordinate (0, 0).");
			}
		}

		/* ensure either player places butterfly by end of their fourth turn */
		if (!hasPlayedButterflyByEndOfTurnFour(pieceType)) {
			throw new HantoException(
					"The Butterfly must be placed by the end of the fourth turn.");
		}

		/* ensure continuity of the board */
		if (!isValidAdjacentMove(to)) {
			throw new HantoException(
					"The piece must be placed adjacent to another piece on the Hanto Board.");
		}

		/* ensure player still has the pieceType available to play from their list of allocated pieces */
		if (!isAvailablePiece(pieceType)) {
			throw new HantoException("No more of that type of piece left.");
		}

		/* make the move by adding to the hantoBoard */
		hantoBoard.add(new HantoBoardCell(to, pieceType, currentPlayer));

		/* update state variables */
		if (currentPlayer == HantoPlayerColor.BLUE) {
			blueTurnsCompleted++;
			bluePieces.remove(pieceType);
			currentPlayer = HantoPlayerColor.RED;
		} else {
			redTurnsCompleted++;
			redPieces.remove(pieceType);
			currentPlayer = HantoPlayerColor.BLUE;
		}

		/* determine result of move */
		if (hantoBoard.size() < 12) {
			boolean blueButterflySurrounded = isButterflySurrounded(HantoPlayerColor.BLUE);
			boolean redButterflySurrounded = isButterflySurrounded(HantoPlayerColor.RED);
			if (redButterflySurrounded && blueButterflySurrounded) {
				moveResult = MoveResult.DRAW;
			} else if (redButterflySurrounded) {
				moveResult = MoveResult.BLUE_WINS;
			} else if (blueButterflySurrounded) {
				moveResult = MoveResult.RED_WINS;
			} else {
				if (hantoBoard.size() == 11) {
					moveResult = MoveResult.DRAW;
				}
				moveResult = MoveResult.OK;
			}
		}
		return moveResult;
	}

	/**
	 * check if the input piece is still available in the currentPlayer's
	 * list of available pieces. uses the currentPlayer state variable.
	 * 
	 * @param pieceType HantoPieceType to check for
	 * @return true if the currentPlayer has the piece available to play.
	 */
	private boolean isAvailablePiece(HantoPieceType pieceType) {
		boolean isAvailable;
		if (currentPlayer == HantoPlayerColor.BLUE) {
			isAvailable = bluePieces.contains(pieceType);
		} else {
			isAvailable = redPieces.contains(pieceType);
		}
		return isAvailable;
	}

	/**
	 * check if the player will have placed the butterfly by the end of their fourth
	 * turn. uses input pieceType to check the proposed move as well.
	 * uses the currentPlayer state variable.
	 * 
	 * @param pieceType HantoPieceType to check proposed move
	 * @return true if the currentPlayer will have placed the butterfly by the end of
	 * 				their fourth move
	 */
	private boolean hasPlayedButterflyByEndOfTurnFour(HantoPieceType pieceType) {
		boolean butterflyPlaced = true;
		if (currentPlayer == HantoPlayerColor.BLUE) {
			if ((blueTurnsCompleted == 3)
					&& (bluePieces.contains(HantoPieceType.BUTTERFLY))) {
				butterflyPlaced = (pieceType == HantoPieceType.BUTTERFLY);
			}
		} else {
			if ((redTurnsCompleted == 3)
					&& (redPieces.contains(HantoPieceType.BUTTERFLY))) {
				butterflyPlaced = (pieceType == HantoPieceType.BUTTERFLY);
			}
		}
		return butterflyPlaced;
	}

	/**
	 * checks to see if the butterfly of the input player is surrounded
	 * 
	 * @param color a HantoPlayerColor to indicate which player's butterfly
	 * 					should be checked
	 * @return true if the player's butterfly is surrounded
	 */
	private boolean isButterflySurrounded(HantoPlayerColor color) {
		/* need at least 7 pieces on board to be able surround a piece */
		if(hantoBoard.size() < 7){
			return false;
		}
		
		/* find where the player's butterfly is placed */
		HantoBoardCoordinate butterflyAt = null;

		for(HantoBoardCell c : hantoBoard){
			if(c.getOccupyingPiece().equals(HantoPieceType.BUTTERFLY)){
				if(c.getPieceOwner().equals(color)){
					butterflyAt = c.getCellCoordinate();
					break;
				}
			}
		}
		
		/* check if the butterfly has been placed or not */
		if(butterflyAt == null){
			return false;
		}
		
		/* if placed, get adjacent tiles to the butterfly */
		Set<HantoBoardCoordinate> adjacentTiles = butterflyAt
				.getAdjacentCoordinates();
		
		/* check if each adjacent tile has a piece played on it */
		for(HantoBoardCoordinate c : adjacentTiles){
			if(!hasPiece(c)) return false;
		}
		return true;
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

	/**
	 * check if the proposed move is adjacent to an already placed piece
	 * 
	 * @param proposedMove the proposed move
	 * @return true if the proposed move is adjacent to an already placed piece
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

		/* find coordinates adjacent to this proposed move's coordinate */
		Set<HantoBoardCoordinate> adjacentTiles = coordinateTo
				.getAdjacentCoordinates();

		/* iterate over adjacent coordinates and check if they have a piece played on them */
		for (HantoBoardCoordinate t : adjacentTiles) {
			if (hasPiece(t)){
				return true;
			}
		}
		return false;
	}

	/**
	 * check if a coordinate has a piece played on it.
	 * iterates over the hantoBoard and checks if it has the input coordinate
	 * among the played moves.
	 * 
	 * @param coordinateToCheck HantoBoardCoordinate to check
	 * @return true if the coordinate has a piece on it
	 */
	private boolean hasPiece(HantoBoardCoordinate coordinateToCheck) {
		for (HantoBoardCell c : hantoBoard) {
			if (c.getCellCoordinate().equals(coordinateToCheck)) {
				return true;
			}
		}
		return false;
	}

}
