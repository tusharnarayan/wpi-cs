--Tushar Narayan
--tnarayan@wpi.edu
--Project 4

require "util"

-- test harness relies on *global variable* cc
-- assumed also to be embedded in fn_to_test.

-- You will find make_collector defined in
-- the *new* version of "init.lua"
-- in this directory.

cc = util.make_collector()

--

function count_test_harness (fn_to_test, test_arrays)
   local result = {}
   for i = 1, #test_arrays do
      cc.reset()
      fn_to_test(test_arrays[i])
      result[i] = cc.reveal()
      cc.reset()
      io.write(".") ; io.flush()
   end
   return result
end

function make_unimodal_test_arrays(number, width, upper_bound)
   local result = {}
   for i = 1, number do
      result[i] = make_unimodal (width, upper_bound)
   end
   return result
end


-- ----------------
-- unimodal arrays
-- ----------------

-- First, a routine to generate unimodal
-- sample arrays.

function make_unimodal (width, upper_bound)
   local max_val = math.random(upper_bound) -- random maximum
   local pos_max = math.random(width)       -- random position to put it
   local result = {}

   if pos_max<=1                -- insert the first entry
   then
      result[1]=max_val
   else
      result[1] = 0
   end

   for i = 2, width do          -- insert remaining entries
      if i < pos_max
      then                      -- increase last entry by a
         result[i] = result[i-1] + -- reasonable fraction of whats left to max_val
            ((max_val - result[i-1])/(pos_max-i+1))
      else if i == pos_max
         then                   -- time to insert max_val
            result[i] = max_val
         else                   -- decrease proportionally
            result[i] = max_val -
               ((i-pos_max)*max_val / (width-pos_max))
         end
      end
   end
   return result                -- return the array we built
end

-- next, a routine to check if array a
-- is unimodal.  When it stops increasing,
-- it had better never increase again.

function is_unimodal(a)
   local inc_part = true
   for i = 2, #a do
      if a[i] == a[i-1] then return false -- repeated value is not increase!
      else if a[i-1] > a[i]
         then
            if inc_part
            then inc_part=false -- not in increasing part any more!
            end
         else                   -- a[i] is greater!
            if not(inc_part)
            then return false   -- decrease failed
            end
         end
      end
   end
   return true                  -- got to the end with nothing wrong
end

-- The function to find the maximum
-- position.  Only has to work if
-- the given array *a* is really unimodal.

-- Please fill this in using a divide-and-conquer
-- idea.  See instructions in proj2.pdf

function uni_max_rec (a,left,right)
	-- Your code goes here!
	--[[Non-Recursive way:

	while left < right do
		local m = math.floor((left + right)/2)
		if a[m] < a[m + 1] then
			left = m + 1
		end
		if a[m] > a[m + 1] then
			right= m
		end
	end
	return a[left]
	--]]
	cc.inc()
	if left == right then
		return a[left]
	else
		local m = math.floor((left + right)/2)
		cc.inc() --comparison count for if comparison below
		if a[m] < a[m + 1] then
			left = m + 1
			return uni_max_rec(a, left, right)
		elseif a[m] > a[m + 1] then
			cc.inc() --comparison count for elseif
			right= m
			return uni_max_rec(a, left, right)
		else --a[m] == a[m + 1], not a unimodal array!
			cc.inc() --comparison count for elseif occurs here too!
			print("This function works for unimodal arrays only!")
			return false
		end
	end
end

-- a convenient top-level function to
-- start off uni_max_rec with the natural
-- left and right values.

