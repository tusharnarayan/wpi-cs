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
 * tests specific to a knight
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class KnightTest {
	
	/**
	 * test isMoveLegal() for Knights (of arbitrary color)
	 */
	@Test
	public void testIsMoveLegal(){
		ChessPiece knight = new Knight(BLACK);
		assertTrue(knight.isMoveLegal('b', 8, 'c', 6));
		assertTrue(knight.isMoveLegal('b', 1, 'a', 3));
		assertTrue(knight.isMoveLegal('e', 2, 'g', 3));
		assertFalse(knight.isMoveLegal('e', 2, 'g', 5));
		assertFalse(knight.isMoveLegal('f', 3, 'h', 5));
		assertFalse(knight.isMoveLegal('c', 6, 'd', 5));
	}
}
