package cs3733.hw2;

import static org.junit.Assert.*;

import org.junit.Test;

/**
 * Tests for the RomanArabicConverter class
 * Modified as part of the Test Driven Development Assignment
 * for the course CS3733 taken at the Worcester Polytechnic Institute
 * in D term, 2013.
 * 
 * @author Tushar Narayan
 * 
 * @version: April 8, 2013
 */
public class RomanArabicConverterTest {
	RomanArabicConverter cv;
	RomanArabicConverter cv2;
	RomanArabicConverter cv3;

	@Test(expected=MalformedNumberException.class)
	public void malformedNumberArgumentTest1() throws MalformedNumberException{
		cv = new RomanArabicConverter("+-Q");
	}

	@Test(expected=MalformedNumberException.class)
	public void malformedNumberArgumentTest2() throws MalformedNumberException{
		cv = new RomanArabicConverter("Qaaa9");
	}

	@Test(expected=MalformedNumberException.class)
	public void malformedNumberArgumentTest3() throws MalformedNumberException{
		cv = new RomanArabicConverter("90z");
	}

	@Test
	public void goodNumberArgumentTest1() throws MalformedNumberException{
		cv = new RomanArabicConverter("42");
	}

	@Test
	public void goodNumberArgumentTest2() throws MalformedNumberException{
		cv = new RomanArabicConverter("XV");
	}

	@Test
	public void goodNumberArgumentTest3() throws MalformedNumberException{
		cv = new RomanArabicConverter("+2");
	}

	@Test
	public void goodNumberArgumentTest4() throws MalformedNumberException{
		cv = new RomanArabicConverter("-77");
	}

	@Test
	public void toArabicTest1() throws MalformedNumberException{
		cv = new RomanArabicConverter("92");
		assertEquals(cv.toArabic(), 92);
	}

	@Test
	public void toArabicTest2() throws MalformedNumberException{
		cv = new RomanArabicConverter("-90");
		assertEquals(cv.toArabic(), -90);
	}

	@Test
	public void toArabicTest3() throws MalformedNumberException{
		cv = new RomanArabicConverter("MDCLXVI");
		assertEquals(cv.toArabic(), 1666);
	}

	@Test
	public void toArabicTest4() throws MalformedNumberException{
		cv = new RomanArabicConverter("CCVII");
		cv2 = new RomanArabicConverter("MLXVI");
		assertEquals(cv.toArabic(), 207);
		assertEquals(cv2.toArabic(), 1066);
	}

	@Test
	public void toArabicTest5() throws MalformedNumberException{
		cv = new RomanArabicConverter("IV");
		cv2 = new RomanArabicConverter("IX");
		assertEquals(cv.toArabic(), 4);
		assertEquals(cv2.toArabic(), 9);
	}

	@Test
	public void toArabicTest6() throws MalformedNumberException{
		cv = new RomanArabicConverter("XL");
		cv2 = new RomanArabicConverter("XC");
		cv3 = new RomanArabicConverter("X");
		assertEquals(cv.toArabic(), 40);
		assertEquals(cv2.toArabic(), 90);
		assertEquals(cv3.toArabic(), 10);
	}

	@Test
	public void toArabicTest7() throws MalformedNumberException{
		cv = new RomanArabicConverter("CD");
		cv2 = new RomanArabicConverter("CM");
		cv3 = new RomanArabicConverter("C");
		assertEquals(cv.toArabic(), 400);
		assertEquals(cv2.toArabic(), 900);
		assertEquals(cv3.toArabic(), 100);
	}
	
	@Test
	public void toArabicTest8() throws MalformedNumberException{
		cv = new RomanArabicConverter("CMXCIX");
		assertEquals(cv.toArabic(), 999);
	}
	
	@Test
	public void toArabicTest9() throws MalformedNumberException{
		cv = new RomanArabicConverter("MMMCMXCIX");
		assertEquals(cv.toArabic(), 3999);
	}
	
	@Test
	public void toArabicTest10() throws MalformedNumberException{
		cv = new RomanArabicConverter("MMMM");
		assertEquals(cv.toArabic(), 4000);
	}
	
	@Test
	public void toArabicTest11() throws MalformedNumberException{
		cv = new RomanArabicConverter("MMMCCCXXXIII");
		assertEquals(cv.toArabic(), 3333);
	}

	@Test
	public void toRomanTest1() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("XX");
		assertEquals(cv.toRoman(), "XX");
	}

	@Test
	public void toRomanTest2() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("4");
		assertEquals(cv.toRoman(), "IV");
	}
	
	@Test
	public void toRomanTest3() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("3999");
		assertEquals(cv.toRoman(), "MMMCMXCIX");
	}
	
	@Test
	public void toRomanTest4() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("12");
		assertEquals(cv.toRoman(), "XII");
	}
	
	@Test
	public void toRomanTest5() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("3");
		assertEquals(cv.toRoman(), "III");
	}
	
	@Test
	public void toRomanTest6() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("10");
		assertEquals(cv.toRoman(), "X");
	}
	
	@Test
	public void toRomanTest7() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("1111");
		assertEquals(cv.toRoman(), "MCXI");
	}
	
	@Test
	public void toRomanTest8() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("999");
		assertEquals(cv.toRoman(), "CMXCIX");
	}
	
	@Test
	public void toRomanTest9() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("1944");
		assertEquals(cv.toRoman(), "MCMXLIV");
	}
	
	@Test
	public void toRomanTest10() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("3033");
		assertEquals(cv.toRoman(), "MMMXXXIII");
	}
	
	@Test
	public void toRomanTest11() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("3333");
		assertEquals(cv.toRoman(), "MMMCCCXXXIII");
	}
	
	@Test(expected=ValueOutOfBoundsException.class)
	public void outOfBoundsValueTest1() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("0");
		assertEquals(cv.toRoman(), "");
	}
	
	@Test(expected=ValueOutOfBoundsException.class)
	public void outOfBoundsValueTest2() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("4000");
		assertEquals(cv.toRoman(), "MMMM");
	}
	
	@Test(expected=ValueOutOfBoundsException.class)
	public void outOfBoundsValueTest3() throws MalformedNumberException, ValueOutOfBoundsException{
		cv = new RomanArabicConverter("5000");
		assertEquals(cv.toRoman(), "MMMMM");
	}

}
