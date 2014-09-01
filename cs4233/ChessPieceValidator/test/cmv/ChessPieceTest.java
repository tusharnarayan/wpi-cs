/**
 * 
 */
package cmv;

import org.junit.Test;

import static cmv.ChessPieceType.*;
import static cmv.ChessPlayerColor.*;
import static org.junit.Assert.*;

/**
 * @author tnarayan
 *
 * TODO COMMENTS
 * TODO remove redundant tests
 */
public class ChessPieceTest {

	@Test
	public void testWhitePawn(){
		ChessPiece whitePawn = new Pawn(WHITE);
		assertTrue(whitePawn.isMoveLegal('b', 2, 'b', 3));
		assertTrue(whitePawn.isMoveLegal('e', 2, 'e', 4));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'g', 6));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'f', 4));
		assertFalse(whitePawn.isMoveLegal('f', 5, 'f', 2));
	}
	
	@Test
	public void testBlackPawn(){		
		ChessPiece blackPawn = new Pawn(BLACK);
		assertTrue(blackPawn.isMoveLegal('g', 7, 'g', 6));
		assertTrue(blackPawn.isMoveLegal('f', 7, 'f', 5));
		assertFalse(blackPawn.isMoveLegal('c', 3, 'c', 4));
		assertFalse(blackPawn.isMoveLegal('d', 6, 'd', 4));
		assertFalse(blackPawn.isMoveLegal('d', 6, 'd', 7));
	}
	
	@Test
	public void testEitherPawn(){		
		ChessPiece blackPawn = new Pawn(BLACK);
		ChessPiece whitePawn = new Pawn(WHITE);
		assertFalse(blackPawn.isMoveLegal('h', 5, 'g', 5));
		assertFalse(whitePawn.isMoveLegal('h', 5, 'g', 5));
	}
	
	@Test
	public void testRook(){
		ChessPiece rook = new Rook(BLACK);
		assertTrue(rook.isMoveLegal('h', 1, 'h', 6));
		assertTrue(rook.isMoveLegal('a', 6, 'g', 6));
		assertFalse(rook.isMoveLegal('f', 3, 'g', 4));
		assertFalse(rook.isMoveLegal('c', 4, 'e', 5));
	}
	
	@Test
	public void testBishop(){
		ChessPiece bishop = new Bishop(WHITE);
		assertTrue(bishop.isMoveLegal('c', 1, 'f', 4));
		assertTrue(bishop.isMoveLegal('h', 8, 'a', 1));
		assertFalse(bishop.isMoveLegal('c', 5, 'e', 5));
		assertFalse(bishop.isMoveLegal('f', 4, 'd', 5));
	}
	
	@Test
	public void testKnight(){
		ChessPiece knight = new Knight(BLACK);
		assertTrue(knight.isMoveLegal('b', 8, 'c', 6));
		assertTrue(knight.isMoveLegal('b', 1, 'a', 3));
		assertTrue(knight.isMoveLegal('e', 2, 'g', 3));
		assertFalse(knight.isMoveLegal('e', 2, 'g', 5));
		assertFalse(knight.isMoveLegal('f', 3, 'h', 5));
		assertFalse(knight.isMoveLegal('c', 6, 'd', 5));
	}
	
	@Test
	public void testQueen(){
		ChessPiece queen = new Queen(WHITE);
		assertTrue(queen.isMoveLegal('d', 8, 'd', 3));
		assertTrue(queen.isMoveLegal('d', 1, 'h', 1));
		assertTrue(queen.isMoveLegal('g', 3, 'd', 6));
		assertFalse(queen.isMoveLegal('d', 1, 'g', 2));
	}
	
	@Test
	public void testKing(){
		ChessPiece king = new King(BLACK);
		assertTrue(king.isMoveLegal('d', 3, 'd', 4));
		assertTrue(king.isMoveLegal('e', 4, 'd', 5));
		assertFalse(king.isMoveLegal('b', 2, 'b', 4));
		assertFalse(king.isMoveLegal('c', 3, 'e', 5));
	}
	
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
}
