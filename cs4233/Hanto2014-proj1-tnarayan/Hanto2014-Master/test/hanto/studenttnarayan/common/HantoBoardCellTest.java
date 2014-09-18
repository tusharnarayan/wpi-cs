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

import hanto.common.HantoPieceType;
import hanto.common.HantoPlayerColor;

import java.util.Date;

import org.junit.Test;

import static hanto.common.HantoPlayerColor.*;
import static hanto.common.HantoPieceType.*;

/**
 * @author tnarayan
 * 
 */
public class HantoBoardCellTest {

	/**
	 * test constructing HantoBoardCell using a HantoBoardCoordinate
	 */
	@Test
	public void testOverloadedConstructor() {
		int x = 0;
		int y = 0;
		HantoPieceType type = SPARROW;
		HantoPlayerColor color = BLUE;

		HantoBoardCell cellConstructedWithHantoBoardCoordinate = new HantoBoardCell(
				new HantoBoardCoordinate(x, y), type, color);

		assertEquals(x, cellConstructedWithHantoBoardCoordinate
				.getCellCoordinate().getX());
		assertEquals(y, cellConstructedWithHantoBoardCoordinate
				.getCellCoordinate().getY());
		assertTrue(type.equals(cellConstructedWithHantoBoardCoordinate
				.getOccupyingPiece()));
		assertTrue(color.equals(cellConstructedWithHantoBoardCoordinate
				.getPieceOwner()));
	}

	/**
	 * test that equals() is reflexive
	 */
	@Test
	public void testEqualityAginstSelf() {
		HantoBoardCell cell = new HantoBoardCell(
				new HantoBoardCoordinate(2, 5), CRAB,
				RED);

		assertTrue(cell.equals(cell));
	}

	/**
	 * test null comparison for equals()
	 */
	@Test
	public void testEqualityAgainstNullObject() {
		HantoBoardCell cell = new HantoBoardCell(
				new HantoBoardCoordinate(2, 5), CRAB,
				RED);

		assertFalse(cell.equals(null));
	}

	/**
	 * test equals() against object of another class
	 */
	@Test
	public void testEqualityAgainstObjectOfDifferentClass() {
		HantoBoardCell cell = new HantoBoardCell(
				new HantoBoardCoordinate(2, 5), CRAB,
				RED);
		Date date = new Date();

		assertFalse(cell.equals(date));
	}
	
	/**
	 * test equals() for two different objects with same properties.
	 * also tests that equals() is symmetric.
	 */
	@Test
	public void testEqualityForSameCoordinateSamePieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		assertTrue(c1.equals(c2));
		assertTrue(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different player colors
	 */
	@Test
	public void testEqualityForSameCoordinateSamePieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different piece types
	 */
	@Test
	public void testEqualityForSameCoordinateDifferentPieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				DOVE, BLUE);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different piece types 
	 * and player colors
	 */
	@Test
	public void testEqualityForSameCoordinateDifferentPieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				HORSE, BLUE);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different coordinates
	 */
	@Test
	public void testEqualityForDifferentCoordinateSamePieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRAB, RED);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different coordinates and
	 * different player colors
	 */
	@Test
	public void testEqualityForDifferentCoordinateSamePieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRAB, BLUE);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different coordinates and
	 * different piece types
	 */
	@Test
	public void testEqualityForDifferentCoordinateDifferentPieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRANE, RED);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}

	/**
	 * test equals() for two different objects with different coordinates,
	 * different piece types, and different player colors
	 */
	@Test
	public void testEqualityForDifferentCoordinateDifferentPieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				BUTTERFLY, BLUE);
		assertFalse(c1.equals(c2));
		assertFalse(c2.equals(c1));
	}
	
	/**
	 * test hashCode()'s reflexivity
	 */
	@Test
	public void testHashAginstSelf() {
		HantoBoardCell cell = new HantoBoardCell(
				new HantoBoardCoordinate(2, 5), CRAB,
				RED);

		assertEquals(cell.hashCode(), cell.hashCode());
	}

	/**
	 * test hashCode() against object of another class
	 */
	@Test
	public void testHashAgainstObjectOfDifferentClass() {
		HantoBoardCell cell = new HantoBoardCell(
				new HantoBoardCoordinate(2, 5), CRAB,
				RED);
		Date date = new Date();

		assertFalse(cell.hashCode() == date.hashCode());
	}
	
	/**
	 * test hashCode() for two different objects with same coordinates,
	 * same piece types, and same player colors
	 */
	@Test
	public void testHashForSameCoordinateSamePieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		assertEquals(c1.hashCode(), c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with same coordinates,
	 * same piece types, and different player colors
	 */
	@Test
	public void testHashForSameCoordinateSamePieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with same coordinates,
	 * different piece types, and same player colors
	 */
	@Test
	public void testHashForSameCoordinateDifferentPieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, BLUE);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				DOVE, BLUE);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with same coordinates,
	 * different piece types, and different player colors
	 */
	@Test
	public void testHashForSameCoordinateDifferentPieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				HORSE, BLUE);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with different coordinates,
	 * same piece types, and same player colors
	 */
	@Test
	public void testHashForDifferentCoordinateSamePieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRAB, RED);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with different coordinates,
	 * same piece types, and different player colors
	 */
	@Test
	public void testHashForDifferentCoordinateSamePieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRAB, BLUE);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with different coordinates,
	 * different piece types, and same player colors
	 */
	@Test
	public void testHashForDifferentCoordinateDifferentPieceSamePlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				CRANE, RED);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

	/**
	 * test hashCode() for two different objects with different coordinates,
	 * different piece types, and different player colors
	 */
	@Test
	public void testHashForDifferentCoordinateDifferentPieceDifferentPlayer() {
		HantoBoardCell c1 = new HantoBoardCell(new HantoBoardCoordinate(2, 5),
				CRAB, RED);
		HantoBoardCell c2 = new HantoBoardCell(new HantoBoardCoordinate(-4, 5),
				BUTTERFLY, BLUE);
		assertFalse(c1.hashCode() == c2.hashCode());
	}

}
