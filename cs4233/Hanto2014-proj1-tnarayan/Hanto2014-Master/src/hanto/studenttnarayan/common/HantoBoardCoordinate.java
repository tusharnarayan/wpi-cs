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

import java.util.HashSet;
import java.util.Set;

import hanto.common.HantoCoordinate;

/**
 * Class to represent a coordinate on the Hanto Board.
 * 
 * @author tnarayan
 * @version Sep 13, 2014
 * 
 */
public class HantoBoardCoordinate implements HantoCoordinate {

	private final int xPosition;
	private final int yPosition;

	/**
	 * Constructs a HantoBoardCoordinate
	 * 
	 * @param xPosition x position of the coordinate
	 * @param yPosition y position of the coordinate
	 */
	public HantoBoardCoordinate(int xPosition, int yPosition) {
		this.xPosition = xPosition;
		this.yPosition = yPosition;
	}

	/**
	 * @return the value of the x position of the coordinate
	 * 
	 * @see hanto.common.HantoCoordinate#getX()
	 */
	@Override
	public int getX() {
		return xPosition;
	}

	/**
	 * @return the value of the y position of the coordinate
	 * 
	 * @see hanto.common.HantoCoordinate#getY()
	 */
	@Override
	public int getY() {
		return yPosition;
	}

	/**
	 * pretty print as String. prints as: "(x, y)".
	 * notice that there is a space after the comma.
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "(" + xPosition + ", " + yPosition + ")";
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
		if(obj == this){
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
		final HantoBoardCoordinate other = (HantoBoardCoordinate) obj;
		if (xPosition != other.xPosition
				|| yPosition != other.yPosition) {
			return false;
		}
		
		return true;
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
		int hash = 5;
		hash += prime * hash + Integer.valueOf(xPosition).hashCode();
		hash += prime * hash + Integer.valueOf(yPosition).hashCode();
		return hash;
	}

	/**
	 * Finds all coordinates on the board that are adjacent to this coordinate
	 * 
	 * @return a Set containing all the HantoBoardCoordinate's that are immediately
	 * 			adjacent to this HantoBoardCoordinate
	 */
	public Set<HantoBoardCoordinate> getAdjacentCoordinates() {
		final Set<HantoBoardCoordinate> adjacentCoordinates = new HashSet<HantoBoardCoordinate>();
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition, yPosition + 1));
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition + 1, yPosition));
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition + 1,
				yPosition - 1));
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition, yPosition - 1));
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition - 1, yPosition));
		adjacentCoordinates.add(new HantoBoardCoordinate(xPosition - 1,
				yPosition + 1));

		return adjacentCoordinates;
	}

}
