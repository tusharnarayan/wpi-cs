/*******************************************************************************
 * This files was developed for CS4233: Object-Oriented Analysis & Design.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package hanto.studenttnarayan.common;

import static org.junit.Assert.*;
import static org.junit.Assert.assertTrue;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.junit.Test;

/**
 * Tests for the HantoBoardCoordinate class
 * 
 * @author tnarayan
 * @version Sep 14, 2014
 */
public class HantoBoardCoordinateTest {

	/**
	 * test getAdjacentCoordinates() for (0, 0)
	 */
	@Test
	public void validAdjacentCoordinatesFor0_0() {
		HantoBoardCoordinate coordinate0_0 = new HantoBoardCoordinate(0, 0);
		
		Set<HantoBoardCoordinate> expectedAdjacentCoordinates = new HashSet<HantoBoardCoordinate>();
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(0, 1));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(1, 0));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(1, -1));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(0, -1));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(-1, 0));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(-1, 1));
		
		Set<HantoBoardCoordinate> observedAdjacentCoordinates = coordinate0_0.getAdjacentCoordinates();
		
		assertTrue(expectedAdjacentCoordinates.equals(observedAdjacentCoordinates));
	}
	
	/**
	 * test getAdjacentCoordinates() for (2, 5)
	 */
	@Test
	public void validAdjacentCoordinatesForRandomPointOnBoard() {
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		
		Set<HantoBoardCoordinate> expectedAdjacentCoordinates = new HashSet<HantoBoardCoordinate>();
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(2, 6));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(3, 5));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(3, 4));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(2, 4));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(1, 5));
		expectedAdjacentCoordinates.add(new HantoBoardCoordinate(1, 6));
		
		Set<HantoBoardCoordinate> observedAdjacentCoordinates = coordinate.getAdjacentCoordinates();
		
		assertTrue(expectedAdjacentCoordinates.equals(observedAdjacentCoordinates));
	}
	
	/**
	 * test reflexivity for equals()
	 */
	@Test
	public void testEqualityAginstSelf(){
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		assertTrue(coordinate.equals(coordinate));
	}
	
	/**
	 * test null comparison for equals()
	 */
	@Test
	public void testEqualityAgainstNullObject(){
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		assertFalse(coordinate.equals(null));
	}
	
	/**
	 * test equals() for object of another class
	 */
	@Test
	public void testEqualityAgainstObjectOfDifferentClass(){
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		Date date = new Date();
		assertFalse(coordinate.equals(date));
	}
	
	/**
	 * test symmetry for equals() 
	 */
	@Test
	public void testEqualityForSameXAndSameY(){
		HantoBoardCoordinate coordinate1 = new HantoBoardCoordinate(2, 5);
		HantoBoardCoordinate coordinate2 = new HantoBoardCoordinate(2, 5);
		assertTrue(coordinate1.equals(coordinate2));
		assertTrue(coordinate2.equals(coordinate1));
	}

	/**
	 * test equals() for two coordinates with different x position and
	 * different y position
	 */
	@Test
	public void testEqualityForDifferentXAndDifferentY(){
		HantoBoardCoordinate coordinate2_5 = new HantoBoardCoordinate(2, 5);
		HantoBoardCoordinate coordinate5_2 = new HantoBoardCoordinate(5, 2);
		assertFalse(coordinate2_5.equals(coordinate5_2));
		assertFalse(coordinate5_2.equals(coordinate2_5));
	}
	
	/**
	 * test equals() for two coordinates with different x position and
	 * same y position
	 */
	@Test
	public void testEqualityForDifferentXAndSameY(){
		HantoBoardCoordinate coordinate2_2 = new HantoBoardCoordinate(2, 2);
		HantoBoardCoordinate coordinate5_2 = new HantoBoardCoordinate(5, 2);
		assertFalse(coordinate2_2.equals(coordinate5_2));
		assertFalse(coordinate5_2.equals(coordinate2_2));
	}
	
	/**
	 * test equals() for two coordinates with same x position and
	 * different y position
	 */
	@Test
	public void testEqualityForSameXAndDifferentY(){
		HantoBoardCoordinate coordinate2_5 = new HantoBoardCoordinate(2, 5);
		HantoBoardCoordinate coordinate2_2 = new HantoBoardCoordinate(2, 2);
		assertFalse(coordinate2_5.equals(coordinate2_2));
		assertFalse(coordinate2_2.equals(coordinate2_5));
	}
	
	/**
	 * test reflexivity for hashCode()
	 */
	@Test
	public void testHashAgainstSelf(){
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		assertEquals(coordinate.hashCode(), coordinate.hashCode());
	}
	
	/**
	 * test hashCode() against object of another class
	 */
	@Test
	public void testHashAgainstObjectOfDifferentClass(){
		HantoBoardCoordinate coordinate = new HantoBoardCoordinate(2, 5);
		Date date = new Date();
		assertFalse(coordinate.hashCode() == date.hashCode());
	}
	
	/**
	 * test hashCode() for two objects with same properties
	 */
	@Test
	public void testHashForSameXAndSameY(){
		HantoBoardCoordinate coordinate1 = new HantoBoardCoordinate(-4, 2);
		HantoBoardCoordinate coordinate2 = new HantoBoardCoordinate(-4, 2);
		assertEquals(coordinate1.hashCode(), coordinate2.hashCode());
	}
	
	/**
	 * test hashCode() for two objects with different x position
	 * and different y position
	 */
	@Test
	public void testHashForDifferentXAndDifferentY(){
		HantoBoardCoordinate coordinate2_5 = new HantoBoardCoordinate(2, 5);
		HantoBoardCoordinate coordinate5_2 = new HantoBoardCoordinate(5, 2);
		assertFalse(coordinate2_5.hashCode() == coordinate5_2.hashCode());
	}
	
	/**
	 * test hashCode() for two objects with different x position
	 * and same y position
	 */
	@Test
	public void testHashForDifferentXAndSameY(){
		HantoBoardCoordinate coordinate2_2 = new HantoBoardCoordinate(2, 2);
		HantoBoardCoordinate coordinate5_2 = new HantoBoardCoordinate(5, 2);
		assertFalse(coordinate2_2.hashCode() == coordinate5_2.hashCode());
	}
	
	/**
	 * test hashCode() for two objects with same x position
	 * and different y position
	 */
	@Test
	public void testHashForSameXAndDifferentY(){
		HantoBoardCoordinate coordinate2_5 = new HantoBoardCoordinate(2, 5);
		HantoBoardCoordinate coordinate2_2 = new HantoBoardCoordinate(2, 2);
		assertFalse(coordinate2_5.hashCode() == coordinate2_2.hashCode());
	}
	
	/**
	 * test that (1, 0) is adjacent to (0, 0) using getAdjacentCoordinates()
	 */
	@Test
	public void testCoordinateAdjacentTo0_0(){
		HantoBoardCoordinate coordinate0_0 = new HantoBoardCoordinate(0, 0);
		Set<HantoBoardCoordinate> tilesAdjacentTo0_0 = coordinate0_0.getAdjacentCoordinates();
		
		HantoBoardCoordinate adjacentCoordinate = new HantoBoardCoordinate(1, 0);
		assertTrue(tilesAdjacentTo0_0.contains(adjacentCoordinate));
	}
	
	/**
	 * test that (101, 2000) is adjacent to (100, 2000) using getAdjacentCoordinates()
	 */
	@Test
	public void testCoordinateAdjacentTo100_2000(){
		HantoBoardCoordinate coordinate100_2000 = new HantoBoardCoordinate(100, 2000);
		Set<HantoBoardCoordinate> tilesAdjacentTo100_2000 = coordinate100_2000.getAdjacentCoordinates();
		
		HantoBoardCoordinate adjacentCoordinate = new HantoBoardCoordinate(101, 2000);
		assertTrue(tilesAdjacentTo100_2000.contains(adjacentCoordinate));
	}
	
	/**
	 * test that (11, 2002) is not adjacent to (100, 2000) using getAdjacentCoordinates()
	 */
	@Test
	public void testCoordinateNotAdjacentTo100_2000(){
		HantoBoardCoordinate coordinate100_2000 = new HantoBoardCoordinate(100, 2000);
		Set<HantoBoardCoordinate> tilesAdjacentTo100_2000 = coordinate100_2000.getAdjacentCoordinates();
		
		HantoBoardCoordinate notAdjacentCoordinate = new HantoBoardCoordinate(11, 2002);
		assertFalse(tilesAdjacentTo100_2000.contains(notAdjacentCoordinate));
	}
}
