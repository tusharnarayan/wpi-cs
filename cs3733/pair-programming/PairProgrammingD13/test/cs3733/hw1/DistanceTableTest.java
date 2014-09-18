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

import static org.junit.Assert.*;
import org.junit.*;

/**
 * Description
 *
 * @author gpollice
 * @version Mar 18, 2013
 */
public class DistanceTableTest
{
	private DistanceTable dt = DistanceTable.getInstance();
	
	@Before
	public void setup()
	{
		dt.clear();
		dt.addAirportPair("BOS", "JFK", 187);
		dt.addAirportPair("EWR", "BOS", 200);
		dt.addAirportPair("ATL", "BOS", 946);
		dt.addAirportPair("JFK", "SFO", 2578);
		dt.addAirportPair("DEN", "SEA", 1022);
		dt.addAirportPair("ORD", "ORD", 885);
		dt.addAirportPair("ORD", "BOS", 864);
	}
	
	@Test
	public void addBostonAndNewYork()
	{
		dt.clear();
		dt.addAirportPair("BOS", "JFK", 187);
		assertEquals(187, dt.getDistance("BOS", "JFK"));
	}
	
	@Test
	public void haveTwoDistanceEntries()
	{
		dt.clear();
		dt.addAirportPair("BOS", "JFK", 187);
		dt.addAirportPair("EWR", "BOS", 200);
		assertEquals(187, dt.getDistance("BOS", "JFK"));
		assertEquals(200, dt.getDistance("EWR", "BOS"));
	}
	
	@Test
	public void useDifferentOrderForRetrieval()
	{
		dt.clear();
		dt.addAirportPair("BOS", "JFK", 187);
		dt.addAirportPair("EWR", "BOS", 200);
		assertEquals(187, dt.getDistance("BOS", "JFK"));
		assertEquals(187, dt.getDistance("JFK", "BOS"));
	}
	
	@Test
	public void useLowerCaseCodes()
	{
		dt.addAirportPair("ewr", "sfo", 2556);
		assertEquals(2556, dt.getDistance("SFO", "EWR"));
	}
	
	@Test
	public void replaceTableEntry()
	{
		dt.addAirportPair("SEA", "DEN", 1025);
		assertEquals(1025, dt.getDistance("DEN", "SEA"));
	}
}
