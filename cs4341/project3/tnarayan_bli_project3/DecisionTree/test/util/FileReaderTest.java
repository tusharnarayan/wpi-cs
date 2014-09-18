package util;

/*******************************************************************************
 * This files was developed for CS4341: Artificial Intelligence.
 * The course was taken at Worcester Polytechnic Institute.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import Main.DecisionTree;

public class FileReaderTest {
	private static FileReader fileReader;

	@Before
	public void setup() {
		fileReader = FileReader.getInstance();
	}

	@Test
	public void test() throws IOException {
		List<String> a = fileReader.readCSVFile("test_dataset/71.csv");
		assertNotNull(a);
	}

	@Test
	public void createBoard() throws IOException {
		List<String> a = fileReader.readCSVFile("test_dataset/71.csv");
		Board b = new Board(a);
		b.printBoard();
	}

	@Test
	public void createResult() throws IOException {
		List<String> a = fileReader
				.readCSVFile("test_dataset/training_results.csv");
		a.remove(0);
		Result r = new Result(a.get(0));
		assertTrue(r.gameNumber == 1);
		assertTrue(r.currentTurn == 1);
		assertTrue(r.winner == 2);
	}

	@Test
	public void testMain() {
		DecisionTree.main(null);
	}
}
