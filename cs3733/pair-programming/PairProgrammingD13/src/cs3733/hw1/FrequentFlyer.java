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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import cs3733.hw1.FrequentFlyerLevel;
import cs3733.hw1.FFTransaction;
/**
 * Class for a Frequent Flyer
 * 
 * @author gpollice
 * 
 * Edited: Cynthia Rogers and Tushar Narayan
 * as part of the Pair Programming assignment for CS 3733 D term 2013.
 * 
 * @version Mar 19, 2013
 */
public class FrequentFlyer
{
	//Definitions of enumerations
	private static int silverThreshold = 25000;
	private static int goldThreshold = 50000;
	private static int platinumThreshold = 100000;

	//Point multipliers
	private static double basicMultiplier = 1;
	private static double silverMultiplier = 1.25;
	private static double goldMultiplier = 1.5;
	private static double platinumMultiplier = 2;

	private String frequentFlyerId;
	private FrequentFlyerLevel level;
	private int miles;
	private int points;
	private List<FFTransaction> transactions;


	/**
	 * Constructor. The only identification for a frequent flyer is the ID, which will be used by
	 * clients for various purposes.
	 * 
	 * @param frequentFlyerId
	 *            the frequent flyer ID
	 */
	public FrequentFlyer(String frequentFlyerId)
	{
		this.frequentFlyerId = frequentFlyerId;
		this.level = FrequentFlyerLevel.BASIC;
		this.miles = 0;
		this.points = 0;
		this.transactions = new ArrayList<FFTransaction>();
	}

	/**
	 * Record the completion of a flight for the frequent flyer. This should update the flyer's
	 * level and points appropriately. You can assume that the airport codes are valid.
	 * 
	 * This should also create an FFTransaction for this flyer and add it to the end of the
	 * transaction history.
	 * 
	 * @param from
	 *            the source airport's code
	 * @param to
	 *            the destination airport's code
	 * @return the frequent flyer's point level after this flight (truncating any fractions).
	 */
	public int recordFlight(String from, String to)
	{
		DistanceTable DTinstance = DistanceTable.getInstance();
		int newMiles = DTinstance.getDistance(from, to); //miles that will be flown on this flight
		int existingMiles = this.miles; //miles that Frequent Flyer already possesses
		int existingPoints = this.points; //points that Frequent Flyer already possesses
		double newPoints = adjustPointsAndLevel(existingPoints, existingMiles, newMiles); //get points that will be gained from flight
		
		//cast to convert to an integer value (since we are always rounding down, we can just ignore the decimal part)
		this.points = (int) newPoints;
		
		// Now for Transaction History!
		int adjustmentPoints = ((int) newPoints) - existingPoints;
		FFTransaction todayTransaction = new FFTransaction(from, to, adjustmentPoints);
		this.transactions.add(todayTransaction);
		
		return this.points;
	}

	/**
	 * Function that adjusts points and Frequent Flyer level
	 * based on current level and the number of miles that will be flown
	 * (taking into account any change in levels that will occur)
	 * 
	 * @param existingPoints points that Frequent Flyer already possesses
	 * @param existingMiles miles that Frequent Flyer already possesses
	 * @param newMiles miles that will be flown on this flight
	 * @return the amount of points that will be gained from flight (as a double)
	 */
	public double adjustPointsAndLevel(int existingPoints, int existingMiles, int newMiles){
		double newPoints = existingPoints; //do the calculation as a double, since point multipliers are doubles
		int difference_below = 0; //will hold number of miles required to cross the next closest level threshold
		int difference_above = 0; //will hold the number of miles that will be flown as being a member of the next threshold
		int totalMiles = newMiles + existingMiles;

		//Check if Frequent Flyer went over to next bracket of miles:
		
		//Check if went into Platinum
		if (totalMiles >= platinumThreshold)
		{
			//Now check the current level
			//Points have to be awarded on this basis
			if (this.level == FrequentFlyerLevel.GOLD)
			{
				this.level = FrequentFlyerLevel.PLATINUM;
				difference_below = platinumThreshold - existingMiles;
				difference_above = totalMiles - platinumThreshold;
				newPoints += (difference_below * goldMultiplier) +
						(difference_above * platinumMultiplier);

			}
			else if (this.level == FrequentFlyerLevel.SILVER)
			{
				this.level = FrequentFlyerLevel.PLATINUM;
				difference_below = goldThreshold - existingMiles;
				difference_above = totalMiles - platinumThreshold;
				newPoints += (difference_below * silverMultiplier) + 
						(goldMultiplier*goldThreshold)+
						(difference_above * platinumMultiplier);

			}
			else if (this.level == FrequentFlyerLevel.BASIC)
			{
				this.level = FrequentFlyerLevel.PLATINUM;
				difference_below = silverThreshold- existingMiles;
				difference_above = totalMiles - platinumThreshold;
				newPoints += (difference_below * basicMultiplier) + 
						(silverThreshold * silverMultiplier) + 
						(goldMultiplier*goldThreshold)+
						(difference_above * platinumMultiplier);

			}
			else
			{
				newPoints += (newMiles * platinumMultiplier);
			}
		}
		//Check if went into Gold
		else if (totalMiles >= goldThreshold)
		{
			if (this.level == FrequentFlyerLevel.SILVER)
			{
				this.level = FrequentFlyerLevel.GOLD;
				difference_below = goldThreshold - existingMiles;
				difference_above = totalMiles - goldThreshold;
				newPoints += (difference_below * silverMultiplier) +
						(difference_above * goldMultiplier);

			}
			else if (this.level == FrequentFlyerLevel.BASIC)
			{
				this.level = FrequentFlyerLevel.GOLD;
				difference_below = silverThreshold - existingMiles;
				difference_above = totalMiles - goldThreshold;
				newPoints += (difference_below * basicMultiplier) + (silverThreshold * silverMultiplier) +
						(difference_above * goldMultiplier);

			}
			else
			{
				newPoints += (newMiles * goldMultiplier);
			}
		}
		//Check if went into Silver
		else if (totalMiles >= silverThreshold)
		{
			if (this.level == FrequentFlyerLevel.BASIC)
			{
				this.level = FrequentFlyerLevel.SILVER;
				difference_below = silverThreshold - existingMiles;
				difference_above = totalMiles - silverThreshold;
				newPoints += (difference_below * basicMultiplier) +
						(difference_above * silverMultiplier);

			}
			else
			{
				newPoints += (newMiles * silverMultiplier);
			}
		}
		//Else the Frequent Flyer is still Basic
		else
		{
			newPoints += (newMiles * basicMultiplier);
		}
		return newPoints;
	}
	
