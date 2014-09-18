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
 * This enumeration is used to define the pieces used in Hanto.
 * 
 * @version Jan 12, 2013
 */
public enum HantoPieceType
{
	BUTTERFLY("Butterfly", "B"), 
	CRAB("Crab", "C"), 
	HORSE("Horse", "H"), 
	CRANE("Crane", "N"), 
	DOVE("Dove", "D"), 
	SPARROW("Sparrow", "S");
	
	private final String printableName;
	private final String symbol;
	
	/**
	 * The constructor for each enumerable item sets up the state so that
	 * the symbol for each item and the printable name are set up.
	 * 
	 * @param printableName the value returned from toString
	 * @param symbol a one character string that can be used when printing the board.
	 */
	private HantoPieceType(String printableName, String symbol)
	{
		this.printableName = printableName;
		this.symbol = symbol;
	}

	/**
	 * @return the printableName
	 */
	public String getPrintableName()
	{
		return printableName;
	}

	/**
	 * @return the symbol
	 */
	public String getSymbol()
	{
		return symbol;
	}
	
	@Override
	public String toString()
	{
		return printableName;
	}
}
