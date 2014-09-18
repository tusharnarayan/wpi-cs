package cs3733.hw1;

import static org.junit.Assert.*;
import java.util.Iterator;
import org.junit.*;

/**
 * Tests for FrequentFlyer.java
 * 
 * @author: Cynthia Rogers
 * @author: Tushar Narayan
 * Written as part of the Pair Programming assignment for CS 3733 D term 2013.
 * Based off FrequentFlyerStarterTest.java provided as part of the assignment.
 * 
 * @version Mar 25, 2013
 */
/**
 * @author cerogers
 *
 */
public class FrequentFlyerTest
{
	private FrequentFlyer flyer1, flyer2, flyer3, flyer4, flyer5, flyer6, flyer7, flyer8, flyer9;
	private FrequentFlyer flyerBasic, flyerSilver, flyerGold, flyerPlatinum;
	private int pointsRem8, pointsRem9;

	/**
	 * Put some things into the distanceTable;
	 */
	@BeforeClass
	public static void setupContext()
	{
		final DistanceTable dt = DistanceTable.getInstance();
		dt.clear();
		dt.addAirportPair("BOS", "JFK", 187);
		dt.addAirportPair("EWR", "BOS", 200);
		dt.addAirportPair("ATL", "BOS", 946);
		dt.addAirportPair("JFK", "DEL", 20078);
		dt.addAirportPair("JFK", "SFO", 2578);
		dt.addAirportPair("DEN", "SEA", 1022);
		dt.addAirportPair("ORD", "ORD", 885);
		dt.addAirportPair("ORD", "BOS", 864);
		
		dt.addAirportPair("HON", "ANT", 50000);
		dt.addAirportPair("AUK", "MN", 100025);
		dt.addAirportPair("SEA", "TMN", 80000);
	}
	
	/**
	 * Create frequent flyers for the test.
	 *
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception
	{
		flyer1 = new FrequentFlyer("F0001");
		flyer2 = new FrequentFlyer("F0002");
		flyer3 = new FrequentFlyer("F0003");
		flyer4 = new FrequentFlyer("F0004");
		flyer5 = new FrequentFlyer("F0005");
		flyer6 = new FrequentFlyer("F0006");
		flyer7 = new FrequentFlyer("F0007");
		flyer8 = new FrequentFlyer("F0008");
		flyer9 = new FrequentFlyer("F0009");
		
		flyerBasic = new FrequentFlyer("F0010");
		flyerSilver = new FrequentFlyer("F0011");
		flyerGold = new FrequentFlyer("F0012");
		flyerPlatinum = new FrequentFlyer("F0013");
		FFTransaction.resetTransactionNumbers();
		pointsRem8 = 0;
		pointsRem9 = 0;
	}
	
	/**
	 * Tests getter for Frequent Flyer ID
	 */
	@Test
	public void idIsCorrect()
	{
		assertEquals("F0001", flyer1.getFrequentFlyerId());
	}
	

	/**
	 * Tests that initial level for a Frequent Flyer is BASIC
	 */
	@Test
	public void initialLevelIsBasic()
	{
		assertEquals(FrequentFlyerLevel.BASIC, flyer2.getFrequentFlyerLevel());
	}
	

	/**
	 * Tests recordFlight
	 */
	@Test
	public void basicMemberFlightUpdatesPoints()
	{
		assertEquals(20078, flyer1.recordFlight("JFK", "DEL"));
	}

