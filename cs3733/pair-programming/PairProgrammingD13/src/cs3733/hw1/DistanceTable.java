/*******************************************************************************
 * Copyright (c) 2012 Gary F. Pollice
 * 
 * All rights reserved. This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors: gpollice
 *******************************************************************************/

package cs3733.hw1;

import java.util.*;

/**
 * The distance table contains all of the distances between airports that this 
 * airline has routes for. This class is implemented as a Singleton. In order
 * to use it, one must get the single instance using the <code>getInstance()</code>
 * method.
 * 
 * @author gpollice
 * @version Mar 18, 2013
 */
public class DistanceTable
{
	static private final DistanceTable instance = new DistanceTable();
	
	private final Map<String, Integer> mileages;

	/**
	 * Default constructor.
	 */
	private DistanceTable()
	{
		mileages = new HashMap<String, Integer>();
	}

	/**
	 * Method to add a pair of airports and their distance to this table
	 * 
	 * @param airportA
	 *            Airport A's three-letter designation
	 * @param airportB
	 *            Airport B's three-letter designation
	 * @param distance
	 *            The distance between airports A and B in miles
	 */
	public void addAirportPair(String airportA, String airportB, int distance)
	{
		mileages.put(makeKey(airportA, airportB), distance);
	}

	/**
	 * Return the distance between two airports.
	 * 
	 * @param airportA
	 *            Airport A's three-letter designation
	 * @param airportB
	 *            Airport B's three-letter designation
	 * @return The distance between airports A and B if it is stored in this table, -1 otherwise
	 */
	public int getDistance(String airportA, String airportB)
	{
		return mileages.get(makeKey(airportA, airportB));
	}

	/**
	 * Given two airport codes, make a key value that consists of the two codes
	 * concatenated, with the lexicographically lower code first.
	 * 
	 * The codes are in capital letters. This method ensures that they are all
	 * capitals before returning the key.
	 *
	 * @param airportA the first airport code
	 * @param airportB the second airport code
	 * @return the key string
	 */
	private String makeKey(String airportA, String airportB)
	{
		final String a1 = airportA.toUpperCase();
		final String a2 = airportB.toUpperCase();
		return a1.compareTo(a2) < 0 ? a1 + a2 : a2 + a1;
	}

	/**
	 * @return the unique distance table instance
	 */
	public static DistanceTable getInstance()
	{
		return instance;
	}
	
	/**
	 * Clear the distances. This is done before creating a new distance table.
	 */
	public void clear()
	{
		mileages.clear();
	}
}
