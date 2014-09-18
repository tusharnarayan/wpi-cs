/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package hanto;

import hanto.common.*;
import hanto.studenttnarayan.alpha.AlphaHantoGame;
import hanto.studenttnarayan.beta.BetaHantoGame;

/**
 * This is a singleton class that provides a factory to create an instance of
 * any version of a Hanto game.
 * 
 * @author gpollice
 * @author tnarayan
 * @version Sep 14, 2014
 */
public class HantoGameFactory {
	private static final HantoGameFactory instance = new HantoGameFactory();

	/**
	 * Default private descriptor.
	 */
	private HantoGameFactory() {
		// Empty, but the private constructor is necessary for the singleton.
	}

	/**
	 * @return the instance
	 */
	public static HantoGameFactory getInstance() {
		return instance;
	}

	/**
	 * Create the specified Hanto game version with the Blue player moving
	 * first.
	 * 
	 * @param gameId
	 *            the version desired.
	 * @return the game instance
	 */
	public HantoGame makeHantoGame(HantoGameID gameId) {
		return makeHantoGame(gameId, HantoPlayerColor.BLUE);
	}

	/**
	 * Factory method that returns the appropriately configured Hanto game.
	 * 
	 * Note for AlphaHanto:
	 * We ignore movesFirst for AlphaHanto as per discussion board post -
	 * https://my.wpi.edu/webapps/portal/frameset.jsp?tab_tab_group_id=_2_1&
	 * url=%2Fwebapps%2Fblackboard%2Fexecute%2Flauncher%3Ftype%3DCourse%26id%3D_66447_1%26url%3D.
	 * We assume that Blue moves first for each AlphaHantoGame,
	 * hence we do not check the value of movesFirst there.
	 * 
	 * @param gameId
	 *            the version desired.
	 * @param movesFirst
	 *            the player color that moves first
	 * @return the game instance
	 */
	public HantoGame makeHantoGame(HantoGameID gameId,
			HantoPlayerColor movesFirst) {
		HantoGame game = null;
		switch (gameId) {
		case ALPHA_HANTO:
			game = new AlphaHantoGame();
			break;
		case BETA_HANTO:
			game = new BetaHantoGame(movesFirst);
			break;
		default:
			break;
		// TODO add cases for newer game versions as those are developed
		}
		return game;
	}
}
