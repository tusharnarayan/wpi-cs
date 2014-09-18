Tushar Narayan
tnarayan@wpi.edu
Project 4

Part 1:
2) Rate of growth in number of comparisons:
The divide and conquer approach of the algorithms leads to a running time
of Big Theta(log n).

3) Yes, the same code can be used to find a local maximum even if the
array is not unimodal in certain cases. The code will only find the
first local maximum of the part of the array that resembles a unimodal
array. All the other local maximums in the array (assuming it is not a
unimodal array) will be ignored.

It will also not work in the case where the array has the same modal
number as consecutive elements.

Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> a = {10, 9, 8, 7, 6}
> b= {1, 2, 3, 4, 5, 9}
> c = {1, 3, 5, 4, 2}
> d = {1, 3, 5, 7, 6, 7, 4, 2}
> result = uni_max(a)
> print(result)
10
> result = uni_max(b)
> print(result)
9
> result = uni_max(c)
> print(result)
5
> result = uni_max(d)
> print(result)
7
> e = {1, 3, 5, 7, 9, 9, 2}
> result = uni_max(e)
This function works for unimodal arrays only!


Part 2:
3) The function is linear in n. Has running time of Theta(log n).
Graphing the values in Excel, y = 4E-07x. The R squared value for 5
arbitrary sample points was 0.9652. These measurements are
approximately compatible with the analysis in CLRS.

Extra Credit:
The comparison operators had to be revered to get the minimal subarray.
The addition can be changed to multiplication to get maximal product as
opposed to the sum.
