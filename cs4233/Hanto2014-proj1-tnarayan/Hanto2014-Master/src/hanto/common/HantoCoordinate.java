/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design. The course was
 * taken at Worcester Polytechnic Institute. All rights reserved. This program and the
 * accompanying materials are made available under the terms of the Eclipse Public License
 * v1.0 which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package hanto.common;

/**
 * The HantoCoordinate identifies a specific hex on the Hanto board.
 * 
 * @author gpollice
 * @see <a
 *      href="http://www.vbforums.com/showthread.php?663283-Hexagonal-coordinate-system">
 *      Hexagonal Coordinate System</a>
 * @version Jan 12, 2013
 */
public interface HantoCoordinate
{
	/**
	 * @return the X-coordinate
	 */
	int getX();

	/**
	 * @return the Y-coordinate
	 */
	int getY();
}
