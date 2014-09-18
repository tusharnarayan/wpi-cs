/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.beta;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import hanto.HantoGameFactory;
import hanto.common.HantoException;
import hanto.common.HantoGame;
import hanto.common.HantoGameID;
import hanto.common.HantoPiece;
import hanto.common.HantoPieceType;
import hanto.common.HantoPlayerColor;
import hanto.common.MoveResult;
import hanto.studenttnarayan.common.HantoBoardCoordinate;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Tests for the BetaHantoGame
 * 
 * @author tnarayan
 * @version Sep 14, 2014
 */
public class BetaHantoGameTest {

	private static HantoGameFactory factory = null;
	private HantoGame blueMovesFirstGame;
	private HantoGame redMovesFirstGame;

	/**
	 * get instance of the game factory before running any tests in suite
	 */
	@BeforeClass
	public static void initializeClass() {
		factory = HantoGameFactory.getInstance();
	}

	/**
	 * get two new BetaHantoGame's before running each test
	 * <ul>
	 * <li>one game is where the blue player moves first</li>
	 * <li>the other is where the red player moves first</li>
	 * </ul>
	 */
	@Before
	public void setup() {
		blueMovesFirstGame = factory.makeHantoGame(HantoGameID.BETA_HANTO, HantoPlayerColor.BLUE);
		redMovesFirstGame = factory.makeHantoGame(HantoGameID.BETA_HANTO, HantoPlayerColor.RED);
	}

	/**
	 * test that factory can generate an BetaHantoGame
	 */
	@Test
	public void factoryGeneratesBetaHantoGame() {
		assertTrue(blueMovesFirstGame instanceof BetaHantoGame);
		assertTrue(redMovesFirstGame instanceof BetaHantoGame);
	}

