/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.alpha;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import hanto.HantoGameFactory;
import hanto.common.HantoException;
import hanto.common.HantoGame;
import hanto.common.HantoGameID;
import hanto.common.HantoPiece;
import hanto.common.HantoPlayerColor;
import hanto.common.HantoPieceType;
import hanto.common.MoveResult;
import hanto.studenttnarayan.common.HantoBoardCoordinate;

/**
 * Tests for the AlphaHantoGame
 * 
 * @author tnarayan
 * @version Sep 14, 2014 
 */
public class AlphaHantoGameTest {

	private static HantoGameFactory factory = null;
	private HantoGame game;

	/**
	 * get instance of the game factory before running any tests in suite
	 */
	@BeforeClass
	public static void initializeClass() {
		factory = HantoGameFactory.getInstance();
	}

	/**
	 * get a new AlphaHantoGame before running each test
	 */
	@Before
	public void setup() {
		game = factory.makeHantoGame(HantoGameID.ALPHA_HANTO);
	}

	/**
	 * test that factory can generate an AlphaHantoGame
	 */
	@Test
	public void factoryGeneratesAlphaHantoGame() {
		assertTrue(game instanceof AlphaHantoGame);
	}

	/**
	 * test MoveResult when blue makes a valid first move
	 * @throws HantoException
	 */
	@Test
	public void blueMakesValidFirstMove() throws HantoException {
		final MoveResult moveResult = game.makeMove(HantoPieceType.BUTTERFLY,
				null, new HantoBoardCoordinate(0, 0));
		MoveResult expectedResult = MoveResult.OK;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}

	/**
	 * test getPieceAt in the {@link HantoGame} class
	 * @throws HantoException
	 */
	@Test
	public void checkBlueButterflyAfterFirstMove() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		final HantoPiece piece = game
				.getPieceAt(new HantoBoardCoordinate(0, 0));
		assertEquals(HantoPieceType.BUTTERFLY, piece.getType());
		assertEquals(HantoPlayerColor.BLUE, piece.getColor());
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a Crab in AlphaHanto
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlaceCrab() throws HantoException {
		game.makeMove(HantoPieceType.CRAB, null, new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a Horse in AlphaHanto
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlaceHorse() throws HantoException {
		game.makeMove(HantoPieceType.HORSE, null,
				new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a Crane in AlphaHanto
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlaceCrane() throws HantoException {
		game.makeMove(HantoPieceType.CRANE, null,
				new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a Dove in AlphaHanto
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlaceDove() throws HantoException {
		game.makeMove(HantoPieceType.DOVE, null, new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a Sparrow in AlphaHanto
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlaceSparrow() throws HantoException {
		game.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0,
				0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a butterfly in (0, 1)
	 * as the first move
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesInvalidButterflyMoveInAdjacentTileWithXCoordinate0()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 1));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a butterfly in (1, 0)
	 * as the first move
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesInvalidButterflyMoveInAdjacentTileWithYCoordinate0()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				1, 0));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a butterfly in (-1, 1)
	 * as the first move
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesInvalidButterflyMoveInAdjacentTileWithNoCoordinate0()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 1));
	}

	/**
	 * test that a HantoException is thrown when blue tries to place a butterfly in (5, -9)
	 * as the first move
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesInvalidButterflyMoveInNonAdjacentTile()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				5, -9));
	}

	/**
	 * test getPieceAt when red places butterfly at (0, 1) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAt0_1() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 1));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(0, 1));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test getPieceAt when red places butterfly at (1, 0) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAt1_0() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				1, 0));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(1, 0));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test getPieceAt when red places butterfly at (1, -1) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAt1_Negative1() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				1, -1));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(1, -1));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test getPieceAt when red places butterfly at (0, -1) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAt0_Negative1() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, -1));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(0, -1));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test getPieceAt when red places butterfly at (1, 0) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAtNegative1_0() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 0));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(-1, 0));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test getPieceAt when red places butterfly at (-1, 1) in a valid move
	 * @throws HantoException
	 */
	@Test
	public void redPlacesValidButterflyAtNegative1_1() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 1));
		final HantoPiece firstPiece = game.getPieceAt(new HantoBoardCoordinate(
				0, 0));
		final HantoPiece secondPiece = game
				.getPieceAt(new HantoBoardCoordinate(-1, 1));
		assertEquals(HantoPieceType.BUTTERFLY, firstPiece.getType());
		assertEquals(HantoPlayerColor.BLUE, firstPiece.getColor());
		assertEquals(HantoPieceType.BUTTERFLY, secondPiece.getType());
		assertEquals(HantoPlayerColor.RED, secondPiece.getColor());
	}

	/**
	 * test MoveResult after red places butterfly in a valid second move
	 * @throws HantoException
	 */
	@Test
	public void gameDrawsAfterRedMakesValidMove() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		final MoveResult moveResult = game.makeMove(HantoPieceType.BUTTERFLY,
				null, new HantoBoardCoordinate(-1, 1));
		MoveResult expectedResult = MoveResult.DRAW;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}

	/**
	 * test that an HantoException is thrown when red tries to break continuity
	 * by placing butterfly at (0, 2)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void redTriesInvalidButterflyMoveAt0_2() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 2));
	}

	/**
	 * test that an HantoException is thrown when red tries to break continuity
	 * by placing butterfly at (1, 2)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void redTriesInvalidButterflyMoveAt1_2() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				1, 2));
	}

	/**
	 * test that an HantoException is thrown when red tries to break continuity
	 * by placing butterfly at (-1, 2)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void redTriesInvalidButterflyMoveAtNegative1_2()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 2));
	}

	/**
	 * test that an HantoException is thrown when blue tries to move butterfly from
	 * one location to another
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToMoveButterflyFromOneLocationToAnother()
			throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, new HantoBoardCoordinate(0, 1),
				new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that an HantoException is thrown when blue tries to place a second
	 * butterfly
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesASecondMoveWithAButterfly() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 1));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				1, 0));
	}

	/**
	 * test that an HantoException is thrown when blue tries to place a second
	 * piece (after game is drawn)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesASecondMoveWithAnotherPiece() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 1));
		game.makeMove(HantoPieceType.CRANE, null,
				new HantoBoardCoordinate(1, 0));
	}

	/**
	 * test getPrintableBoard() in the {@link HantoGame} class after game is drawn
	 * @throws HantoException
	 */
	@Test
	public void printedBoardAfterDraw() throws HantoException {
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 1));
		String expectedBoardState = "[(0, 0) is occupied by a Butterfly owned by BLUE\n, (-1, 1) is occupied by a Butterfly owned by RED\n]";
		String observedBoardState = game.getPrintableBoard();
		assertEquals("Expected Board State: " + expectedBoardState
				+ "; obtained Board State: " + observedBoardState,
				expectedBoardState, observedBoardState);
	}
	
	/**
	 * test getPieceAt() for an empty board
	 */
	@Test
	public void tryGettingPieceOnEmptyBoard(){
		final HantoPiece piece = game
				.getPieceAt(new HantoBoardCoordinate(0, 0));
		assertEquals(piece, null);
	}
	
	/**
	 * test getPieceAt() on an usused coordinate for a non-empty board
	 * @throws HantoException
	 */
	@Test
	public void tryGettingUnplacedPieceOnNonEmptyBoard() throws HantoException{
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		game.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 1));
		final HantoPiece piece = game
				.getPieceAt(new HantoBoardCoordinate(4, 2));
		assertEquals(piece, null);
	}

}
