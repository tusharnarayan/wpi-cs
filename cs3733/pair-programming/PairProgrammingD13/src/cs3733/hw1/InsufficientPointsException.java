/*******************************************************************************
 * Copyright (c) 2012 Gary F. Pollice
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    gpollice
 *******************************************************************************/

package cs3733.hw1;

/**
 * An exception indicating that an attempt was made to book a flight using points
 * and there were not enough points in the account.
 *
 * @author gpollice
 * @version Mar 19, 2013
 */
public class InsufficientPointsException extends Exception
{
	/**
	 * Constructor with a message.
	 * @param msg the text of the message
	 */
	public InsufficientPointsException(String msg)
	{
		super(msg);
	}
}