	/**
	 * test MoveResult when blue makes a valid first move
	 * @throws HantoException
	 */
	@Test
	public void blueMakesValidFirstMove() throws HantoException {
		final MoveResult moveResult = blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY,
				null, new HantoBoardCoordinate(0, 0));
		MoveResult expectedResult = MoveResult.OK;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}

	/**
	 * test MoveResult when red makes a valid red move
	 * @throws HantoException
	 */
	@Test
	public void redMakesValidFirstMove() throws HantoException {
		final MoveResult moveResult = redMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY,
				null, new HantoBoardCoordinate(0, 0));
		MoveResult expectedResult = MoveResult.OK;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}

	/**
	 * test getPieceAt() when blue makes a valid first move with Butterfly
	 * @throws HantoException
	 */
	@Test
	public void blueChecksButterflyAfterFirstMove() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		final HantoPiece piece = blueMovesFirstGame
				.getPieceAt(new HantoBoardCoordinate(0, 0));
		assertEquals(HantoPieceType.BUTTERFLY, piece.getType());
		assertEquals(HantoPlayerColor.BLUE, piece.getColor());
	}

	/**
	 * test getPieceAt() when blue makes a valid first move with Sparrow
	 * @throws HantoException
	 */
	@Test
	public void blueChecksSparrowAfterFirstMove() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(
				0, 0));
		final HantoPiece piece = blueMovesFirstGame
				.getPieceAt(new HantoBoardCoordinate(0, 0));
		assertEquals(HantoPieceType.SPARROW, piece.getType());
		assertEquals(HantoPlayerColor.BLUE, piece.getColor());
	}

	/**
	 * test that a HantoException is generated when a player tries to place a Crab
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlaceCrab() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.CRAB, null, new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is generated when a player tries to place a Horse
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlaceHorse() throws HantoException {
		redMovesFirstGame.makeMove(HantoPieceType.HORSE, null,
				new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is generated when a player tries to place a Crane
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlaceCrane() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.CRANE, null,
				new HantoBoardCoordinate(0, 0));
	}
	
	/**
	 * test that a HantoException is generated when a player tries to place a Dove
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlaceDove() throws HantoException {
		redMovesFirstGame.makeMove(HantoPieceType.DOVE, null, new HantoBoardCoordinate(0, 0));
	}

	/**
	 * test that a HantoException is generated when a player tries to move an already placed butterfly
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToMoveButterflyFromOneLocationToAnother()
			throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, new HantoBoardCoordinate(0, 1),
				new HantoBoardCoordinate(0, 0));
	}
	
	/**
	 * test that a HantoException is generated when a player tries to move an already placed sparrow
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToMoveSparrowFromOneLocationToAnother()
			throws HantoException {
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, new HantoBoardCoordinate(0, 1),
				new HantoBoardCoordinate(0, 0));
	}
	
	/**
	 * test that a HantoException is generated when a player tries make the first move in
	 * (0, 0)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlayFirstInX0_YNon0() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 1));
	}
	
	/**
	 * test that a HantoException is generated when a player tries make the first move in
	 * (1, 0)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlayFirstInXNon0_Y0() throws HantoException{
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
	}
	
	/**
	 * test that a HantoException is generated when a player tries make the first move in
	 * (-1, 1)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlayFirstInXNon0_YNon0() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 1));
	}
	
	/**
	 * test that a HantoException is generated when a player tries make the first move in
	 * (10, -14)
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void tryToPlayFirstInTileNotAdjacentTo0_0() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(10, -14));
	}
	
	/**
	 * test MoveResult when the game is drawn because neither butterfly is encircled
	 * and all pieces have been placed
	 * @throws HantoException
	 */
	@Test
	public void playDrawGrame() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(6, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(7, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(8, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(9, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(10, 0));
		final MoveResult moveResult = blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(11, 0));
		MoveResult expectedResult = MoveResult.DRAW;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test MoveResult when blue wins
	 * @throws HantoException
	 */
	@Test
	public void blueWins() throws HantoException {
		redMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		redMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(1, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, -1));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, -1));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 1));
		final MoveResult moveResult = redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 1));
		MoveResult expectedResult = MoveResult.BLUE_WINS;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test MoveResult when red wins
	 * @throws HantoException
	 */
	@Test
	public void redWins() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, -1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, -1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 1));
		final MoveResult moveResult = blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 1));
		MoveResult expectedResult = MoveResult.RED_WINS;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test MoveResult when the game is drawn because both butterflies are encircled by a move
	 * @throws HantoException
	 */
	@Test
	public void gameDrawsBecauseBothButterfliesSurrounded() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, -1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, -1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 1));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(-1, 2));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 1));
		final MoveResult moveResult = blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 2));
		MoveResult expectedResult = MoveResult.DRAW;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test that a HantoException is thrown when red tries to break the continuity
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void redTriesToBreakContinuity() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, -3));
	}
	
	/**
	 * test that a HantoException is thrown when blue tries to play a second butterfly
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToPlayTwoButterflies() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(-1, 0));
	}
	
	/**
	 * test that a HantoException is thrown because red does not play butterfly by the end of the fourth turn
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void redTriesToAvoidPlayingButterflyByEndOfFourthTurn() throws HantoException{
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(6, 0));
	}
	
	/**
	 * test that a HantoException is thrown because blue does not play butterfly by the end of the fourth turn
	 * @throws HantoException
	 */
	@Test(expected = HantoException.class)
	public void blueTriesToAvoidPlayingButterflyByEndOfFourthTurn() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(6, 0));
	}
	
	/**
	 * test MoveResult when blue plays butterfly on the fourth turn
	 * @throws HantoException
	 */
	@Test
	public void bluePlaysButterflyOnFourthMove() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		final MoveResult moveResult = blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(6, 0));
		MoveResult expectedResult = MoveResult.OK;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test MoveResult when red plays butterfly on the fourth turn
	 * @throws HantoException
	 */
	@Test
	public void redPlaysButterflyOnFourthMove() throws HantoException{
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		final MoveResult moveResult = redMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(6, 0));
		MoveResult expectedResult = MoveResult.OK;
		assertEquals("Move result is " + moveResult + ", expected "
				+ expectedResult, expectedResult, moveResult);
	}
	
	/**
	 * test getPieceAt() after red plays butterfly on the fourth turn
	 * @throws HantoException
	 */
	@Test
	public void checkPieceAfterRedPlaysButterflyOnFourthMove() throws HantoException{
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(0, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(1, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		redMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		redMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(6, 0));
		
		final HantoPiece piece = redMovesFirstGame.getPieceAt(new HantoBoardCoordinate(
				6, 0));
		assertEquals(HantoPieceType.BUTTERFLY, piece.getType());
		assertEquals(HantoPlayerColor.RED, piece.getColor());
	}
	
	/**
	 * test getPrintableBoard() after the game is drawn
	 * @throws HantoException
	 */
	@Test
	public void printedBoardAfterDraw() throws HantoException {
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(1, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(2, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(3, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(4, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(5, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(6, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(7, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(8, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(9, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(10, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.SPARROW, null, new HantoBoardCoordinate(11, 0));
		
		String expectedBoardState = "[" + "(0, 0) is occupied by a Butterfly owned by BLUE\n, (1, 0) is occupied by a Butterfly owned by RED\n," + 
				" (2, 0) is occupied by a Sparrow owned by BLUE\n, (3, 0) is occupied by a Sparrow owned by RED\n," + 
				" (4, 0) is occupied by a Sparrow owned by BLUE\n, (5, 0) is occupied by a Sparrow owned by RED\n," + 
				" (6, 0) is occupied by a Sparrow owned by BLUE\n, (7, 0) is occupied by a Sparrow owned by RED\n," + 
				" (8, 0) is occupied by a Sparrow owned by BLUE\n, (9, 0) is occupied by a Sparrow owned by RED\n," + 
				" (10, 0) is occupied by a Sparrow owned by BLUE\n, (11, 0) is occupied by a Sparrow owned by RED\n" + "]";
		String observedBoardState = blueMovesFirstGame.getPrintableBoard();
		assertEquals("Expected Board State: " + expectedBoardState
				+ "; obtained Board State: " + observedBoardState,
				expectedBoardState, observedBoardState);
	}
	
	/**
	 * test that a HantoException is thrown on trying to get a piece on an empty board
	 */
	@Test
	public void tryGettingPieceOnEmptyBoard(){
		final HantoPiece piece = redMovesFirstGame
				.getPieceAt(new HantoBoardCoordinate(0, 0));
		assertEquals(piece, null);
	}
	
	/**
	 * test getPieceAt() on an usused coordinate for a non-empty board
	 * @throws HantoException
	 */
	@Test
	public void tryGettingUnplacedPieceOnNonEmptyBoard() throws HantoException{
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				0, 0));
		blueMovesFirstGame.makeMove(HantoPieceType.BUTTERFLY, null, new HantoBoardCoordinate(
				-1, 1));
		final HantoPiece piece = blueMovesFirstGame
				.getPieceAt(new HantoBoardCoordinate(4, 2));
		assertEquals(piece, null);
	}

}