	/**
	 * Redeem points to pay for a flight. As long as there are enough points in the account to cover
	 * the cost of the flight (10 points per mile), the points are removed from the flyer's
	 * available total.
	 * 
	 * This should also create an FFTransaction for this flyer and add it to the end of the
	 * transaction history.
	 * 
	 * @param from
	 *            the source airport's code
	 * @param to
	 *            the destination airport's code
	 * @returnthe frequent flyer's point level after this redemption (truncating any fractions).
	 * @throws InsufficientPointsException if there not enough points to pay for the flight
	 */
	public int redeemPoints(String from, String to)
			throws InsufficientPointsException
			{
				DistanceTable DTinstance = DistanceTable.getInstance();
				int milesRequested = DTinstance.getDistance(from, to); //miles that the flight covers
				int pointsRequested = 10 * milesRequested; //points required for the requested flight
				int pointsInAccount = this.points; //points Frequent Flyer currently possesses
				if(pointsInAccount >= pointsRequested)
				{
					//enough points are available!
					
					//update points in account
					this.points -= pointsRequested;
					
					//create transaction
					FFTransaction todayTransaction = new FFTransaction(from, to, (0-pointsRequested));
					this.transactions.add(todayTransaction);
				}
				else
				{
					//not enough points available!
					
					throw new InsufficientPointsException("You do not have enough points in your account for this booking!");
				}
				
				return this.points;
			}

	/**
	 * This method is used by the airline to adjust the frequent flyer's points
	 * This can be done to compensate the flyer for inconveniences, award bonuses,
	 * or make any other adjustment.
	 * 
	 * This will also add a FFTransaction to the flyer's history. The transaction
	 * will have a <code>from</code> string of "ADJUST" and a null <code>to</code>
	 * string.
	 *
	 * @param adjustment the amount to be added to the points (can be negative)
	 * @return the resulting points available for this flyer, truncating any 
	 * 	fractional points.
	 */
	public int adjustBalance(int adjustment)
	{
		//update points
		this.points += adjustment;
		
		//add to transaction history
		String from = "ADJUST";
		String to = "";
		FFTransaction todayTransaction = new FFTransaction(from, to, adjustment);
		this.transactions.add(todayTransaction);	
		
		return this.points;
	}

	/**
	 * This method is used by the airline to adjust the number of miles flown by the
	 * frequent flyer. It's similar to adjustBalance, but it adjusts the miles rather
	 * than the points. This does, however, adjust the points (and possibly the 
	 * level) appropriately. 
	 * 
	 * @param the mileage adjustment
	 * @return the resulting points (not miles) available for this flyer, truncating
	 * 	any fractional points.
	 */
	public int adjustMilesFlown(int adjustment)
	{
		//adjust points and level appropriately
		int existingMiles = this.miles;
		int existingPoints = this.points;
		double newPoints = adjustPointsAndLevel(existingPoints, existingMiles, adjustment);
		//update points
		this.points = (int) newPoints;
		
		//update miles
		this.miles += adjustment;
		
		//add to transaction history
		int adjustmentPoints = ((int) newPoints) - existingPoints;
		String from = "ADJUST";
		String to = "";
		FFTransaction todayTransaction = new FFTransaction(from, to, adjustmentPoints);
		this.transactions.add(todayTransaction);	
		
		return this.points;
	}

	/**
	 * Return an iterator to the transaction history. This should return an iterator
	 * to the collection of FFTransactions for this frequent flyer. The iterator should
	 * return the transactions in the order in which they were added to the flyer's 
	 * history (that is the oldest transaction first).
	 * @return
	 */
	public Iterator<FFTransaction> getTransactionHistory()
	{
		//ArrayListIterator
		Iterator<FFTransaction> TransactionIterator = this.transactions.iterator();
		
		return TransactionIterator;
	}

	/**
	 * @return the points available for this flyer, truncating any fractional points.
	 */
	public int getPointsAvailable()
	{
		return this.points;
	}

	/**
	 * @return this frequent flyer's current level
	 */
	public FrequentFlyerLevel getFrequentFlyerLevel()
	{
		return this.level;
	}

	/**
	 * @return the frequent flyer ID
	 */
	public String getFrequentFlyerId()
	{
		return this.frequentFlyerId;
	}
}
