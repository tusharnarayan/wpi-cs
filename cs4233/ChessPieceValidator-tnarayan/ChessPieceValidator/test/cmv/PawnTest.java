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
 * tests specific to pawns
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class PawnTest {

	/**
	 * test isMoveLegal() for a white pawn
	 */
	@Test
	public void testIsMoveLegalWhitePawn(){
		ChessPiece whitePawn = new Pawn(WHITE);
		assertTrue(whitePawn.isMoveLegal('b', 2, 'b', 3));
		assertTrue(whitePawn.isMoveLegal('e', 2, 'e', 4));
		assertFalse(whitePawn.isMoveLegal('e', 2, 'e', 5));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'g', 6));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'f', 4));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'f', 2));
	}
	
	/**
	 * test isMoveLegal() for a black pawn
	 */
	@Test
	public void testIsMoveLegalBlackPawn(){		
		ChessPiece blackPawn = new Pawn(BLACK);
		assertTrue(blackPawn.isMoveLegal('g', 7, 'g', 6));
		assertTrue(blackPawn.isMoveLegal('f', 7, 'f', 5));
		assertFalse(blackPawn.isMoveLegal('f', 7, 'f', 4));
		assertFalse(blackPawn.isMoveLegal('c', 3, 'c', 4));
		assertFalse(blackPawn.isMoveLegal('d', 6, 'd', 4));
		assertFalse(blackPawn.isMoveLegal('d', 6, 'd', 7));
	}
	
	/**
	 * test isMoveLegal() for either color of pawn
	 */
	@Test
	public void testIsMoveLegalEitherPawn(){		
		ChessPiece blackPawn = new Pawn(BLACK);
		ChessPiece whitePawn = new Pawn(WHITE);
		assertFalse(blackPawn.isMoveLegal('h', 5, 'g', 5));
		assertFalse(whitePawn.isMoveLegal('h', 5, 'g', 5));
	}
	
}
