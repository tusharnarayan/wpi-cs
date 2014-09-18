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
 * tests for functions in the {@link ChessPiece} class
 * 
 * @version Sep 1, 2014
 * 
 * @author tnarayan
 */
public class ChessPieceTest {
	
	/**
	 * tests for columnDifference() in the {@link ChessPiece} class
	 */
	@Test
	public void testColumnDifference(){
		ChessPiece testPiece = new Pawn(WHITE);
		assertEquals(testPiece.columnDifference('a', 'b'), 1);
		assertEquals(testPiece.columnDifference('a', 'c'), 2);
		assertEquals(testPiece.columnDifference('a', 'd'), 3);
		assertEquals(testPiece.columnDifference('a', 'e'), 4);
		assertEquals(testPiece.columnDifference('a', 'f'), 5);
		assertEquals(testPiece.columnDifference('a', 'g'), 6);
		assertEquals(testPiece.columnDifference('a', 'h'), 7);
		
		assertEquals(testPiece.columnDifference('b', 'a'), 1);
		assertEquals(testPiece.columnDifference('c', 'a'), 2);
		assertEquals(testPiece.columnDifference('d', 'a'), 3);
		assertEquals(testPiece.columnDifference('e', 'a'), 4);
		assertEquals(testPiece.columnDifference('f', 'a'), 5);
		assertEquals(testPiece.columnDifference('g', 'a'), 6);
		assertEquals(testPiece.columnDifference('h', 'a'), 7);
		
		assertEquals(testPiece.columnDifference('h', 'h'), 0);
		assertEquals(testPiece.columnDifference('a', 'a'), 0);
	}
	
	/**
	 * tests for rowDifference() in the {@link ChessPiece} class
	 */
	@Test
	public void testRowDifference(){
		ChessPiece testPiece = new Pawn(BLACK);
		assertEquals(testPiece.rowDifference(1, 2), 1);
		assertEquals(testPiece.rowDifference(1, 3), 2);
		assertEquals(testPiece.rowDifference(1, 4), 3);
		assertEquals(testPiece.rowDifference(1, 5), 4);
		assertEquals(testPiece.rowDifference(1, 6), 5);
		assertEquals(testPiece.rowDifference(1, 7), 6);
		assertEquals(testPiece.rowDifference(1, 8), 7);
		
		assertEquals(testPiece.rowDifference(2, 1), 1);
		assertEquals(testPiece.rowDifference(3, 1), 2);
		assertEquals(testPiece.rowDifference(4, 1), 3);
		assertEquals(testPiece.rowDifference(5, 1), 4);
		assertEquals(testPiece.rowDifference(6, 1), 5);
		assertEquals(testPiece.rowDifference(7, 1), 6);
		assertEquals(testPiece.rowDifference(8, 1), 7);
		
		assertEquals(testPiece.rowDifference(4, 4), 0);
		assertEquals(testPiece.rowDifference(6, 6), 0);
	}
}
