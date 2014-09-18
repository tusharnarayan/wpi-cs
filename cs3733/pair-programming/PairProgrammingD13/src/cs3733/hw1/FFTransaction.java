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
 * This class is a basic data structure, with appropriate getters for the
 * fields. It is used to represent a single transaction for a frequent flyer. This
 * is either a debit to the points (when the flyer makes a paid trip) or credit
 * (when the flyer redeems points for a trip).
 *
 * @author gpollice
 * @version Mar 19, 2013
 */
public class FFTransaction
{
	private static int nextTransactionNumber = 1;
	private final int transactionNumber;
	private final String from;
	private final String to;
	private final double transactionAmount;
	
	public FFTransaction(String from, String to, double transactionAmount)
	{
		this.transactionNumber = nextTransactionNumber++;
		this.from = from;
		this.to = to;
		this.transactionAmount = transactionAmount;
	}
	
	/**
	 * Reset the transaction numbers. This is used mainly for testing.
	 *
	 */
	static void resetTransactionNumbers()
	{
		nextTransactionNumber = 1;
	}

	/**
	 * @return the transactionNumber
	 */
	public int getTransactionNumber()
	{
		return transactionNumber;
	}

	/**
	 * @return the from
	 */
	public String getFrom()
	{
		return from;
	}

	/**
	 * @return the to
	 */
	public String getTo()
	{
		return to;
	}

	/**
	 * @return the transactionAmount
	 */
	public double getTransactionAmount()
	{
		return transactionAmount;
	}
}
