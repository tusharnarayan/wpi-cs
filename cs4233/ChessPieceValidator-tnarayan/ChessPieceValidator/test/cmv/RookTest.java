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
 * tests specific to a rook
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class RookTest {
	
	/**
	 * test isMoveLegal() for Rooks (of arbitrary color)
	 */
	@Test
	public void testIsMoveLegal(){
		ChessPiece rook = new Rook(BLACK);
		assertTrue(rook.isMoveLegal('h', 1, 'h', 6));
		assertTrue(rook.isMoveLegal('a', 6, 'g', 6));
		assertFalse(rook.isMoveLegal('f', 3, 'g', 4));
		assertFalse(rook.isMoveLegal('c', 4, 'e', 5));
	}
}
