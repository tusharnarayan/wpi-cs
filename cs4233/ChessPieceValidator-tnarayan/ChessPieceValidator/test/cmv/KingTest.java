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

import org.junit.Test;

import static cmv.ChessPlayerColor.*;
import static org.junit.Assert.*;

/**
 * tests specific to a king
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class KingTest {
	
	/**
	 * test isMoveLegal() for Kings (of arbitrary color)
	 */
	@Test
	public void testIsMoveLegal(){
		ChessPiece king = new King(BLACK);
		assertTrue(king.isMoveLegal('d', 3, 'd', 4));
		assertTrue(king.isMoveLegal('e', 4, 'd', 5));
		assertFalse(king.isMoveLegal('b', 2, 'b', 4));
		assertFalse(king.isMoveLegal('c', 3, 'e', 5));
	}
}
