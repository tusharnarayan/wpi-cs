/*******************************************************************************
 * Copyright (c) 2012 Gary F. Pollice
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
/**
 * @modified: Tushar Narayan
 * Modified as part of the Test Driven Development Assignment
 * for the course CS3733 taken at the Worcester Polytechnic Institute
 * in D term, 2013.
 * 
 * @version: April 8, 2013
 */
package cs3733.hw2;

import java.util.regex.Pattern;

/**
 * <p>
 * This class implements a converter that takes a string that represents
 * a number in either Arabic or Roman numeral form and offers methods that
 * will return either the integer value or a string representing the value in
 * Roman numeral form.
 * </p><p>
 * Roman numerals are specified and presented as strings according to the 
 * <a href="http://en.wikipedia.org/wiki/Roman_numerals#Reading_Roman_numerals">
 * Reading Roman Numerals</a> section of the Wikipedia Roman Numerals Page.
 * </p>
 */
public class RomanArabicConverter
{
	private String inputValue; //the string passed
	private String type; //represents type of number - Roman or Arabic

	/**
	 * Constructor that takes in a string. The string should contain either
	 * a valid Roman numeral or a valid Arabic numeral. The string can have leading
	 * and/or trailing spaces. There are no spaces within the actual number characters.
	 * If the string represents an Arabic number, it may be positive or negative. It will
	 * never be larger than a value that can fit into a 
	 * 
	 * @param value the string representing the Roman or Arabic number.
	 * @throws MalformedNumberException if the string (less leading and trailing
	 * 	spaces does not represent a valid Roman or Arabic number.
	 */
	public RomanArabicConverter(String value) throws MalformedNumberException
	{
		this.inputValue = null;
		//check if passed input is a valid Roman or Arabic number
		if((Pattern.matches("[0-9-]+", value)) /*contains only numerics and/or a positive sign*/
				|| 
				(Pattern.matches("[0-9+]+", value))) {/*contains only numerics and/or a negative sign*/
			this.inputValue = value;
			//trim spaces from lead and trail
			this.inputValue = this.inputValue.trim();
			//save type
			this.type = "Arabic";
		}
		else if	(Pattern.matches("[IVXLCDM]+", value)){ /*contains only Roman Numeral symbols*/
			this.inputValue = value;
			//trim spaces from lead and trail
			this.inputValue = this.inputValue.trim();
			//save type
			this.type = "Roman";
		}
		else throw new MalformedNumberException("Your string did not contain a valid Roman or Arabic number!");
	}

	/**
	 * @return the integer value of the number given 
	 */
	public int toArabic()
	{
		if(this.type.equals("Arabic")) return Integer.parseInt(this.inputValue);
		else{ //is a (valid) Roman numeral, must parse to get Arabic number value
			/*	Roman Numeral representations:
			 * 	I	1
			 * 	V	5
			 * 	X	10
			 * 	L	50
			 * 	C	100
			 * 	D	500
			 * 	M	1,000
			 *  subtractive notation (IV = 4, XC = 90, and so on) used
			 */
			int convertedValue = 0; //to save the converted value
			char[] input = this.inputValue.toCharArray(); //to iterate over each character of the Roman number input
			for(int i = 0; i < input.length; i++){
				if(input[i] == 'I'){
					//checks for special cases of IV and IX
					if(i+1 < input.length){
						if(input[i+1] == 'V'){
							convertedValue += 4;
							i++;
						}
						else if(input[i+1] == 'X'){
							convertedValue += 9;
							i++;
						}
						else
							convertedValue += 1;
					}
					else
						convertedValue += 1;
				}
				else if(input[i] == 'V')
					convertedValue += 5;
				else if(input[i] == 'X'){
					//checks for special cases of XL and XC
					if(i+1 < input.length){
						if(input[i+1] == 'L'){
							convertedValue += 40;
							i++;
						}
						else if(input[i+1] == 'C'){
							convertedValue += 90;
							i++;
						}
						else
							convertedValue += 10;
					}
					else
						convertedValue += 10;
				}
				else if(input[i] == 'L')
					convertedValue += 50;
				else if(input[i] == 'C'){
					//checks for special cases of CD and CM
					if(i+1 < input.length){
						if(input[i+1] == 'D'){
							convertedValue += 400;
							i++;
						}
						else if(input[i+1] == 'M'){
							convertedValue += 900;
							i++;
						}
						else
							convertedValue += 100;
					}
					else
						convertedValue += 100;
				}
				else if(input[i] == 'D')
					convertedValue += 500;
				else //input[i] == 'M'
					convertedValue += 1000;
			}
			return convertedValue;
		}
	}

	/**
	 * @return the string that represents the value of the number as a 
	 * 	Roman numeral.
	 * @throws ValueOutOfBoundsException if the number is too small or too large
	 * 	to be represented using Roman numerals as specified in 
	 *  <a href="http://en.wikipedia.org/wiki/Roman_numerals#Reading_Roman_numerals">
	 *  Reading Roman Numerals</a>
	 */
	public String toRoman() throws ValueOutOfBoundsException
	{
		if(this.type.equals("Roman")) return this.inputValue;
		else{//is a (valid) Arabic number, must parse to get Roman numeral string
			int integralInputValue = Integer.parseInt(this.inputValue);
			/*	Roman numeral representations:
			 * 	I	1
			 * 	V	5
			 * 	X	10
			 * 	L	50
			 * 	C	100
			 * 	D	500
			 * 	M	1,000
			 * Largest Roman Numeral represented without repeat is MMMCMXCIX (or 3999), since 4000 is MMMM
			 * Smallest Romal Numeral represented is I (or 1)
			 */
			if(integralInputValue < 1 || integralInputValue > 3999) throw new ValueOutOfBoundsException("Input is too big to be represented in Roman Numerals!");
			String convertedValue = "";
			
			//find how many thousands, hundreds, tens and ones are required to represent the number
			//note that the value of the integralInputValue variable is modified
			int numberOfThousands = integralInputValue/1000;
			integralInputValue %= 1000;
			int numberOfHundreds = integralInputValue/100;
			integralInputValue %= 100;
			int numberOfTens = integralInputValue/10;
			integralInputValue %= 10;
			int numberOfOnes = integralInputValue/1;
			integralInputValue %= 1;
			
			//form arrays for the possible range of values for each ten unit increments
			//this takes care of the special cases involving IV, IX, XL, XC, CD, CM
			String romanNumerals_OnesArray[] = {"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"};
			String romanNumerals_TensArray[] = {"X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"};
			String romanNumerals_HundredsArray[] = {"C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"};
			String romanNumerals_ThousandsArray[] = {"M", "MM", "MMM"};
			
			//using number of each, append the appropriate Roman numeral symbols to convertedValue string
			if (numberOfThousands >= 1) convertedValue += romanNumerals_ThousandsArray[numberOfThousands - 1];
			if (numberOfHundreds >= 1) convertedValue += romanNumerals_HundredsArray[numberOfHundreds - 1];
			if (numberOfTens >= 1) convertedValue += romanNumerals_TensArray[numberOfTens - 1];
			if (numberOfOnes >= 1) convertedValue += romanNumerals_OnesArray[numberOfOnes - 1];
			
	        return String.valueOf(convertedValue);
		}
	}
}
