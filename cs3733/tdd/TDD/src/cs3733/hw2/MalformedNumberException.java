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

package cs3733.hw2;

/**
 * Exception that is thrown when the string that should represent a number,
 * either in Roman or Arabic form, is malformed.
 *
 * @author gpollice
 * @version Apr 1, 2013
 */
public class MalformedNumberException extends Exception
{
	/**
	 * Constructor with a descriptive message.
	 * @param message The descriptive message
	 */
	public MalformedNumberException(String message)
	{
		super(message);
	}
}