	/**
	 * Extensive tests for recordFlight
	 * Tests all the different combinations of Frequent Flyers
	 */
	@Test
	public void enterFlightChangingLevels()
	{
		//Tests BASIC->BASIC
		flyerBasic.adjustMilesFlown(10000);
		flyerBasic.recordFlight("ORD", "BOS");
		assertEquals(FrequentFlyerLevel.BASIC, flyerBasic.getFrequentFlyerLevel());
		assertEquals(10864, flyerBasic.getPointsAvailable());
				
		//Tests BASIC->SILVER
		flyer1.adjustMilesFlown(24900);
		flyer1.recordFlight("BOS", "EWR");
		assertEquals(FrequentFlyerLevel.SILVER, flyer1.getFrequentFlyerLevel());
		assertEquals(25125, flyer1.getPointsAvailable());
		
		//Tests BASIC->GOLD
		flyer2.recordFlight("HON", "ANT");
		assertEquals(FrequentFlyerLevel.GOLD, flyer2.getFrequentFlyerLevel());
		assertEquals(56250, flyer2.getPointsAvailable());
		
		//Tests BASIC->PLATINUM
		flyer3.recordFlight("AUK", "MN");
		assertEquals(FrequentFlyerLevel.PLATINUM, flyer3.getFrequentFlyerLevel());
		assertEquals(131300, flyer3.getPointsAvailable());
		
		//Tests SILVER->SIILVER
		flyerSilver.adjustMilesFlown(30000);
		flyerSilver.recordFlight("ORD", "BOS");
		assertEquals(FrequentFlyerLevel.SILVER, flyerSilver.getFrequentFlyerLevel());
		assertEquals(32330, flyerSilver.getPointsAvailable());
		
		//Tests SILVER->GOLD
		flyer4.adjustMilesFlown(49801);
		flyer4.recordFlight("BOS", "EWR");
		assertEquals(FrequentFlyerLevel.GOLD, flyer4.getFrequentFlyerLevel());
		assertEquals(56251, flyer4.getPointsAvailable());
		
		//Tests SILVER->PLATINUM
		flyer5.adjustMilesFlown(49000);
		flyer5.recordFlight("SEA", "TMN");
		assertEquals(FrequentFlyerLevel.PLATINUM, flyer5.getFrequentFlyerLevel());
		assertEquals(189250, flyer5.getPointsAvailable());

		//Tests GOLD->GOLD
		flyerGold.adjustMilesFlown(60000);
		flyerGold.recordFlight("ORD", "BOS");
		assertEquals(FrequentFlyerLevel.GOLD, flyerGold.getFrequentFlyerLevel());
		assertEquals(72546, flyerGold.getPointsAvailable());
				
		//Tests GOLD->PLATINUM
		flyer6.adjustMilesFlown(99814);
		flyer6.recordFlight("BOS", "JFK");
		assertEquals(FrequentFlyerLevel.PLATINUM, flyer6.getFrequentFlyerLevel());
		assertEquals(131252, flyer6.getPointsAvailable());
		
		//Tests PLATINUM->PLATINUM
		flyerPlatinum.adjustMilesFlown(150000);
		flyerPlatinum.recordFlight("ORD", "BOS");
		assertEquals(FrequentFlyerLevel.PLATINUM, flyerPlatinum.getFrequentFlyerLevel());
		assertEquals(232978, flyerPlatinum.getPointsAvailable());
		
	}
	
	/**
	 * Tests getTransactionHistory
	 */
	@Test
	public void historyTransactionIsCorrect()
	{
		flyer1.recordFlight("BOS", "EWR");
		Iterator<FFTransaction> history = flyer1.getTransactionHistory();
		assertTrue(history.hasNext());
		FFTransaction fft = history.next();
		assertEquals("BOS", fft.getFrom());
		assertEquals("EWR", fft.getTo());
		assertEquals(1, fft.getTransactionNumber());
		assertEquals(200.0, fft.getTransactionAmount(), 0.0001);
	}
	
	/**
	 * Tests adjustPoints 
	 */
	@Test
	public void adjustPointsTest()
	{
		flyer7.adjustBalance(25001);
		Iterator<FFTransaction> history = flyer7.getTransactionHistory();
		assertTrue(history.hasNext());
		FFTransaction fft = history.next();
		assertEquals("ADJUST", fft.getFrom());
		assertEquals("", fft.getTo());
		assertEquals(1, fft.getTransactionNumber());
		assertEquals(25001.0, fft.getTransactionAmount(), 0.0001);
	}
	
	/**
	 * Tests redeemPoints for the case where a Frequent Flyer has enough points to book a flight
	 * Also tests the updating of the Frequent Flyer's points after flight is booked.
	 */
	@Test 
	public void redeemPointsPassTest()
	{
		flyer8.adjustBalance(2001);
		try {
			pointsRem8 = flyer8.redeemPoints("EWR", "BOS");
			assertEquals(1, pointsRem8);
			Iterator<FFTransaction> history8 = flyer8.getTransactionHistory();
			assertTrue(history8.hasNext());
			FFTransaction fft8 = history8.next();
			fft8 = history8.next();
			assertEquals("EWR", fft8.getFrom());
			assertEquals("BOS", fft8.getTo());
			assertEquals(2, fft8.getTransactionNumber());
			assertEquals(-2000, fft8.getTransactionAmount(), 0.0001);
		} catch (InsufficientPointsException e) {
			assertEquals(e.getMessage(), "You do not have enough points in your account for this booking!");
		}
	}

	/**
	 * Tests redeemPoints for the case where a Frequent Flyer does not have 
	 * enough points to book a flight
	 */
	@Test (expected = InsufficientPointsException.class)
	public void redeemPointsFailTest()
	{
		//test if flyer with not enough points will be denied
		flyer9.adjustBalance(1);
		int existingPoints = flyer9.getPointsAvailable();
		
		try {
			pointsRem9 = flyer9.redeemPoints("EWR", "BOS");
		} catch (InsufficientPointsException e) {
			assertEquals(e.getMessage(), "You do not have enough points in your account for this booking!");
			//check that points did not change if unsuccessful transaction
			assertEquals(existingPoints, flyer9.getPointsAvailable());
		}		

		
	}
}

