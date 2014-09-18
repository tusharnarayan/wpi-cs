/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.common;

import hanto.common.HantoCoordinate;
import hanto.common.HantoPieceType;
import hanto.common.HantoPlayerColor;

/**
 * Class for capturing information about each cell on the Hanto board.
 * 
 * Information relevant to each cell is as follows:
 * <ul>
 * <li>the coordinate of the cell on the Hanto board</li>
 * <li>the piece on the cell</li>
 * <li>the player who owns that piece</li>
 * </ul>
 * 
 * @author tnarayan
 * @version Sep 13, 2014
 * 
 */
public class HantoBoardCell {

	private final HantoBoardCoordinate cellCoordinate;
	private final HantoPieceType occupyingPiece;
	private final HantoPlayerColor pieceOwner;

	/**
	 * Constructs a HantoBoardCell using a HantoBoardCoordinate, 
	 * a HantoPieceType, and a HantoPlayerColor
	 * 
	 * @param cellCoordinate
	 * @param occupyingPiece
	 * @param pieceOwner
	 */
	public HantoBoardCell(HantoBoardCoordinate cellCoordinate,
			HantoPieceType occupyingPiece, HantoPlayerColor pieceOwner) {
		this.cellCoordinate = cellCoordinate;
		this.occupyingPiece = occupyingPiece;
		this.pieceOwner = pieceOwner;
	}

	/**
	 * Overloaded constructor. Constructs a HantoBoardCell using a
	 * HantoCoordinate, a HantoPieceType, and a HantoPlayerColor.
	 * 
	 * @param cellCoordinate
	 * @param occupyingPiece
	 * @param pieceOwner
	 */
	public HantoBoardCell(HantoCoordinate cellCoordinate,
			HantoPieceType occupyingPiece, HantoPlayerColor pieceOwner) {
		this(new HantoBoardCoordinate(cellCoordinate.getX(),
				cellCoordinate.getY()), occupyingPiece, pieceOwner);
	}

	/**
	 * @return the cellCoordinate
	 */
	public HantoBoardCoordinate getCellCoordinate() {
		return cellCoordinate;
	}

	/**
	 * @return the occupyingPiece
	 */
	public HantoPieceType getOccupyingPiece() {
		return occupyingPiece;
	}

	/**
	 * @return the pieceOwner
	 */
	public HantoPlayerColor getPieceOwner() {
		return pieceOwner;
	}

	/**
	 * pretty print as a String. print as:
	 * "(0, 0) is occupied by a Butterfly owned by BLUE\n"
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return cellCoordinate.toString() + " is occupied by a "
				+ occupyingPiece.getPrintableName() + " owned by "
				+ pieceOwner.toString() + "\n";
	}

	/**
	 * Overriding the equals() method to be able to compare
	 * objects of this class
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		//check for self
		if (obj == this) {
			return true;
		}
		
		//check for null
		if (obj == null) {
			return false;
		}
		
		//check for class match
		if (!obj.getClass().equals(getClass())) {
			return false;
		}

		//check for properties match
		final HantoBoardCell comparisonBoardCell = (HantoBoardCell) obj;
		return (cellCoordinate.equals(comparisonBoardCell.getCellCoordinate())
				&& occupyingPiece == comparisonBoardCell.getOccupyingPiece()
				&& pieceOwner == comparisonBoardCell.getPieceOwner());
	}

	/**
	 * Overriding the hashCode() method to be able to compare
	 * objects of this class
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int hash = 6;
		hash += prime * hash + cellCoordinate.hashCode();
		hash += prime * hash + occupyingPiece.hashCode();
		hash += prime * hash + pieceOwner.hashCode();
		return hash;
	}

}
