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
 * tests specific to a bishop
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class BishopTest {

	/**
	 * test isMoveLegal() for Bishops (of arbitrary color)
	 */
	@Test
	public void testIsMoveLegal(){
		ChessPiece bishop = new Bishop(WHITE);
		assertTrue(bishop.isMoveLegal('c', 1, 'f', 4));
		assertTrue(bishop.isMoveLegal('h', 8, 'a', 1));
		assertFalse(bishop.isMoveLegal('c', 5, 'e', 5));
		assertFalse(bishop.isMoveLegal('f', 4, 'd', 5));
	}
}