function uni_max(a)
   return uni_max_rec(a,1,#a)
end

--Function to test uni_max using the count_test_harness
--generates 100 unimoda arrays of varying widths and finds
--their max
function test_uni_max()
	local test_arrays = {}
	--make arrays of varying lengths
	for i = 1, 100 do
		test_arrays[i] = make_unimodal(1000*i, 100000)
	end
	--use the provided test harness to test the function
	result = count_test_harness(uni_max, test_arrays)
	print("\n")
	util.print_table(result)
end
--[[
Testing function with specially defined arrays:
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> a = {15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}
> b = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
> c = {10, 20, 30, 40, 50, 40, 30, 20, 10}
> d = {10, 20, 30, 15, 5, 1}
> e = {1, 2, 4, 5, 5, 6, 7}
> print(uni_max(a))
15
> print(uni_max(b))
15
> print(uni_max(c))
50
> print(uni_max(d))
30
> print(uni_max(e))
This function works for unimodal arrays only!
false


Single command to test the function: test_uni_max()
(number of comparisons)
Output:
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> test_uni_max()
................................................................................
....................

1       ,       22
2       ,       31
3       ,       29
4       ,       31
5       ,       35
6       ,       31
7       ,       36
8       ,       38
9       ,       36
10      ,       36
11      ,       39
12      ,       34
13      ,       38
14      ,       32
15      ,       36
16      ,       38
17      ,       35
18      ,       36
19      ,       35
20      ,       38
21      ,       41
22      ,       39
23      ,       39
24      ,       38
25      ,       41
26      ,       38
27      ,       39
28      ,       33
29      ,       38
30      ,       40
31      ,       38
32      ,       41
33      ,       37
34      ,       41
35      ,       39
36      ,       33
37      ,       38
38      ,       39
39      ,       36
40      ,       38
41      ,       38
42      ,       39
43      ,       43
44      ,       39
45      ,       37
46      ,       40
47      ,       35
48      ,       42
49      ,       42
50      ,       37
51      ,       38
52      ,       45
53      ,       42
54      ,       44
55      ,       42
56      ,       41
57      ,       46
58      ,       37
59      ,       43
60      ,       40
61      ,       42
62      ,       42
63      ,       40
64      ,       38
65      ,       41
66      ,       39
67      ,       40
68      ,       41
69      ,       40
70      ,       41
71      ,       43
72      ,       41
73      ,       38
74      ,       41
75      ,       42
76      ,       42
77      ,       47
78      ,       39
79      ,       40
80      ,       44
81      ,       49
82      ,       40
83      ,       40
84      ,       40
85      ,       41
86      ,       49
87      ,       40
88      ,       39
89      ,       41
90      ,       42
91      ,       40
92      ,       40
93      ,       47
94      ,       43
95      ,       45
96      ,       40
97      ,       42
98      ,       44
99      ,       45
100     ,       46
--]]


-- Here is a function that defines
-- the idea of a local maximum.

-- assume 1 <= lower <= pos <= upper <= #a.
--
-- Then is_local_max(a,pos,lower,upper) returns true
-- just when a[pos] is strictly greater than a[i]
-- for all i adjacent to pos and within
-- lower <= i <= upper.

function is_local_max(a,pos,lower,upper)
   if lower == upper then return true
   else if pos == lower then return a[pos+1]<a[pos]
      else if pos == upper then return a[pos-1]<a[pos]
         else return (a[pos-1]<a[pos] and a[pos+1]<a[pos])
         end
      end
   end
end

--Part 1 Extra Credit
function find_local_max(a)
	if(is_unimodal(a)) then
		local max_val = uni_max(a)
		print("\nLocal Maximum: ", max_val)
	else
		local is_max = false
		for i = 1, #a do
			is_max = is_local_max(a, i, 1, #a)
			if(is_max) then
				print("\nLocal Maximum at index: ", i, a[i])
			end
		end
		if (is_max == false) then
			print("\nNo local max!")
		end
	end
end
--[[Test:
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> find_local_max({1, 2, 3, 5, 4})

Local Maximum:  5
> find_local_max({1, 2, 3, 5, 6, 7})

Local Maximum:  7
> find_local_max({8, 2, 3, 5, 6, 7})

Local Maximum at index:         1       8

Local Maximum at index:         6       7
--]]

-- maximum subarray


-- Here is the brute-force procedure.
-- It should be simple to write, and it
-- does not have to be efficient.  Use it
-- to compare timings, and especially to make
-- sure that your recursive, divide-and-conquer
-- algorithm is giving the same results.

function find_maximum_subarray_brute_force(a, left, right)
   -- place your code here!

   --initialize variables
   local max_so_far = a[1]
   local max_here = a[1]
   local l_left = 1
   local l_right = 1

	--loop through array, find required sequence
	for i = 1, #a do
		for j = 1, #a do
			max_here = 0
			-- calculate sum of current subarray
			for k = i, j do max_here = max_here + a[k] end
			-- is this the maximum sum encountered thus far?
			if max_here > max_so_far then
				max_so_far = max_here
				l_left = i
				l_right = j
			end
		end
	end

	--[[Alternative version - doesn't give the correct start index
	However, is vastly more efficient in computing sum and final index

   for i = 1, #a do
		max_here = max_here + a[i]
		if(a[i] > max_here) then
			max_here = a[i]
			l_left = i
		end
		if(max_here > max_so_far) then
			max_so_far = max_here
			l_right = i
		end
	end
	--]]

	--standardize outputs in case of negative sums
	if(max_so_far <= 0) then
		l_left = 0
		l_right = 0
		max_so_far = 0
	end

   return l_left, l_right, max_so_far
end

--[[Tests:
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
> b = {-10, -9, -8, -7, -6, -5, -4, -3, -2, -1}
> c = {-2, 1, -3, 4, -1, 2, 1, -5, 4}
> d = {10, 20, 40, -110, 1}
> print(find_maximum_subarray_brute_force(a, 1, #a))
1       10      55
> print(find_maximum_subarray_brute_force(b, 1, #b))
0       0       0
> print(find_maximum_subarray_brute_force(c, 1, #c))
4       7       6
> print(find_maximum_subarray_brute_force(d, 1, #d))
1       3       70
--]]

-- Procedure to find a maximum array that
-- lies within left and right, and actually
-- crosses the midpoint mid.

function find_max_crossing(a,left,mid,right)

   -- Place your Theta(right-left) code
   -- to compute the start, end, and sum of the
   -- maximum array that crosses the midpoint.

   -- return your information in this form,
   -- to make available all three parts:

	--find max subaray of form a[i..m]
	local left_sum = -math.huge --negative infinity
	local sum = 0
	local max_left= 0 --storing index

	-- process left subarray
	for i = mid, left, -1 do
		sum = sum + a[i]
		cc.inc()
		if sum > left_sum then
			left_sum = sum
			max_left = i
		end
	end

	--find max subarray of form a[m+1..j]
	local right_sum = -math.huge --negative infinity
	sum = 0
	local max_right = 0 --storing index

	-- process right subarray
	for j = mid + 1, right do
		sum = sum + a[j]
		cc.inc()
		if sum > right_sum then
			right_sum = sum
			max_right = j
		end
	end

   return max_left, max_right, (left_sum + right_sum)
end


-- Here is the recursive procedure to fill in,
-- using a divide-and-conquer strategy.  Its
-- runtime should end up as Theta(n log n).


function find_maximum_subarray_rec(a, left, right)

   -- place your code here!
   -- You can use this format to retrieve
   -- multiple values from a recursive call:

   -- local l_start, l_end, l_max_internal =
   --   find_maximum_subarray_rec(a,left,mid)

   cc.inc()
	if left == right then --base case, array has only single element
		return left, right, a[left]
	else
		local m = math.floor((left + right)/2)
		local l_left, l_right, l_max_sum = find_maximum_subarray_rec(a, left, m)
		local r_left, r_right, r_max_sum = find_maximum_subarray_rec(a, m + 1, right)
		local c_left, c_right, c_max_sum = find_max_crossing(a, left, m, right)
		-- find maximum from the three halves
		cc.inc() --comparison count for if
		if l_max_sum >= r_max_sum and l_max_sum >= c_max_sum then
			return l_left, l_right, l_max_sum
		elseif r_max_sum >= l_max_sum and r_max_sum >= c_max_sum then
			cc.inc() --comparison count for elseif
			return r_left, r_right, r_max_sum
		else
			cc.inc() --comparison count for elseif occurs here too!
			return c_left, c_right, c_max_sum
		end
	end
end

-- Here is a convenient top-level call
-- to start the recursive procedure on the
-- array as a whole.

function find_maximum_subarray(a)
   left, right, sum = find_maximum_subarray_rec(a, 1, #a)

   --standardize outputs in case of negative sums
	if(sum <= 0) then
		left = 0
		right = 0
		sum = 0
	end

	return left, right, sum
end

--[[Tests
Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
> require "proj4"
> a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
> b = {-10, -9, -8, -7, -6, -5, -4, -3, -2, -1}
> c = {-2, 1, -3, 4, -1, 2, 1, -5, 4}
> d = {10, 20, 40, -110, 1}
> print(find_maximum_subarray(a))
1       10      55
> print(find_maximum_subarray(b))
0       0       0
> print(find_maximum_subarray(c))
4       7       6
> print(find_maximum_subarray(d))
1       3       70
--]]

-- here is a function you can use to generate
-- a random array of real numbers.  The resulting
-- array will be of length "length".  Its entries
-- will be bounded in absolute value by max_abs.

function make_random_real_array(length, max_abs)
   local result = {}
   local m = 2*max_abs

   for i = 1, length do
      result[i] = (math.random() - .5) * m
   end
   return result
end

-- you can use this procedure to generate random arrays and to test
-- find_maximum_subarray and find_maximum_subarray_brute_force on
-- them.

-- When it finds an array where they give different values, it raises
-- an error, and it stores the array in the global variable "array".

function test_max_subarray(length, max_abs, num)
   if 0 < num then
		local a = make_random_real_array(length, max_abs)
		local s,e,m = find_maximum_subarray(a,1,#a)
		local s1,e1,m1 = find_maximum_subarray_brute_force(a,1,#a)
		if s == s1 and e == e1 then
			util.write_dot()
		else
			array = a
			print(" found failure, stored in array")
		end
		test_max_subarray(length, max_abs, num-1)
	else
		print("done.")
	end
end

--Function to count complexity and runtime for find_maximum_subarray
function test_max_dc()
	local times = {}
	local results = {}
	local variation = {}
	local t1, t2

	--make arrays of varying lengths
	for i = 1, 150 do
		cc.reset()
		t1 = os.clock()
		find_maximum_subarray(make_random_real_array(i*1000, 100))
		t2 = os.clock()
		results[i] = cc.reveal()
		times[i] = t2 - t1
		variation[i] = times[i]/results[i]
		print(i, "\t", results[i], "\t", times[i])
		cc.reset()
		io.write("") ; io.flush()
   end

   print("\nRuntime as function of size:\n")
   for k,v in pairs(variation) do
      print(v, "\t")
   end


	print("\n")
end
--[[Tests (number of comparisons and time taken):
--Test 1: to find comparisons and times (500 arrays):
204                     4352243                 1.364
205                     4374537                 1.563
206                     4397693                 1.279
207                     4420290                 1.284
208                     4442687                 1.323
209                     4465717                 1.333
210                     4488553                 1.361
211                     4511263                 1.341
212                     4533679                 1.319
213                     4557110                 1.385
214                     4579209                 1.343
215                     4602589                 1.449
216                     4624840                 1.422
217                     4647416                 1.423
218                     4670075                 1.509
219                     4693450                 1.535
220                     4715876                 1.528
221                     4738565                 1.506
222                     4761359                 1.408
223                     4784373                 1.439
224                     4807266                 1.436
225                     4829707                 1.463
226                     4852455                 1.511
227                     4875730                 1.514
228                     4898393                 1.464
229                     4921320                 1.582
230                     4944032                 1.704
231                     4966837                 1.87
232                     4989586                 2.05
233                     5012445                 2.071
234                     5034997                 2.012
235                     5058381                 2.04
236                     5081175                 1.795
237                     5103592                 1.71
238                     5126586                 1.77
239                     5149600                 1.989
240                     5172592                 2.393
241                     5195310                 2.123
242                     5217954                 1.994
243                     5240847                 1.878
244                     5263476                 1.827
245                     5286633                 1.826
246                     5309662                 1.911
247                     5332298                 1.812
248                     5355058                 1.8
249                     5378246                 1.849
250                     5401185                 1.847
251                     5424392                 1.85
252                     5446524                 1.894
253                     5469863                 1.849
254                     5492626                 1.893
255                     5515353                 2.085
256                     5538753                 1.975
257                     5560756                 1.866
258                     5584326                 1.901
259                     5607316                 1.906
260                     5630103                 1.868
261                     5653324                 1.951
262                     5676026                 1.853
263                     5699615                 1.847
264                     5722093                 1.92
265                     5745781                 1.916
266                     5769064                 1.938
267                     5792654                 1.949
268                     5816033                 1.974
269                     5839724                 1.906
270                     5863040                 1.975
271                     5886079                 2.17
272                     5909456                 2.028
273                     5932560                 2.205
274                     5955955                 2.162
275                     5979311                 2.025
276                     6003263                 2.018
277                     6026578                 2.05
278                     6049589                 2.095
279                     6073023                 2.026
280                     6096737                 2.029
281                     6119715                 2.142
282                     6143247                 2.001
283                     6166860                 2.063
284                     6189974                 2.295
285                     6214001                 2.626
286                     6236888                 2.569
287                     6260107                 2.685
288                     6283310                 2.716
289                     6306954                 2.55
290                     6330269                 2.539
291                     6354124                 2.583
292                     6377083                 2.598
293                     6401268                 2.572
294                     6424648                 2.59
295                     6447734                 2.588
296                     6471454                 2.652
297                     6494106                 2.669
298                     6517597                 2.701
299                     6541684                 2.663
300                     6565192                 2.603
301                     6587875                 2.695
302                     6610987                 2.662
303                     6635386                 2.702
304                     6658439                 2.748
305                     6681880                 2.668
306                     6705591                 2.754
307                     6729162                 2.701
308                     6752905                 2.808
309                     6775630                 2.748
310                     6799241                 2.817
311                     6823132                 2.906
312                     6846521                 2.949
313                     6870047                 2.746
314                     6893825                 2.835
315                     6917148                 2.72
316                     6939940                 2.799
317                     6964088                 2.856
318                     6987453                 2.884
319                     7011024                 2.832
320                     7033707                 2.626
321                     7057869                 2.394
322                     7081594                 2.356
323                     7105231                 2.471
324                     7128025                 2.433
325                     7152557                 2.429
326                     7175246                 2.424
327                     7199005                 2.42
328                     7222219                 2.34
329                     7245820                 2.319
330                     7269427                 2.386
331                     7293130                 2.403
332                     7316881                 2.544
333                     7339572                 2.536
334                     7363591                 2.532
335                     7387547                 2.56
336                     7410757                 2.5069999999999
337                     7433832                 2.706
338                     7457657                 2.663
339                     7481188                 2.577
340                     7504872                 2.493
341                     7528148                 2.555
342                     7551840                 2.611
343                     7575476                 2.592
344                     7599440                 2.535
345                     7622699                 2.567
346                     7646404                 2.523
347                     7669663                 2.595
348                     7693388                 2.64
349                     7716990                 2.666
350                     7740287                 2.652
351                     7763904                 2.634
352                     7787682                 2.652
353                     7811126                 2.688
354                     7834824                 2.716
355                     7858936                 2.753
356                     7882095                 2.718
357                     7906044                 2.593
358                     7929139                 2.657
359                     7953178                 2.578
360                     7976746                 2.828
361                     8000536                 2.917
362                     8023167                 2.919
363                     8047690                 2.814
364                     8070408                 2.74
365                     8094926                 2.711
366                     8118031                 2.721
367                     8141879                 3.081
368                     8165128                 2.774
369                     8188867                 2.782
370                     8212707                 2.72
371                     8236340                 2.857
372                     8259939                 2.928
373                     8283147                 2.7910000000001
374                     8307420                 2.789
375                     8330867                 2.922
376                     8354232                 3.0699999999999
377                     8377940                 3.039
378                     8401810                 3.0110000000001
379                     8425503                 3.264
380                     8449272                 3.244
381                     8472386                 3.235
382                     8496542                 3.204
383                     8519970                 3.271
384                     8543927                 3.591
385                     8567869                 3.293
386                     8591153                 3.504
387                     8614736                 3.293
388                     8638076                 3.27
389                     8662554                 3.133
390                     8685309                 3.101
391                     8708612                 3.163
392                     8732985                 3.146
393                     8756469                 3.338
394                     8780627                 3.311
395                     8803787                 3.373
396                     8827404                 3.439
397                     8851228                 3.356
398                     8875243                 3.341
399                     8898548                 3.251
400                     8922227                 3.086
401                     8946865                 3.289
402                     8969725                 3.389
403                     8994144                 3.471
404                     9017548                 3.867
405                     9041515                 3.499
406                     9064250                 3.3910000000001
407                     9088907                 3.49
408                     9112112                 3.5250000000001
409                     9135411                 3.422
410                     9159558                 3.5060000000001
411                     9183631                 3.265
412                     9206508                 3.5650000000001
413                     9231126                 3.5680000000001
414                     9253911                 3.67
415                     9278951                 3.414
416                     9301858                 3.574
417                     9326042                 3.431
418                     9349209                 3.48
419                     9372796                 3.5020000000001
420                     9396610                 3.564
421                     9420511                 3.713
422                     9444761                 3.577
423                     9468004                 3.686
424                     9492136                 3.436
425                     9516501                 3.429
426                     9539653                 3.5709999999999
427                     9562785                 3.433
428                     9586909                 3.9010000000001
429                     9611344                 3.7470000000001
430                     9634531                 3.24
431                     9657918                 3.378
432                     9682227                 3.499
433                     9706023                 3.466
434                     9729141                 3.437
435                     9752806                 3.3960000000001
436                     9777017                 3.489
437                     9800462                 3.5740000000001
438                     9824205                 3.884
439                     9848063                 3.8399999999999
440                     9872769                 3.7669999999999
441                     9895904                 4.13
442                     9919914                 3.635
443                     9943588                 3.586
444                     9967058                 3.696
445                     9991302                 3.712
446                     10014650                        3.615
447                     10038708                        3.5830000000001
448                     10062297                        3.7190000000001
449                     10085424                        3.59
450                     10109893                        3.726
451                     10133742                        3.3739999999999
452                     10157553                        3.409
453                     10181301                        3.5569999999999
454                     10205208                        3.4989999999999
455                     10229764                        3.389
456                     10251916                        3.528
457                     10276510                        3.5
458                     10300775                        3.5409999999999
459                     10324220                        3.728
460                     10348027                        3.674
461                     10373150                        3.394
462                     10396106                        3.419
463                     10420201                        3.425
464                     10443174                        3.729
465                     10466445                        3.5309999999999
466                     10491022                        3.552
467                     10514851                        3.7329999999999
468                     10538264                        3.4680000000001
469                     10562721                        3.6160000000001
470                     10586505                        3.588
471                     10610118                        3.717
472                     10633409                        4.023
473                     10657817                        3.75
474                     10681190                        3.755
475                     10706131                        3.885
476                     10728911                        3.796
477                     10753642                        4.228
478                     10777288                        3.683
479                     10801903                        3.522
480                     10824601                        3.7330000000001
481                     10849060                        3.841
482                     10872871                        3.77
483                     10896548                        3.711
484                     10921102                        3.626
485                     10943979                        3.635
486                     10967663                        3.612
487                     10992308                        3.631
488                     11015391                        3.595
489                     11039104                        3.606
490                     11063797                        3.5609999999999
491                     11087153                        3.674
492                     11111017                        3.64
493                     11135027                        3.678
494                     11158861                        3.769
495                     11182235                        4.0989999999999
496                     11206999                        3.671
497                     11230560                        3.742
498                     11254576                        3.792
499                     11278149                        3.65
500                     11301399                        3.713

--Test 2: to find relation between size and running time (ran with 150 arrays):
7                       115199                  0.061
8                       133113                  0.069
9                       151451                  0.077
10                      169765                  0.077
11                      188318                  0.079
12                      207031                  0.094
13                      225671                  0.097
14                      244492                  0.09
15                      263052                  0.121
16                      281995                  0.124
17                      301318                  0.131
18                      320680                  0.153
19                      340138                  0.148
20                      359718                  0.155
21                      379228                  0.16
22                      398598                  0.175
23                      418276                  0.185
24                      437991                  0.177
25                      457776                  0.197
26                      477326                  0.207
27                      497200                  0.227
28                      516819                  0.219
29                      536599                  0.241
30                      556441                  0.219
31                      576332                  0.25
32                      596370                  0.264
33                      616348                  0.237
34                      636552                  0.258
35                      657056                  0.253
36                      677441                  0.312
37                      697718                  0.341
38                      718355                  0.312
39                      738833                  0.323
40                      759361                  0.302
41                      779724                  0.362
42                      800493                  0.384
43                      820844                  0.362
44                      841293                  0.363
45                      862249                  0.384
46                      882681                  0.388
47                      903363                  0.423
48                      923889                  0.437
49                      944346                  0.402
50                      965302                  0.393
51                      985852                  0.409
52                      1006748                 0.427
53                      1027124                 0.466
54                      1048460                 0.432
55                      1068975                 0.454
56                      1089800                 0.48
57                      1110558                 0.486
58                      1131461                 0.473
59                      1152427                 0.48
60                      1173114                 0.478
61                      1193890                 0.467
62                      1215033                 0.498
63                      1235678                 0.528
64                      1256702                 0.494
65                      1277611                 0.549
66                      1298425                 0.537
67                      1320108                 0.55
68                      1341582                 0.553
69                      1362683                 0.533
70                      1384055                 0.525
71                      1405360                 0.567
72                      1426914                 0.605
73                      1448401                 0.618
74                      1469586                 0.594
75                      1491081                 0.629
76                      1512422                 0.621
77                      1533873                 0.633
78                      1555699                 0.657
79                      1577236                 0.673
80                      1598466                 0.681
81                      1619957                 0.707
82                      1641754                 0.668
83                      1662980                 0.673
84                      1684572                 0.714
85                      1706238                 0.672
86                      1727528                 0.69600000000001
87                      1749467                 0.676
88                      1770947                 0.681
89                      1792320                 0.766
90                      1813998                 0.759
91                      1835699                 0.78
92                      1857252                 0.847
93                      1879240                 0.775
94                      1900683                 0.782
95                      1922248                 0.777
96                      1943806                 0.791
97                      1965616                 0.801
98                      1987375                 0.837
99                      2009100                 0.862
100                     2030781                 0.825
101                     2052545                 0.82700000000001
102                     2073836                 0.826
103                     2095974                 0.86
104                     2117563                 0.837
105                     2139072                 0.878
106                     2161144                 0.91
107                     2182310                 0.937
108                     2204572                 0.901
109                     2226192                 0.896
110                     2248332                 0.947
111                     2269868                 0.933
112                     2291886                 0.969
113                     2313530                 0.939
114                     2335121                 0.958
115                     2357291                 0.996
116                     2378836                 1.009
117                     2400384                 0.943
118                     2422979                 0.996
119                     2444306                 1.015
120                     2466404                 0.98999999999999
121                     2488115                 1.029
122                     2510039                 1.026
123                     2532211                 0.993
124                     2553593                 1.062
125                     2575561                 1.004
126                     2597566                 1.098
127                     2619219                 1.043
128                     2640946                 1.051
129                     2663187                 1.052
130                     2685056                 1.083
131                     2707067                 1.125
132                     2729260                 1.193
133                     2751732                 1.249
134                     2774262                 1.197
135                     2796282                 1.098
136                     2818861                 1.205
137                     2841271                 1.168
138                     2863308                 1.163
139                     2886380                 1.215
140                     2908301                 1.24
141                     2930590                 1.18
142                     2952894                 1.225
143                     2975288                 1.216
144                     2998061                 1.156
145                     3020446                 1.205
146                     3042958                 1.215
147                     3065432                 1.22
148                     3087458                 1.272
149                     3109597                 1.272
150                     3132592                 1.28

Runtime as function of size:

5.121076889312e-007
4.1008816895631e-007
5.028201652748e-007
5.27881754487e-007
5.3826703051849e-007
4.7180454983692e-007
5.2951848540352e-007
5.1835658425548e-007
5.0841526302236e-007
4.5356816776132e-007
4.1950318078994e-007
4.540382841217e-007
4.2982926472608e-007
3.6811020401485e-007
4.5998509800343e-007
4.3972410858349e-007
4.3475663584651e-007
4.7711113882999e-007
4.3511751112784e-007
4.3089308847486e-007
4.219097745947e-007
4.3903883110301e-007
4.4229169256663e-007
4.0411789283341e-007
4.3034147705428e-007
4.3366588034174e-007
4.5655671761867e-007
4.2374603100892e-007
4.4912495177963e-007
3.9357272379282e-007
4.3377775310064e-007
4.4267820312893e-007
3.8452302919779e-007
4.0530860008295e-007
3.8505089368334e-007
4.605567126879e-007
4.8873613694931e-007
4.3432564679024e-007
4.3717592473536e-007
3.9770280538506e-007
4.6426684313937e-007
4.7970438217449e-007
4.4100949754155e-007
4.3147868816215e-007
4.4534699373383e-007
4.3956990124405e-007
4.6825030469479e-007
4.730005444377e-007
4.2569143089503e-007
4.0712647440904e-007
4.1486957474347e-007
4.2413791733383e-007
4.5369400383985e-007
4.1203288632852e-007
4.2470590986693e-007
4.4044778858506e-007
4.3761784616382e-007
4.1804357375111e-007
4.1651228233979e-007
4.0746253134819e-007
3.9115831441758e-007
4.0986541106291e-007
4.2729578417678e-007
3.9309239581062e-007
4.2970826018248e-007
4.135779887171e-007
4.166325785466e-007
4.1219992516298e-007
3.911401257666e-007
3.7932018597527e-007
4.0345534240337e-007
4.2399191542027e-007
4.2667741875351e-007
4.0419546729487e-007
4.2184160350779e-007
4.1059968712436e-007
4.1268084124305e-007
4.2231819908607e-007
4.266958147037e-007
4.2603345957937e-007
4.36431337375e-007
4.0688190800814e-007
4.0469518575088e-007
4.2384653193808e-007
3.9384892377265e-007
4.0288782584132e-007
3.8640340172178e-007
3.8454002293688e-007
4.2737903945724e-007
4.1841280971644e-007
4.2490626186537e-007
4.560501213621e-007
4.1240075775313e-007
4.1143104873354e-007
4.0421423250278e-007
4.0693361374541e-007
4.075058404083e-007
4.2115856343166e-007
4.2904783236275e-007
4.0624764561024e-007
4.029144306215e-007
3.9829571865856e-007
4.1031043324011e-007
3.9526568985197e-007
4.1045836699279e-007
4.2107328340916e-007
4.2936154808437e-007
4.0869610972107e-007
4.0248100792744e-007
4.2120113933352e-007
4.1103711757688e-007
4.227958982253e-007
4.0587327590306e-007
4.102571130147e-007
4.2251889987278e-007
4.2415702469611e-007
3.9285381005706e-007
4.1106423126243e-007
4.1525079102207e-007
4.0139409439816e-007
4.1356609320711e-007
4.0875858900997e-007
3.9214741583541e-007
4.1588459868115e-007
3.8981798528554e-007
4.2270340772862e-007
3.9821030620196e-007
3.9796345703396e-007
3.9501544577981e-007
4.0334354292797e-007
4.1557892730398e-007
4.3711482233279e-007
4.5389594626221e-007
4.3146609801093e-007
3.9266425918416e-007
4.2747762305413e-007
4.1108363123405e-007
4.0617355869505e-007
4.2094249544412e-007
4.2636577163093e-007
4.0264929587557e-007
4.1484726508977e-007
4.0869993089745e-007
3.8558254818698e-007
3.9894770507402e-007
3.9928254021252e-007
3.9798631970959e-007
4.1198941005837e-007
4.0905622175478e-007
4.0860731304939e-007
--]]

--Part 2 Extra Credit

function find_min_crossing(a,left,mid,right)

	local left_sum = -math.huge --negative infinity
	local sum = 0
	local min_left= 0 --storing index

	-- process left subarray
	for i = mid, left, -1 do
		sum = sum + a[i]
		cc.inc()
		if sum < left_sum then
			left_sum = sum
			min_left = i
		end
	end

	--find min subarray of form a[m+1..j]
	local right_sum = -math.huge --negative infinity
	sum = 0
	local min_right = 0 --storing index

	-- process right subarray
	for j = mid + 1, right do
		sum = sum + a[j]
		cc.inc()
		if sum < right_sum then
			right_sum = sum
			min_right = j
		end
	end

   return min_left, min_right, (left_sum + right_sum)
end


function find_min_subarray_rec(a, left, right)
   cc.inc()
	if left == right then --base case, array has only single element
		return left, right, a[left]
	else
		local m = math.floor((left + right)/2)
		local l_left, l_right, l_min_sum = find_min_subarray_rec(a, left, m)
		local r_left, r_right, r_min_sum = find_min_subarray_rec(a, m + 1, right)
		local c_left, c_right, c_min_sum = find_min_crossing(a, left, m, right)
		-- find min from the three halves
		cc.inc() --comparison count for if
		if l_min_sum <= r_min_sum and l_min_sum <= c_min_sum then
			return l_left, l_right, l_min_sum
		elseif r_min_sum <= l_min_sum and r_max_sum <= c_min_sum then
			cc.inc() --comparison count for elseif
			return r_left, r_right, r_min_sum
		else
			cc.inc() --comparison count for elseif occurs here too!
			return c_left, c_right, c_min_sum
		end
	end
end


function find_min_sub(a)
   left, right, sum = find_min_subarray_rec(a, 1, #a)

   --standardize outputs in case of negative sums
	if(sum <= 0) then
		left = 0
		right = 0
		sum = 0
	end

	return left, right, sum
end
