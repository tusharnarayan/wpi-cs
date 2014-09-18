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
 * Exception that is thrown if the number has a value that cannot be
 * represented with Roman Numerals.
 *
 * @author gpollice
 * @version Apr 1, 2013
 */
public class ValueOutOfBoundsException extends Exception
{
	/**
	 * Constructor with a descriptive message.
	 * @param message The descriptive message
	 */
	public ValueOutOfBoundsException(String message)
	{
		super(message);
	}
}
