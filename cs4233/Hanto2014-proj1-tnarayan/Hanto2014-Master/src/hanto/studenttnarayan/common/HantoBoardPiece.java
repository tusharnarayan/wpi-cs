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

import hanto.common.HantoPiece;
import hanto.common.HantoPieceType;
import hanto.common.HantoPlayerColor;

/**
 * Class to implement a HantoPiece
 * 
 * A Hanto Board Piece has a type and a color.
 * 
 * @author tnarayan
 * @version Sep 14, 2014
 *
 */
public class HantoBoardPiece implements HantoPiece {
	
	private final HantoPieceType type;
	private final HantoPlayerColor color;
	
	/**
	 * Constructs a HantoBoardPiece
	 * 
	 * @param type the type of the piece, a HantoPieceType
	 * @param color the color of the piece's owner, a HantoPlayerColor
	 */
	public HantoBoardPiece(HantoPieceType type, HantoPlayerColor color){
		this.type = type;
		this.color = color;
	}

	/**
	 * @return the player color
	 * 
	 * @see hanto.common.HantoPiece#getColor()
	 */
	@Override
	public HantoPlayerColor getColor() {
		return color;
	}

	/**
	 * @return the piece type
	 * 
	 * @see hanto.common.HantoPiece#getType()
	 */
	@Override
	public HantoPieceType getType() {
		return type;
	}

}
