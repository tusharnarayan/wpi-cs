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
 * tests specific to a queen
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class QueenTest {
	
	/**
	 * test isMoveLegal() for Queens (of arbitrary color)
	 */
	@Test
	public void testIsMoveLegal(){
		ChessPiece queen = new Queen(WHITE);
		assertTrue(queen.isMoveLegal('d', 8, 'd', 3));
		assertTrue(queen.isMoveLegal('d', 1, 'h', 1));
		assertTrue(queen.isMoveLegal('g', 3, 'd', 6));
		assertFalse(queen.isMoveLegal('d', 1, 'g', 2));
	}
}
